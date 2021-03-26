#!/bin/bash

# Rioriento tutte le immagini necessarie alla registrazione
fslreorient2std T1_2014.nii.gz T1_2014.nii.gz
fslreorient2std FLAIR_to_T1_2014.nii.gz FLAIR_to_T1_2014.nii.gz
fslreorient2std T1_brain_2014.nii.gz T1_brain_2014.nii.gz
fslreorient2std FLAIR_to_T1_brain_2014.nii.gz FLAIR_to_T1_brain_2014.nii.gz

fslreorient2std T1_2015.nii.gz T1_2015.nii.gz
fslreorient2std FLAIR_to_T1_2015.nii.gz FLAIR_to_T1_2015.nii.gz

fslreorient2std T1_2019.nii.gz T1_2019.nii.gz
fslreorient2std FLAIR_to_T1_2019.nii.gz FLAIR_to_T1_2019.nii.gz
fslreorient2std T1_brain_2019.nii.gz T1_brain_2019.nii.gz
fslreorient2std FLAIR_to_T1_brain_2019.nii.gz FLAIR_to_T1_brain_2019.nii.gz


# Effettuo la brain extraction per il time point intermedio
fslreorient2std BrainExtractionMask.nii.gz 2015_brain_mask.nii.gz
fslmaths FLAIR_to_T1_2015.nii.gz -mas 2015_brain_mask.nii.gz FLAIR_to_T1_brain_2015.nii.gz
fslmaths T1_2015.nii.gz -mas 2015_brain_mask.nii.gz T1_brain_2015.nii.gz


# Converto le immagini nel formato mgz
mri_convert -it nii -ot mgz T1_2014.nii.gz T1_2014.mgz

mri_convert -it nii -ot mgz T1_2015.nii.gz T1_2015.mgz

mri_convert -it nii -ot mgz T1_2019.nii.gz T1_2019.mgz

mri_convert -it nii -ot mgz FLAIR_to_T1_2014.nii.gz FLAIR_to_T1_2014.mgz  

mri_convert -it nii -ot mgz FLAIR_to_T1_2015.nii.gz FLAIR_to_T1_2015.mgz

mri_convert -it nii -ot mgz FLAIR_to_T1_2019.nii.gz FLAIR_to_T1_2019.mgz  


# Coregistrazione spazio halfway delle immagini
mri_robust_template --mov T1_2014.mgz T1_2015.mgz T1_2019.mgz --template halfway_T1.mgz --lta T1_2014_halfway.lta T1_2015_halfway.lta T1_2019_halfway.lta --mapmov T1_2014_halfway.mgz T1_2015_halfway.mgz T1_2019_halfway.mgz --average 0 --iscale --satit --inittp 1 --fixtp --noit
mri_robust_template --mov FLAIR_to_T1_2014.mgz FLAIR_to_T1_2015.mgz FLAIR_to_T1_2019.mgz --template halfway_FLAIR.mgz --lta FLAIR_2014_halfway.lta FLAIR_2015_halfway.lta FLAIR_2019_halfway.lta --mapmov FLAIR_2014_halfway.mgz FLAIR_2015_halfway.mgz FLAIR_2019_halfway.mgz --average 0 --iscale --satit --inittp 1 --fixtp --noit

# Converto i file.lta in file_fsl.mat
lta_convert --inlta T1_2014_halfway.lta --outfsl 2014_to_halfway_fsl.mat
lta_convert --inlta T1_2015_halfway.lta --outfsl 2015_to_halfway_fsl.mat
lta_convert --inlta T1_2019_halfway.lta --outfsl 2019_to_halfway_fsl.mat

# Converto la halfway_T1.mgz in formato .nii.gz

mri_convert -it mgz -ot nii halfway_T1.mgz halfway_T1.nii.gz

# Convertire le matrici di trasformazione delle immagini nello spazio halfway da FSL a RAS (ANTs)
# usare halfway.mgz (conveertito .nii.gz) come -ref
c3d_affine_tool -ref halfway_T1.nii.gz -src T1_2014.nii.gz 2014_to_halfway_fsl.mat -fsl2ras -oitk 2014_to_halfway_ANTs.mat
c3d_affine_tool -ref halfway_T1.nii.gz -src T1_2015.nii.gz 2015_to_halfway_fsl.mat -fsl2ras -oitk 2015_to_halfway_ANTs.mat
c3d_affine_tool -ref halfway_T1.nii.gz -src T1_2019.nii.gz 2019_to_halfway_fsl.mat -fsl2ras -oitk 2019_to_halfway_ANTs.mat

# Prima registrazione non lineare 2014-2015 (I)
fixed_T1=T1_brain_2014.nii.gz
moved_T1=T1_brain_2015.nii.gz
fixed_FLAIR=FLAIR_to_T1_brain_2014.nii.gz
moved_FLAIR=FLAIR_to_T1_brain_2015.nii.gz

antsRegistration -d 3 --float 0 -o [matrice_2014_2015_,image_reg_2014_2015.nii.gz,image_inv_reg_2014_2015.nii.gz] -n Linear -w [0.005,0.995] -u 0 -r 2015_to_halfway_ANTs.mat -q 2014_to_halfway_ANTs.mat -t Syn[0.1,3,0] -m CC[$fixed_T1,$moved_T1,1,4] -m CC[$fixed_FLAIR,$moved_FLAIR,1,4] -c [100x70x50x20,1e-6,20] -f 8x4x2x1 -s 3x2x1x0vox 

# Seconda registrazione non lineare 2015-2019 (II)
fixed_T1=T1_brain_2015.nii.gz
moved_T1=T1_brain_2019.nii.gz
fixed_FLAIR=FLAIR_to_T1_brain_2015.nii.gz
moved_FLAIR=FLAIR_to_T1_brain_2019.nii.gz

antsRegistration -d 3 --float 0 -o [matrice_2015_2019_,image_reg_2015_2019.nii.gz,image_inv_reg_2015_2019.nii.gz] -n Linear -w [0.005,0.995] -u 0 -r 2019_to_halfway_ANTs.mat -q 2015_to_halfway_ANTs.mat -t Syn[0.1,3,0] -m CC[$fixed_T1,$moved_T1,1,4] -m CC[$fixed_FLAIR,$moved_FLAIR,1,4] -c [100x70x50x20,1e-6,20] -f 8x4x2x1 -s 3x2x1x0vox 


# Creo i determinante dello Jacobiano
mkdir Jacobian

CreateJacobianDeterminantImage 3 matrice_2014_2015_1Warp.nii.gz detJ_I.nii.gz 
CreateJacobianDeterminantImage 3 matrice_2014_2015_1InverseWarp.nii.gz detJ_inv_I.nii.gz
fslmaths detJ_I.nii.gz -sub 1 nak_detJ_I.nii.gz
fslmaths detJ_inv_I.nii.gz -sub 1 nak_detJ_inv_I.nii.gz

CreateJacobianDeterminantImage 3 matrice_2015_2019_1Warp.nii.gz detJ_II.nii.gz 
CreateJacobianDeterminantImage 3 matrice_2015_2019_1InverseWarp.nii.gz detJ_inv_II.nii.gz
fslmaths detJ_II.nii.gz -sub 1 nak_detJ_II.nii.gz
fslmaths detJ_inv_II.nii.gz -sub 1 nak_detJ_inv_II.nii.gz

mv nak_detJ_I.nii.gz ./Jacobian
mv nak_detJ_II.nii.gz ./Jacobian
mv FLAIR_2014_halfway.mgz ./Jacobian
mv FLAIR_2015_halfway.mgz ./Jacobian

antsRegistration -d 3 --float 0 -o [matrice_II_to_I,nak_detJ_II_to_halfway.nii.gz] -n Linear -t Rigid[0.1] -c 0 -s 4 -f 4 -m CC[nak_detJ_I.nii.gz,nak_detJ_II.nii.gz]


# Coregistro le maschere di lesioni nello spazio halfway
antsApplyTransforms -d 3 --float 0 -i baseline_2ch_prob_1_2014.nii.gz -r halfway_T1.nii.gz -o lesion_mask_2014_halfway_ANTs.nii.gz -n Linear -t 2014_to_halfway_ANTs.mat
fslmaths lesion_mask_2014_halfway_ANTs.nii.gz -thr 0.5 lesion_mask_2014_halfway_ANTs.nii.gz

mv lesion_mask_2014_halfway_ANTs.nii.gz ./Jacobian

#cd Jacobian




















#antsApplyTransforms -d 3 --float 0 -i baseline_2ch_prob_1.nii.gz -r halfway_T1.nii.gz -o lesion_mask_base_halfway_ANTs.nii.gz -n Linear -t A_halfwayto_B_ANTs.mat
fslmaths lesion_mask_base_halfway_ANTs.nii.gz -thr 0.5 lesion_mask_base_halfway_ANTs.nii.gz

#!/bin/bash

#fslreorient2std BrainExtractionMask.nii.gz A_brain_mask.nii.gz
#fslmaths FLAIR_to_T1_2015.nii.gz -mas A_brain_mask.nii.gz FLAIR_to_T1_brain_2015.nii.gz
#fslmaths T1_2015.nii.gz -mas A_brain_mask.nii.gz T1_brain_2015.nii.gz


# Coregistrazione spazio halfway delle immagini
mri_robust_template --mov T1_2015.mgz T1_2019.mgz --template halfway_T1.mgz --lta T1_2015_halfway.lta T1_2019_halfway.lta --mapmov T1_2015_halfway.mgz T1_2019_halfway.mgz --average 0 --iscale --satit --inittp 1 --fixtp --noit
mri_robust_template --mov FLAIR_to_T1_2015.mgz FLAIR_to_T1_2019.mgz --template halfway_FLAIR.mgz --lta FLAIR_2015_halfway.lta FLAIR_2019_halfway.lta --mapmov FLAIR_2015_halfway.mgz FLAIR_2019_halfway.mgz --average 0 --iscale --satit --inittp 1 --fixtp --noit

# Converto i file.lta in file_fsl.mat

lta_convert --inlta T1_2015_halfway.lta --outfsl A_halfwayto_B_fsl.mat
lta_convert --inlta T1_2019_halfway.lta --outfsl B_halfwayto_A_fsl.mat

# Converto la halfway_T1.mgz in formato .nii.gz

mri_convert -it mgz -ot nii halfway_T1.mgz halfway_T1.nii.gz

# Convertire le matrici di trasformazione delle immagini nello spazio halfway da FSL a RAS (ANTs)
# usare halfway.mgz (conveertito .nii.gz) come -ref
c3d_affine_tool -ref halfway_T1.nii.gz -src T1_2015.nii.gz A_halfwayto_B_fsl.mat -fsl2ras -oitk A_halfwayto_B_ANTs.mat
c3d_affine_tool -ref halfway_T1.nii.gz -src T1_2019.nii.gz B_halfwayto_A_fsl.mat -fsl2ras -oitk B_halfwayto_A_ANTs.mat

# SyN Registration con ANTS (VEDERE CON MARCO)
fixed_T1=T1_brain_2015.nii.gz
moved_T1=T1_brain_2019.nii.gz
fixed_FLAIR=FLAIR_to_T1_brain_2015.nii.gz
moved_FLAIR=FLAIR_to_T1_brain_2019.nii.gz

antsRegistration -d 3 --float 0 -o [matrice_T1,image_reg.nii.gz,image_inv_reg.nii.gz] -n Linear -w [0.005,0.995] -u 0 -r B_halfwayto_A_ANTs.mat -q A_halfwayto_B_ANTs.mat -t Syn[0.1,3,0] -m CC[$fixed_T1,$moved_T1,1,4] -m CC[$fixed_FLAIR,$moved_FLAIR,1,4] -c [100x70x50x20,1e-6,20] -f 8x4x2x1 -s 3x2x1x0vox 

mkdir Jacobian

CreateJacobianDeterminantImage 3 matrice_T11Warp.nii.gz detJ.nii.gz 
CreateJacobianDeterminantImage 3 matrice_T11InverseWarp.nii.gz detJ_inv.nii.gz
fslmaths detJ.nii.gz -sub 1 nak_detJ.nii.gz
fslmaths detJ_inv.nii.gz -sub 1 nak_detJ_inv.nii.gz

