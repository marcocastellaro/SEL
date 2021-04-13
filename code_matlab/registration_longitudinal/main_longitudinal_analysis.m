clear all 
close all
clc

lesion_baseline = load_untouch_nii('F:\Utente\TESI\output_longitudinal\000030\20140707_20180102\registration_longitudinal\T2_T1\Jacobian\lesion_mask_1_halfway_ANTs.nii.gz');
nak_detJ_1 = load_untouch_nii('F:\Utente\TESI\output_longitudinal\000030\20140707_20180102\registration_longitudinal\T2_T1\Jacobian\nak_detJ_1.nii.gz');
nak_detJ_2 = load_untouch_nii('F:\Utente\TESI\output_longitudinal\000030\20140707_20180102\registration_longitudinal\T2_T1\Jacobian\nak_detJ_2_to_1.nii.gz');
nak_detJ_3 = load_untouch_nii('F:\Utente\TESI\output_longitudinal\000030\20140707_20180102\registration_longitudinal\T2_T1\Jacobian\nak_detJ_3_to_1.nii.gz');

lesion_baseline_img = lesion_baseline.img > 0.5;
nak_detJ_1_img = nak_detJ_1.img;
nak_detJ_2_img = nak_detJ_2.img;
nak_detJ_3_img = nak_detJ_3.img;

[] = longitudinal_analysis(lesion_baseline_img,nak_detJ_1_img,nak_detJ_2_img,nak_detJ_3_img);