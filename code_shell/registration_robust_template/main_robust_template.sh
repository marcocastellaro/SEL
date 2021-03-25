#!/bin/bash


T1_baseline=/mnt/f/utente/tesi/dati/000867_20150907/T1.nii.gz
T1_follow=/mnt/f/utente/tesi/dati/000867_20190415/T1.nii.gz

T2_baseline=/mnt/f/utente/tesi/dati/000867_20150907/T2_to_T1.nii.gz
T2_follow=/mnt/f/utente/tesi/dati/000867_20190415/T2_to_T1.nii.gz

FLAIR_baseline=/mnt/f/utente/tesi/dati/000867_20150907/FLAIR_to_T1.nii.gz
FLAIR_follow=/mnt/f/utente/tesi/dati/000867_20190415/FLAIR_to_T1.nii.gz

T1_brain_baseline=/mnt/f/utente/tesi/dati/000867_20150907/T1_brain.nii.gz
T1_brain_follow=/mnt/f/utente/tesi/dati/000867_20190415/T1_brain.nii.gz

T2_brain_baseline=/mnt/f/utente/tesi/dati/000867_20150907/T2_to_T1_brain.nii.gz
T2_brain_follow=/mnt/f/utente/tesi/dati/000867_20190415/T2_to_T1_brain.nii.gz

FLAIR_brain_baseline=/mnt/f/utente/tesi/dati/000867_20150907/FLAIR_to_T1_brain.nii.gz
FLAIR_brain_follow=/mnt/f/utente/tesi/dati/000867_20190415/FLAIR_to_T1_brain.nii.gz

lesion_mask_baseline=/mnt/f/utente/tesi/dati/000867_20150907/baseline_2ch/baseline_2ch_prob_1.nii.gz
lesion_mask_follow=/mnt/f/utente/tesi/dati/000867_20190415/baseline_2ch/baseline_2ch_prob_1.nii.gz

output=/mnt/f/utente/tesi/output/000867/20150907_20190415/

registration_robust_template $T1_baseline $T1_follow $T2_baseline $T2_follow $FLAIR_baseline $FLAIR_follow $lesion_mask_baseline $lesion_mask_follow $output -t1_baseline $T1_brain_baseline -t1_follow $T1_brain_follow -t2_baseline $T2_brain_baseline -t2_follow $T2_brain_follow -flair_baseline $FLAIR_brain_baseline -flair_follow $FLAIR_brain_follow 





