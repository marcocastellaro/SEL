#!/bin/bash

# registrazione immagini T1, T2, FLAIR: paziente 000004
# reference timepoint: 20150413 (fixed image)
# follow-up timepoint: 20190304 (moved image)

thisfolder_T1=/mnt/f/Utente/tesi/Registrazione_SEL/T13DTFE_N4
fixed_T1=/mnt/f/Utente/TESI/Dati_SEL/000004/20150413/T13DTFE_N4.nii.gz
moved_T1=/mnt/f/Utente/TESI/Dati_SEL/000004/20190304/T13DTFE_N4.nii.gz

antsRegistration -d 3 --float 0 -o [$thisfolder_T1/matrici_T1,$thisfolder_T1/image_reg_T1.nii.gz] -n Linear -w [0.005,0.995] -u 0 -r [$fixed_T1,$moved_T1,1] -t Rigid[0.1] -m MI[$fixed_T1,$moved_T1,1,32,Regular,0.25] -c [1000x500x250x100,1e-6,10] -f 8x4x2x1 -s 3x2x1x0vox -t Affine[0.1] -m MI[$fixed_T1,$moved_T1,1,32,Regular,0.25] -c [1000x500x250x100,1e-6,10] -f 8x4x2x1 -s 3x2x1x0vox -t Syn[0.1,3,0] -m CC[$fixed_T1,$moved_T1,1,4] -c [100x70x50x20,1e-6,10] -f 8x4x2x1 -s 3x2x1x0vox

# registrazione immagine T2

thisfolder_T2=/mnt/f/Utente/TESI/Registrazione_SEL/3DT2_N4
fixed_T2=/mnt/f/Utente/TESI/Dati_SEL/000004/20150413/3DT2_N4.nii.gz
moved_T2=/mnt/f/Utente/TESI/Dati_SEL/000004/20190304/3DT2_N4.nii.gz

antsRegistration -d 3 --float 0 -o [$thisfolder_T2/matrici_T2,$thisfolder_T2/image_reg_T2.nii.gz] -n Linear -w [0.005,0.995] -u 0 -r [$fixed_T2,$moved_T2,1] -t Rigid[0.1] -m MI[$fixed_T2,$moved_T2,1,32,Regular,0.25] -c [1000x500x250x100,1e-6,10] -f 8x4x2x1 -s 3x2x1x0vox -t Affine[0.1] -m MI[$fixed_T2,$moved_T2,1,32,Regular,0.25] -c [1000x500x250x100,1e-6,10] -f 8x4x2x1 -s 3x2x1x0vox -t Syn[0.1,3,0] -m CC[$fixed_T2,$moved_T2,1,4] -c [100x70x50x20,1e-6,10] -f 8x4x2x1 -s 3x2x1x0vox

# registrazione immagine FLAIR

thisfolder_FLAIR=/mnt/f/Utente/TESI/Registrazione_SEL/3DFLAIR_N4
fixed_FLAIR=/mnt/f/Utente/TESI/Dati_SEL/000004/20150413/3DFLAIR_N4.nii.gz
moved_FLAIR=/mnt/f/Utente/TESI/Dati_SEL/000004/20190304/3DFLAIR_N4.nii.gz

antsRegistration -d 3 --float 0 -o [$thisfolder_FLAIR/matrici_FLAIR,$thisfolder_FLAIR/image_reg_FLAIR.nii.gz] -n Linear -w [0.005,0.995] -u 0 -r [$fixed_FLAIR,$moved_FLAIR,1] -t Rigid[0.1] -m MI[$fixed_FLAIR,$moved_FLAIR,1,32,Regular,0.25] -c [1000x500x250x100,1e-6,10] -f 8x4x2x1 -s 3x2x1x0vox -t Affine[0.1] -m MI[$fixed_FLAIR,$moved_FLAIR,1,32,Regular,0.25] -c [1000x500x250x100,1e-6,10] -f 8x4x2x1 -s 3x2x1x0vox -t Syn[0.1,3,0] -m CC[$fixed_FLAIR,$moved_FLAIR,1,4] -c [100x70x50x20,1e-6,10] -f 8x4x2x1 -s 3x2x1x0vox


# Calcolo del determiante dello jacobiano

Warp_T1=/mnt/f/Utente/TESI/Registrazione_SEL/T13DTFE_N4/matrici_T11Warp.nii.gz
Jac_T1=/mnt/f/Utente/TESI/Registrazione_SEL/T13DTFE_N4/detJac_T1.nii.gz

Warp_T2=/mnt/f/Utente/TESI/Registrazione_SEL/3DT2_N4/matrici_T21Warp.nii.gz
Jac_T2=/mnt/f/Utente/TESI/Registrazione_SEL/3DT2_N4/detJac_T2.nii.gz

Warp_FLAIR=/mnt/f/Utente/TESI/Registrazione_SEL/3DFLAIR_N4/matrici_FLAIR1Warp.nii.gz
Jac_FLAIR=/mnt/f/Utente/TESI/Registrazione_SEL/3DFLAIR_N4/detJac_FLAIR.nii.gz

CreateJacobianDeterminantImage 3 $Warp_T1 $Jac_T1
CreateJacobianDeterminantImage 3 $Warp_T2 $Jac_T2
CreateJacobianDeterminantImage 3 $Warp_FLAIR $Jac_FLAIR
