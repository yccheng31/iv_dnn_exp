#!/bin/bash

# 1. convert splited files into Kaldi archives
#for i in 0 1 2 3 4 5 6 7
#do
#        echo perl/trans_HTK_data_2_kaldi_state_suffix.pl sliced_raw/exp_s_8_m_2_ubm_0_0_0_y_64_UBM_only/recognizer/Models_8_states_2_mixtures/hmm_mix_0_sep_mix_per_state__4/sliced_feature/train/Sliced_outdir/ $i data/trainJPGs_UE_state_$i.ark
#        perl/trans_HTK_data_2_kaldi_state_suffix.pl sliced_raw/exp_s_8_m_2_ubm_0_0_0_y_64_UBM_only/recognizer/Models_8_states_2_mixtures/hmm_mix_0_sep_mix_per_state__4/sliced_feature/train/Sliced_outdir/ $i data/trainJPGs_UE_state_$i.ark
#        echo perl/trans_HTK_data_2_kaldi_state_suffix.pl sliced_raw/exp_s_8_m_2_ubm_0_0_0_y_64_UBM_only/recognizer/Models_8_states_2_mixtures/hmm_mix_0_sep_mix_per_state__4/sliced_feature/test/Sliced_outdir/ $i data/testJPGs_UE_state_$i.ark
#        perl/trans_HTK_data_2_kaldi_state_suffix.pl sliced_raw/exp_s_8_m_2_ubm_0_0_0_y_64_UBM_only/recognizer/Models_8_states_2_mixtures/hmm_mix_0_sep_mix_per_state__4/sliced_feature/test/Sliced_outdir/ $i data/testJPGs_UE_state_$i.ark
#done  

# 2. get UBM for each state

for i in 0 1 2 3 4 5 6 7
do
	echo iv_scripts/train_diag_ubm_iv_state.sh data $i 52 exp/diag_ubm_state_$i
	iv_scripts/train_diag_ubm_iv_state.sh data $i 52 exp/diag_ubm_state_$i
	echo iv_scripts/train_ivector_extractor.sh exp/diag_ubm_state_$i/final.dubm data iv_ext/$i $i
	iv_scripts/train_ivector_extractor.sh exp/diag_ubm_state_$i/final.dubm data iv_ext/$i $i
	echo iv_scripts/extract_ivectors.sh iv_ext/$i data iv_by_kaldi/$i $i
	iv_scripts/extract_ivectors.sh iv_ext/$i data iv_by_kaldi/$i $i
done


perl/cvt_in_dir_kaldi_iv_into_libsvm.pl iv_by_kaldi/ iv_libsvm_by_kaldi/
perl/look_up_id_ans_mlf.pl iv_libsvm_by_kaldi/train.libsvm.id scripts/trainJPGs_FE.mlf iv_libsvm_by_kaldi/train.libsvm.ans
perl/look_up_id_ans_mlf.pl iv_libsvm_by_kaldi/test.libsvm.id scripts/testJPGs_FE.mlf iv_libsvm_by_kaldi/test.libsvm.ans

paste -d " " iv_libsvm_by_kaldi/train.libsvm.ans iv_libsvm_by_kaldi/train.libsvm.data > iv_libsvm_by_kaldi/train.libsvm
paste -d " " iv_libsvm_by_kaldi/test.libsvm.ans iv_libsvm_by_kaldi/test.libsvm.data > iv_libsvm_by_kaldi/test.libsvm

~/tools/libsvm-3.18/svm-train -s 0 -t 0 -c 1 -b 1 iv_libsvm_by_kaldi/train.libsvm iv_libsvm_by_kaldi/train.libsvm.model
~/tools/libsvm-3.18/svm-predict -b 1 iv_libsvm_by_kaldi/test.libsvm iv_libsvm_by_kaldi/train.libsvm.model iv_libsvm_by_kaldi/test.libsvm.predict


