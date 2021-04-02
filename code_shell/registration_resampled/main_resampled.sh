#!/bin/bash

T1_baseline=/mnt/f/utente/tesi/dati/000336_20151214/T1.nii.gz
T1_follow=/mnt/f/utente/tesi/dati/000336_20190506/T1.nii.gz

FLAIR_baseline=/mnt/f/utente/tesi/dati/000336_20151214/FLAIR_to_T1.nii.gz
FLAIR_follow=/mnt/f/utente/tesi/dati/000336_20190506/FLAIR_to_T1.nii.gz

T1_brain_baseline=/mnt/f/utente/tesi/dati/000336_20151214/T1_brain.nii.gz
T1_brain_follow=/mnt/f/utente/tesi/dati/000336_20190506/T1_brain.nii.gz

FLAIR_brain_baseline=/mnt/f/utente/tesi/dati/000336_20151214/FLAIR_to_T1_brain.nii.gz
FLAIR_brain_follow=/mnt/f/utente/tesi/dati/000336_20190506/FLAIR_to_T1_brain.nii.gz

output=/mnt/f/utente/tesi/output/000336/20151214_20190506/

lesion_mask_baseline=/mnt/f/utente/tesi/dati/000336_20151214/baseline_2ch/baseline_2ch_prob_1.nii.gz
lesion_mask_follow=/mnt/f/utente/tesi/dati/000336_20190506/baseline_2ch/baseline_2ch_prob_1.nii.gz

T2_baseline=/mnt/f/utente/tesi/dati/000336_20151214/T2_to_T1.nii.gz
T1_follow=/mnt/f/utente/tesi/dati/000336_20190506/T2_to_T1.nii.gz


T2_brain_baseline=/mnt/f/utente/tesi/dati/000336_20151214/T2_to_T1_brain.nii.gz
T2_brain_follow=/mnt/f/utente/tesi/dati/000336_20190506/T2_to_T1_brain.nii.gz

registration_resampled $T1_baseline $T1_follow $FLAIR_baseline $FLAIR_follow $T1_brain_baseline $T1_brain_follow $FLAIR_brain_baseline $FLAIR_brain_follow $output -m1 $lesion_mask_baseline -m2 $lesion_mask_follow -t2_b $T2_baseline -t2_f $T2_follow -t2_brain_b $T2_brain_baseline -t2_brain_f $T2_brain_follow

