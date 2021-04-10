#!/bin/bash 

lesion_mask_baseline=/mnt/f/Utente/TESI/data/000538_20150914/baseline_2ch/baseline_2ch_prob_1.nii.gz
lesion_mask_follow=/mnt/f/Utente/TESI/data/000538_20180917/baseline_2ch/baseline_2ch_prob_1.nii.gz

T1_baseline=/mnt/f/Utente/TESI/data/000538_20150914/T1.nii.gz
T1_follow=/mnt/f/Utente/TESI/data/000538_20180917/T1.nii.gz

output=/mnt/f/Utente/TESI/output/000538/20150914_20180917/

A_halfwayto_B_ANTs_SIENA=/mnt/f/Utente/TESI/output/000538/20150914_20180917/registration_sienapd/FLAIR_T1/A_halfwayto_B_ANTs.mat
A_halfwayto_B_ANTs_ROBUST=/mnt/f/Utente/TESI/output/000538/20150914_20180917/registration_robust_template/FLAIR_T1/A_halfwayto_B_ANTs.mat

SEL_1=/mnt/f/Utente/TESI/output/000538/20150914_20180917/registration_sienapd/FLAIR_T1/Jacobian/SEL.nii.gz
SEL_2=/mnt/f/Utente/TESI/output/000538/20150914_20180917/registration_sienapd/T2_T1/Jacobian/SEL.nii.gz
SEL_3=/mnt/f/Utente/TESI/output/000538/20150914_20180917/registration_robust_template/FLAIR_T1/Jacobian/SEL.nii.gz
SEL_4=/mnt/f/Utente/TESI/output/000538/20150914_20180917/registration_robust_template/T2_T1/Jacobian/SEL.nii.gz


volume_sel $T1_baseline $T1_follow $lesion_mask_baseline $lesion_mask_follow $output $A_halfwayto_B_ANTs_SIENA $A_halfwayto_B_ANTs_ROBUST $SEL_1 $SEL_2 -sel_3 $SEL_3 -sel_4 $SEL_4