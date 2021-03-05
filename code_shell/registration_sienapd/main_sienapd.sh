#!/bin/bash

# Registration with sienapd

T1_baseline=/mnt/f/utente/tesi/dati/000004_20140428/T1.nii.gz
T1_follow=/mnt/f/utente/tesi/dati/000004_20190304/T1.nii.gz

T2_baseline=/mnt/f/utente/tesi/dati/000004_20140428/T2_to_T1.nii.gz
T2_follow=/mnt/f/utente/tesi/dati/000004_20190304/T2_to_T1.nii.gz

T2_brain_baseline=/mnt/f/utente/tesi/dati/000004_20140428/T2_to_T1_brain.nii.gz
T2_brain_follow=/mnt/f/utente/tesi/dati/000004_20190304/T2_to_T1_brain.nii.gz

FLAIR_brain_baseline=/mnt/f/utente/tesi/dati/000004_20140428/FLAIR_to_T1_brain.nii.gz
FLAIR_brain_follow=/mnt/f/utente/tesi/dati/000004_20190304/FLAIR_to_T1_brain.nii.gz

mask_baseline=/mnt/f/utente/tesi/dati/000004_20140428/ct/BrainExtractionMask.nii.gz
mask_follow=/mnt/f/utente/tesi/dati/000004_20190304/ct/BrainExtractionMask.nii.gz

output=/mnt/f/utente/tesi/output/000004/20140428_20190304

registration_sienapd $T1_baseline $T1_follow $FLAIR_brain_baseline $FLAIR_brain_follow $T2_baseline $T2_follow $T2_brain_baseline $T2_brain_follow $output -m1 $mask_baseline -m2 $mask_follow
