#!/bin/bash


T1_baseline=/mnt/f/utente/tesi/dati/000018_20140609/T1.nii.gz
T1_follow=/mnt/f/utente/tesi/dati/000018_20190325/T1.nii.gz

T2_baseline=/mnt/f/utente/tesi/dati/001142_20150411/T2_to_T1.nii.gz
T2_follow=/mnt/f/utente/tesi/dati/001142_20190429/T2_to_T1.nii.gz

FLAIR_baseline=/mnt/f/utente/tesi/dati/000018_20140609/FLAIR_to_T1.nii.gz
FLAIR_follow=/mnt/f/utente/tesi/dati/000018_20190325/FLAIR_to_T1.nii.gz

T1_brain_baseline=/mnt/f/utente/tesi/dati/000018_20140609/T1_brain.nii.gz
T1_brain_follow=/mnt/f/utente/tesi/dati/000018_20190325/T1_brain.nii.gz

T2_brain_baseline=/mnt/f/utente/tesi/dati/001142_20150411/T2_to_T1_brain.nii.gz
T2_brain_follow=/mnt/f/utente/tesi/dati/001142_20190429/T2_to_T1_brain.nii.gz

FLAIR_brain_baseline=/mnt/f/utente/tesi/dati/000018_20140609/FLAIR_to_T1_brain.nii.gz
FLAIR_brain_follow=/mnt/f/utente/tesi/dati/000018_20190325/FLAIR_to_T1_brain.nii.gz

lesion_mask_baseline=/mnt/f/utente/tesi/dati/000018_20140609/baseline_2ch/baseline_2ch_prob_1.nii.gz
lesion_mask_follow=/mnt/f/utente/tesi/dati/000018_20190325/baseline_2ch/baseline_2ch_prob_1.nii.gz

output=/mnt/f/utente/tesi/output/000018/20140609_20190325/

registration_robust_template $T1_baseline $T1_follow $T2_baseline $T2_follow $FLAIR_baseline $FLAIR_follow $lesion_mask_baseline $lesion_mask_follow $output -t1_baseline $T1_brain_baseline -t1_follow $T1_brain_follow -t2_baseline $T2_brain_baseline -t2_follow $T2_brain_follow -flair_baseline $FLAIR_brain_baseline -flair_follow $FLAIR_brain_follow 





