#!/bin/bash

#perl/trans_data_2_kaldi_by_ndx.pl mat/1/TV_Target_F_X.matx ndx/test_1.ndx gmmsv/1/TV_Target_F_X_1.ark
#perl/trans_data_2_kaldi_by_ndx.pl mat/2/TV_Target_F_X.matx ndx/test_2.ndx gmmsv/2/TV_Target_F_X_2.ark
#perl/trans_data_2_kaldi_by_ndx.pl mat/3/TV_Target_F_X.matx ndx/test_3.ndx gmmsv/3/TV_Target_F_X_3.ark
#perl/trans_data_2_kaldi_by_ndx.pl mat/4/TV_Target_F_X.matx ndx/test_4.ndx gmmsv/4/TV_Target_F_X_4.ark
#perl/trans_data_2_kaldi_by_ndx.pl mat/5/TV_Target_F_X.matx ndx/test_5.ndx gmmsv/5/TV_Target_F_X_5.ark
#perl/trans_data_2_kaldi_by_ndx.pl mat/6/TV_Target_F_X.matx ndx/test_6.ndx gmmsv/6/TV_Target_F_X_6.ark
#perl/trans_data_2_kaldi_by_ndx.pl mat/7/TV_Target_F_X.matx ndx/test_7.ndx gmmsv/7/TV_Target_F_X_7.ark
#perl/trans_data_2_kaldi_by_ndx.pl mat/8/TV_Target_F_X.matx ndx/test_8.ndx gmmsv/8/TV_Target_F_X_8.ark


#perl/trans_data_in_a_dir_2_kaldi_by_ndx.pl iv/test/ ndx/test_1.ndx gmmsv/1/iv_Target_1.ark
#perl/trans_data_in_a_dir_2_kaldi_by_ndx.pl iv/test/ ndx/test_2.ndx gmmsv/2/iv_Target_2.ark
#perl/trans_data_in_a_dir_2_kaldi_by_ndx.pl iv/test/ ndx/test_3.ndx gmmsv/3/iv_Target_3.ark
#perl/trans_data_in_a_dir_2_kaldi_by_ndx.pl iv/test/ ndx/test_4.ndx gmmsv/4/iv_Target_4.ark
#perl/trans_data_in_a_dir_2_kaldi_by_ndx.pl iv/test/ ndx/test_5.ndx gmmsv/5/iv_Target_5.ark
#perl/trans_data_in_a_dir_2_kaldi_by_ndx.pl iv/test/ ndx/test_6.ndx gmmsv/6/iv_Target_6.ark
#perl/trans_data_in_a_dir_2_kaldi_by_ndx.pl iv/test/ ndx/test_7.ndx gmmsv/7/iv_Target_7.ark
#perl/trans_data_in_a_dir_2_kaldi_by_ndx.pl iv/test/ ndx/test_8.ndx gmmsv/8/iv_Target_8.ark


nnet-forward gmmsv_dbn/1/dbn_exp/6.dbn ark:gmmsv/1/TV_Target_F_X_1.ark ark,t:gmmsv/1/TV_Target_F_X_1_dbn_out.ark
nnet-forward gmmsv_dbn/2/dbn_exp/6.dbn ark:gmmsv/2/TV_Target_F_X_2.ark ark,t:gmmsv/2/TV_Target_F_X_2_dbn_out.ark
nnet-forward gmmsv_dbn/3/dbn_exp/6.dbn ark:gmmsv/3/TV_Target_F_X_3.ark ark,t:gmmsv/3/TV_Target_F_X_3_dbn_out.ark
nnet-forward gmmsv_dbn/4/dbn_exp/6.dbn ark:gmmsv/4/TV_Target_F_X_4.ark ark,t:gmmsv/4/TV_Target_F_X_4_dbn_out.ark
nnet-forward gmmsv_dbn/5/dbn_exp/6.dbn ark:gmmsv/5/TV_Target_F_X_5.ark ark,t:gmmsv/5/TV_Target_F_X_5_dbn_out.ark
nnet-forward gmmsv_dbn/6/dbn_exp/6.dbn ark:gmmsv/6/TV_Target_F_X_6.ark ark,t:gmmsv/6/TV_Target_F_X_6_dbn_out.ark
nnet-forward gmmsv_dbn/7/dbn_exp/6.dbn ark:gmmsv/7/TV_Target_F_X_7.ark ark,t:gmmsv/7/TV_Target_F_X_7_dbn_out.ark
nnet-forward gmmsv_dbn/8/dbn_exp/6.dbn ark:gmmsv/8/TV_Target_F_X_8.ark ark,t:gmmsv/8/TV_Target_F_X_8_dbn_out.ark

