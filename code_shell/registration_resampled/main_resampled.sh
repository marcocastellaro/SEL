#!/bin/bash

T1_baseline=/mnt/f/utente/tesi/dati/000004_20140428/T1.nii.gz
T1_follow=/mnt/f/utente/tesi/dati/000004_20190304/T1.nii.gz

FLAIR_baseline=/mnt/f/utente/tesi/dati/000004_20140428/FLAIR_to_T1.nii.gz
FLAIR_follow=/mnt/f/utente/tesi/dati/000004_20190304/FLAIR_to_T1.nii.gz

T1_brain_baseline=/mnt/f/utente/tesi/dati/000004_20140428/T1_brain.nii.gz
T1_brain_follow=/mnt/f/utente/tesi/dati/000004_20190304/T1_brain.nii.gz

FLAIR_brain_baseline=/mnt/f/utente/tesi/dati/000004_20140428/FLAIR_to_T1_brain.nii.gz
FLAIR_brain_follow=/mnt/f/utente/tesi/dati/000004_20190304/FLAIR_to_T1_brain.nii.gz

output=/mnt/f/utente/tesi/output/000004/20140428_20190304/

lesion_mask_baseline=/mnt/f/utente/tesi/dati/000004_20140428/baseline_2ch/baseline_2ch_prob_1.nii.gz
lesion_mask_follow=/mnt/f/utente/tesi/dati/000004_20190304/baseline_2ch/baseline_2ch_prob_1.nii.gz

registration_resampled $T1_baseline $T1_follow $FLAIR_baseline $FLAIR_follow $T1_brain_baseline $T1_brain_follow $FLAIR_brain_baseline $FLAIR_brain_follow $output -m1 $lesion_mask_baseline -m2 $lesion_mask_follow

