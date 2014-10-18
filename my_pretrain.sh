#!/bin/bash

nohup ./pretrain_dbn.sh gmmsv_dbn/1/ gmmsv_dbn/1/dbn_exp/ > nohup_pretrain_1.log 2>&1 &
wait
nohup ./pretrain_dbn.sh gmmsv_dbn/2/ gmmsv_dbn/2/dbn_exp/ > nohup_pretrain_2.log 2>&1 &
wait
nohup ./pretrain_dbn.sh gmmsv_dbn/3/ gmmsv_dbn/3/dbn_exp/ > nohup_pretrain_3.log 2>&1 &
wait
nohup ./pretrain_dbn.sh gmmsv_dbn/4/ gmmsv_dbn/4/dbn_exp/ > nohup_pretrain_4.log 2>&1 &
wait
nohup ./pretrain_dbn.sh gmmsv_dbn/5/ gmmsv_dbn/5/dbn_exp/ > nohup_pretrain_5.log 2>&1 &
wait
nohup ./pretrain_dbn.sh gmmsv_dbn/6/ gmmsv_dbn/6/dbn_exp/ > nohup_pretrain_6.log 2>&1 &
wait
nohup ./pretrain_dbn.sh gmmsv_dbn/7/ gmmsv_dbn/7/dbn_exp/ > nohup_pretrain_7.log 2>&1 &
wait
nohup ./pretrain_dbn.sh gmmsv_dbn/8/ gmmsv_dbn/8/dbn_exp/ > nohup_pretrain_8.log 2>&1 &
wait


nnet-forward gmmsv_dbn/1/dbn_exp/6.dbn ark:gmmsv/1/TV_F_X_1.ark ark,t:gmmsv/1/TV_F_X_1_dbn_out.ark
nnet-forward gmmsv_dbn/2/dbn_exp/6.dbn ark:gmmsv/2/TV_F_X_2.ark ark,t:gmmsv/2/TV_F_X_2_dbn_out.ark
nnet-forward gmmsv_dbn/3/dbn_exp/6.dbn ark:gmmsv/3/TV_F_X_3.ark ark,t:gmmsv/3/TV_F_X_3_dbn_out.ark
nnet-forward gmmsv_dbn/4/dbn_exp/6.dbn ark:gmmsv/4/TV_F_X_4.ark ark,t:gmmsv/4/TV_F_X_4_dbn_out.ark
nnet-forward gmmsv_dbn/5/dbn_exp/6.dbn ark:gmmsv/5/TV_F_X_5.ark ark,t:gmmsv/5/TV_F_X_5_dbn_out.ark
nnet-forward gmmsv_dbn/6/dbn_exp/6.dbn ark:gmmsv/6/TV_F_X_6.ark ark,t:gmmsv/6/TV_F_X_6_dbn_out.ark
nnet-forward gmmsv_dbn/7/dbn_exp/6.dbn ark:gmmsv/7/TV_F_X_7.ark ark,t:gmmsv/7/TV_F_X_7_dbn_out.ark
nnet-forward gmmsv_dbn/8/dbn_exp/6.dbn ark:gmmsv/8/TV_F_X_8.ark ark,t:gmmsv/8/TV_F_X_8_dbn_out.ark

nnet-forward gmmsv_dbn/1/dbn_exp/6.dbn ark:gmmsv/1/TV_Target_F_X_1.ark ark,t:gmmsv/1/TV_Target_F_X_1_dbn_out.ark
nnet-forward gmmsv_dbn/2/dbn_exp/6.dbn ark:gmmsv/2/TV_Target_F_X_2.ark ark,t:gmmsv/2/TV_Target_F_X_2_dbn_out.ark
nnet-forward gmmsv_dbn/3/dbn_exp/6.dbn ark:gmmsv/3/TV_Target_F_X_3.ark ark,t:gmmsv/3/TV_Target_F_X_3_dbn_out.ark
nnet-forward gmmsv_dbn/4/dbn_exp/6.dbn ark:gmmsv/4/TV_Target_F_X_4.ark ark,t:gmmsv/4/TV_Target_F_X_4_dbn_out.ark
nnet-forward gmmsv_dbn/5/dbn_exp/6.dbn ark:gmmsv/5/TV_Target_F_X_5.ark ark,t:gmmsv/5/TV_Target_F_X_5_dbn_out.ark
nnet-forward gmmsv_dbn/6/dbn_exp/6.dbn ark:gmmsv/6/TV_Target_F_X_6.ark ark,t:gmmsv/6/TV_Target_F_X_6_dbn_out.ark
nnet-forward gmmsv_dbn/7/dbn_exp/6.dbn ark:gmmsv/7/TV_Target_F_X_7.ark ark,t:gmmsv/7/TV_Target_F_X_7_dbn_out.ark
nnet-forward gmmsv_dbn/8/dbn_exp/6.dbn ark:gmmsv/8/TV_Target_F_X_8.ark ark,t:gmmsv/8/TV_Target_F_X_8_dbn_out.ark


perl/trans_kaldi_data_2_raw_mat.pl gmmsv/1/TV_F_X_1_dbn_out.ark gmmsv/dbn_outs/TV_F_X_1_dbn_out.txt
perl/trans_kaldi_data_2_raw_mat.pl gmmsv/2/TV_F_X_2_dbn_out.ark gmmsv/dbn_outs/TV_F_X_2_dbn_out.txt
perl/trans_kaldi_data_2_raw_mat.pl gmmsv/3/TV_F_X_3_dbn_out.ark gmmsv/dbn_outs/TV_F_X_3_dbn_out.txt
perl/trans_kaldi_data_2_raw_mat.pl gmmsv/4/TV_F_X_4_dbn_out.ark gmmsv/dbn_outs/TV_F_X_4_dbn_out.txt
perl/trans_kaldi_data_2_raw_mat.pl gmmsv/5/TV_F_X_5_dbn_out.ark gmmsv/dbn_outs/TV_F_X_5_dbn_out.txt
perl/trans_kaldi_data_2_raw_mat.pl gmmsv/6/TV_F_X_6_dbn_out.ark gmmsv/dbn_outs/TV_F_X_6_dbn_out.txt
perl/trans_kaldi_data_2_raw_mat.pl gmmsv/7/TV_F_X_7_dbn_out.ark gmmsv/dbn_outs/TV_F_X_7_dbn_out.txt
perl/trans_kaldi_data_2_raw_mat.pl gmmsv/8/TV_F_X_8_dbn_out.ark gmmsv/dbn_outs/TV_F_X_8_dbn_out.txt

perl/trans_kaldi_data_2_raw_mat.pl gmmsv/1/TV_Target_F_X_1_dbn_out.ark gmmsv/dbn_outs/TV_Target_F_X_1_dbn_out.txt
perl/trans_kaldi_data_2_raw_mat.pl gmmsv/2/TV_Target_F_X_2_dbn_out.ark gmmsv/dbn_outs/TV_Target_F_X_2_dbn_out.txt
perl/trans_kaldi_data_2_raw_mat.pl gmmsv/3/TV_Target_F_X_3_dbn_out.ark gmmsv/dbn_outs/TV_Target_F_X_3_dbn_out.txt
perl/trans_kaldi_data_2_raw_mat.pl gmmsv/4/TV_Target_F_X_4_dbn_out.ark gmmsv/dbn_outs/TV_Target_F_X_4_dbn_out.txt
perl/trans_kaldi_data_2_raw_mat.pl gmmsv/5/TV_Target_F_X_5_dbn_out.ark gmmsv/dbn_outs/TV_Target_F_X_5_dbn_out.txt
perl/trans_kaldi_data_2_raw_mat.pl gmmsv/6/TV_Target_F_X_6_dbn_out.ark gmmsv/dbn_outs/TV_Target_F_X_6_dbn_out.txt
perl/trans_kaldi_data_2_raw_mat.pl gmmsv/7/TV_Target_F_X_7_dbn_out.ark gmmsv/dbn_outs/TV_Target_F_X_7_dbn_out.txt
perl/trans_kaldi_data_2_raw_mat.pl gmmsv/8/TV_Target_F_X_8_dbn_out.ark gmmsv/dbn_outs/TV_Target_F_X_8_dbn_out.txt



