#!/bin/bash

. ./cmd.sh ## You'll want to change cmd.sh to something that will work on your system.
. ./path.sh           ## This relates to the queue.
dtype=mfcc_tri_sp_$1_node_$2
snum=$1
node=$2
nj=10
cmd=run.pl
compress=false
#RBM pretrain
data=/RAID3/zhuang/dnn/data
exp=/RAID3/zhuang/dnn/exp
dir=$exp/aenc_pretrain_${dtype}
splice=$exp/splice_$dtype.nnet
feature_transform=med/feature_$dtype.transform
utils/nnet/gen_splice.py --fea-dim=39 --splice=$snum --splice-step=1 > $splice
#cwmpute transform matrix
nnet-forward  --use-gpu-id=0 \
  $splice  scp:$data/train/feats.scp ark:- | \
  compute-cmvn-stats ark:- - | \
  cmvn-to-nnet - - | \
  nnet-concat --binary=false $splice - $feature_transform \
|| exit 1;

$cuda_cmd $dir/_pretrain_dbn.log \
  steps/pretrain_dbn_aenc.sh --use-gpu-id 0 --feature-transform $feature_transform --nn-depth 5 --hid-dim 1024:512:256:128:$node --rbm-iter 3 $data/train $dir
. ./path.sh
pretrain_dnn=$dir/5.dbn
dir=$exp/aenc_dnn_${dtype}_$node
init_rdnn=$dir/init.nnet
if [ ! -d "$dir" ]; then
  mkdir -p $dir
fi
utils/nnet/gen_tied_aenc.py  $pretrain_dnn $init_rdnn
$cuda_cmd $dir/_train_nnet.log \
  steps/train_nnet_mse.sh --use-gpu-id 0 --mlp-init $init_rdnn --cache-size 32768 --bunch-size 256 --learn-rate 0.00001  --use-gpu-id 0 --feature-transform $feature_transform \
  $data/train $data/dev data/lang $dir || exit 1;

complete_encoder=$dir/final.nnet
auto_encoder=$dir/auto_encoder.nnet
outdir=/RAID3/zhuang/dnn/res/aenc_dnn_${dtype}
logdir=/RAID3/zhuang/dnn/log
if [ ! -d "$outdir" ]; then
  mkdir -p $outdir
fi
if [ ! -d "$logdir" ]; then
  mkdir -p $logdir
fi
utils/nnet/extract_tied_aenc.py $complete_encoder 10 $auto_encoder
trainscp=$data/train/feats.scp
devscp=$data/dev/feats.scp
evalscp=$data/eval/feats.scp
split_scps=""
for ((n=1; n<=nj; n++)); do
  split_scps="$split_scps $logdir/wav.$n.scp"
done
utils/split_scp.pl $trainscp $split_scps || exit 1;
$cmd JOB=1:$nj $logdir/make_train.JOB.log \
  copy-feats --compress=$compress scp:$logdir/wav.JOB.scp ark:- \| \
  nnet-forward --use-gpu-id=-1 --feature-transform=$feature_transform $auto_encoder ark:- ark,t:- \| \
  steps/bi2int.pl -  $outdir/train.JOB.ali \
  || exit 1;
utils/split_scp.pl $devscp $split_scps || exit 1;
$cmd JOB=1:$nj $logdir/make_dev.JOB.log \
  copy-feats --compress=$compress scp:$logdir/wav.JOB.scp ark:- \| \
  nnet-forward --use-gpu-id=-1 --feature-transform=$feature_transform $auto_encoder ark:- ark,t:- \| \
  steps/bi2int.pl -  $outdir/dev.JOB.ali \
  || exit 1;
utils/split_scp.pl $evalscp $split_scps || exit 1;
$cmd JOB=1:$nj $logdir/make_eval.JOB.log \
  copy-feats --compress=$compress scp:$logdir/wav.JOB.scp ark:- \| \
  nnet-forward --use-gpu-id=-1 --feature-transform=$feature_transform $auto_encoder ark:- ark,t:- \| \
  steps/bi2int.pl -  $outdir/eval.JOB.ali \
  || exit 1;

# # forward-backward decoding example [way to speed up decoding by decoding forward
# # and backward in time]
# local/run_fwdbwd.sh

