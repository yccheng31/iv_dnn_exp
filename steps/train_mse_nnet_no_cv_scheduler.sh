#!/bin/bash

# You-Chi Cheng yccheng@gatech.edu
# Edited from
# Copyright 2012  Karel Vesely (Brno University of Technology)
# Apache 2.0

# Train neural network

# Begin configuration.

# training options
learn_rate=0.008
momentum=0
l1_penalty=0
l2_penalty=0
# data processing
bunch_size=256
cache_size=16384
seed=777
feature_transform=
# learn rate scheduling
max_iters=20
min_iters=
start_halving_inc=0.5
end_halving_inc=0.1
halving_factor=0.5
# misc.
verbose=1
# gpu
use_gpu_id=
# tool
train_tool="nnet-train-mse-tgtmat-frmshuff"
 
# End configuration.

echo "$0 $@"  # Print the command line for logging
[ -f path.sh ] && . ./path.sh; 

. parse_options.sh || exit 1;

if [ $# != 4 ]; then
   echo "Usage: $0 <mlp-init> <feats-tr> <labels-tr> <exp-dir>"
   echo " e.g.: $0 0.nnet scp:train.scp ark:labels_tr.ark exp/dnn1"
   echo "main options (for others, see top of script file)"
   echo "  --config <config-file>  # config containing options"
   exit 1;
fi

mlp_init=$1
feats_tr=$2
labels_tr=$3
dir=$4

[ ! -d $dir ] && mkdir $dir
[ ! -d $dir/log ] && mkdir $dir/log
[ ! -d $dir/nnet ] && mkdir $dir/nnet

# Skip training
[ -e $dir/final.nnet ] && echo "'$dir/final.nnet' exists, skipping training" && exit 0

##############################
#start training

#choose mlp to start with
mlp_best=$mlp_init
mlp_base=${mlp_init##*/}; mlp_base=${mlp_base%.*}
#optionally resume training from the best epoch
[ -e $dir/.mlp_best ] && mlp_best=$(cat $dir/.mlp_best)
[ -e $dir/.learn_rate ] && learn_rate=$(cat $dir/.learn_rate)

#resume lr-halving
halving=0
[ -e $dir/.halving ] && halving=$(cat $dir/.halving)
#training
mse=1.79769e+308
for iter in $(seq -w $max_iters); do
  echo -n "ITERATION $iter: "
  mlp_next=$dir/nnet/${mlp_base}_iter${iter}
  
  #skip iteration if already done
  [ -e $dir/.done_iter$iter ] && echo -n "skipping... " && ls $mlp_next* && continue 
  
  #training
  $train_tool \
   --learn-rate=$learn_rate --momentum=$momentum --l1-penalty=$l1_penalty --l2-penalty=$l2_penalty \
   --bunchsize=$bunch_size --cachesize=$cache_size --randomize=true --verbose=$verbose \
   ${feature_transform:+ --feature-transform=$feature_transform} \
   ${use_gpu_id:+ --use-gpu-id=$use_gpu_id} \
   ${seed:+ --seed=$seed} \
   $mlp_best "$feats_tr" "$labels_tr" $mlp_next \
   2> $dir/log/iter$iter.log || exit 1; 

  tr_mse=$(cat $dir/log/iter$iter.log | awk 'BEGIN{FS=":"} /err\/frm:/{ mse = $NF; } END{print mse}')
  echo -n "TRAIN MSE $(printf "%.2f" $tr_mse),lrate$(printf "%.6g" $learn_rate)), "
  

  #accept or reject new parameters (based no per-frame accuracy)
  mse_prev=$mse
  if [ "1" == "$(awk "BEGIN{print($tr_mse<$mse);}")" ]; then
    mse=$tr_mse
    mlp_best=$dir/nnet/${mlp_base}_iter${iter}_learnrate${learn_rate}_tr$(printf "%.4e" $mse_prev)_cv$(printf "%.4e" $mse)
    mv $mlp_next $mlp_best
    echo "nnet accepted ($(basename $mlp_best))"
    echo $mlp_best > $dir/.mlp_best 
  else
    mlp_reject=$dir/nnet/${mlp_base}_iter${iter}_learnrate${learn_rate}_tr$(printf "%.4e" $mse_prev)_cv$(printf "%.4e" $mse)_rejected
    mv $mlp_next $mlp_reject
    echo "nnet rejected ($(basename $mlp_reject))"
  fi

  #create .done file as a mark that iteration is over
  touch $dir/.done_iter$iter

  #stopping criterion
  if [[ "1" == "$halving" && "1" == "$(awk "BEGIN{print($mse > $mse_prev-$end_halving_inc)}")" ]]; then
    if [[ "$min_iters" != "" ]]; then
      if [ $min_iters -gt $iter ]; then
        echo we were supposed to finish, but we continue, min_iters : $min_iters
        continue
      fi
    fi
    echo finished, too small improvement $(awk "BEGIN{print($mse_prev-$mse)}")
    break
  fi

  #start annealing when improvement is low
  if [ "1" == "$(awk "BEGIN{print($mse > $mse_prev-$start_halving_inc)}")" ]; then
    halving=1
    echo $halving >$dir/.halving
  fi
  
  #do annealing
  if [ "1" == "$halving" ]; then
    learn_rate=$(awk "BEGIN{print($learn_rate*$halving_factor)}")
    echo $learn_rate >$dir/.learn_rate
  fi
done

#select the best network
if [ $mlp_best != $mlp_init ]; then 
  mlp_final=${mlp_best}_final_
  ( cd $dir/nnet; ln -s $(basename $mlp_best) $(basename $mlp_final); )
  ( cd $dir; ln -s nnet/$(basename $mlp_final) final.nnet; )
  echo "Succeeded training the Neural Network : $dir/final.nnet"
else
  "Error training neural network..."
  exit 1
fi




