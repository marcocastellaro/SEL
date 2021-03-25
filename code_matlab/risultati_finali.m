clear all
close all
clc  

SEL = load_untouch_nii('SEL.nii.gz');
SEL_img = SEL.img;

CC_SEL = bwconncomp(SEL_img,18);
num_SEL = CC_SEL.NumObjects;
save num_SEL