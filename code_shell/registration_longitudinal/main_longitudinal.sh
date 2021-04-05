T1_1
T1_2
T1_3
T1_4

T2_1
T2_2
T2_3
T2_4

FLAIR_1
FLAIR_2
FLAIR_3
FLAIR_4

T1_brain_1
T1_brain_2
T1_brain_3
T1_brain_4

T2_brain_1
T2_brain_2
T2_brain_3
T2_brain_4

FLAIR_brain_1
FLAIR_brain_2
FLAIR_brain_3
FLAIR_brain_4

lesion_mask_1
lesion_mask_2
lesion_mask_3
lesion_mask_4

output

registration_longitudinal_FLAIR $T1_1 $T1_2 $T1_3 $T1_4 $FLAIR_1 $FLAIR_2 $FLAIR_3 $FLAIR_4 $output -t1_brain_1 $T1_brain_1 -t1_brain_2 $T1_brain_2 -t1_brain_3 $T1_brain_3 -t1_brain_4 $T1_brain_4 -flair_brain_1 $FLAIR_brain_1 -flair_brain_2 $FLAIR_brain_2 -flair_brain_3 $FLAIR_brain_3 -flair_brain_4 $FLAIR_brain_4 -lesion_1 $lesion_mask_1 -lesion_2 $lesion_mask_2 -lesion_3 $lesion_mask_3 -lesion_4 $lesion_mask_4
registration_longitudinal_FLAIR $T1_1 $T1_2 $T1_3 $T1_4 $T2_1 $T2_2 $T2_3 $T2_4 $output -t1_brain_1 $T1_brain_1 -t1_brain_2 $T1_brain_2 -t1_brain_3 $T1_brain_3 -t1_brain_4 $T1_brain_4 -t2_brain_1 $T2_brain_1 -t2_brain_2 $T2_brain_2 -t2_brain_3 $T2_brain_3 -t2_brain_4 $T2_brain_4 -lesion_1 $lesion_mask_1 -lesion_2 $lesion_mask_2 -lesion_3 $lesion_mask_3 -lesion_4 $lesion_mask_4