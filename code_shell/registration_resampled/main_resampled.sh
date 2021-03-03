#!/bin/bash

T1_baseline=/mnt/f/utente/tesi/dati/001142_20150411/T1.nii.gz
T1_follow=/mnt/f/utente/tesi/dati/001142_20190429/T1.nii.gz

FLAIR_baseline=/mnt/f/utente/tesi/dati/001142_20150411/FLAIR_to_T1.nii.gz
FLAIR_follow=/mnt/f/utente/tesi/dati/001142_20190429/FLAIR_to_T1.nii.gz

T1_brain_baseline=/mnt/f/utente/tesi/dati/001142_20150411/T1_brain.nii.gz
T1_brain_follow=/mnt/f/utente/tesi/dati/001142_20190429/T1_brain.nii.gz

FLAIR_brain_baseline=/mnt/f/utente/tesi/dati/001142_20150411/FLAIR_to_T1_brain.nii.gz
FLAIR_brain_follow=/mnt/f/utente/tesi/dati/001142_20190429/FLAIR_to_T1_brain.nii.gz

output=/mnt/f/utente/tesi/output/001142/20150411_20190429/

lesion_mask_baseline=/mnt/f/utente/tesi/dati/001142_20150411/baseline_2ch/baseline_2ch_prob_1.nii.gz
lesion_mask_follow=/mnt/f/utente/tesi/dati/001142_20190429/baseline_2ch/baseline_2ch_prob_1.nii.gz

registration_resampled $T1_baseline $T1_follow $FLAIR_baseline $FLAIR_follow $T1_brain_baseline $T1_brain_follow $FLAIR_brain_baseline $FLAIR_brain_follow $output -m1 $lesion_mask_baseline -m2 $lesion_mask_follow

