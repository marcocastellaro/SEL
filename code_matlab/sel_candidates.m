function [SEL_1, CC_SEL_1] = sel_candidates(detJ,lesions_mask_baseline,lesions_mask_follow,date1,date2)

%% Calcolo in anni la differenza tra la data di acquisizione immagini baseline e follow-up
date_baseline = datenum(date1); 
date_follow = datenum(date2);
diff = date_follow - date_baseline;
y = diff/365.2425;

%% Normalizzazione della logaritmo del determinante dello Jacobiano
normalization_detJ = detJ./y;

%% Analisi delle componenti connesse delle maschere di lesioni baseline e follow-up
% Componenti connesse e centroidi baseline
CC_baseline = bwconncomp(lesions_mask_baseline,18);
S_baseline = regionprops(CC_baseline,'Centroid');

% Assegno ad ogni componente connessa della maschera baseline un colore
% differente (Label matrix)
L_baseline = labelmatrix(CC_baseline);

% Componenti connesse e centroidi follow-up
CC_follow = bwconncomp(lesions_mask_follow,18);
S_follow = regionprops(CC_follow,'Centroid');

% Assegno ad ogni componente connessa della maschera follow-up un colore
% differente (Label matrix)
L_follow = labelmatrix(CC_follow);

%% ANALISI PER IDENTIFICARE LE LESIONI IN COMUNE PER LA SCELTA DEI SEL CANDIDATI
% Definisco il numero di componenti connesse delle maschere 
num_CC_baseline = CC_baseline.NumObjects;
num_CC_follow = CC_follow.NumObjects;

% Determino la posizione di tutti i voxel delle lesioni nella maschera
% follow-up che appartengono alle componenti connesse (non considero il background)
ind_voxel_CC_baseline = find(lesions_mask_baseline);
ind_voxel_CC_follow = find(lesions_mask_follow);

num_voxel_CC_baseline = size(ind_voxel_CC_baseline);
num_voxel_CC_baseline = num_voxel_CC_baseline(1);
num_voxel_CC_follow = size(ind_voxel_CC_follow);
num_voxel_CC_follow = num_voxel_CC_follow(1);


% Valuto la percentuale di voxel, che compongono le singole CC della baseline, sono presenti
% anche nella maschera di lesioni follow-up

perc_voxel_lesions_baseline_within_lesions_mask_follow = [];
for i=1:num_CC_baseline
    vet_diff = setdiff(CC_baseline.PixelIdxList{1,i},ind_voxel_CC_follow);
    dim_vett_diff = size(vet_diff);
    dim_CC = size(CC_baseline.PixelIdxList{1,i});
    perc_voxel_lesions_baseline_within_lesions_mask_follow(i) = ((dim_CC(1) - dim_vett_diff(1))/dim_CC(1))*100;
end

% Le componenti connesse che presentano un valore dello 0% indicano che
% quella lesione � scomparsa nel tempo e quindi non rilevata nelle immagini
% acquisite al timepoint follow-up

% Determino quali sono tali componenti connesse:
CC_baseline_useless = find(~perc_voxel_lesions_baseline_within_lesions_mask_follow);

% perc = perc_voxel_lesions_baseline_within_lesions_mask_follow;
% for i = 1:num_CC_baseline
%     if (perc(i) < 20)
%         perc(i) = 0;
%     end
% end
% 
% % componenti utili
% CC_baseline_useless_perc = find(~perc);

% Creo la maschera finale eliminando le lesioni che non sono presenti nel follow-up
common_lesions_mask = lesions_mask_baseline;

for i = CC_baseline_useless
    d = size(CC_baseline.PixelIdxList{1,i});
    for j = 1:d(1)
        common_lesions_mask(CC_baseline.PixelIdxList{1,i}(j)) = 0;
    end
end

% CHIEDERE COME SI SALVANO LE IMMAGINI CON SAVE_UNTOUCH_NII
% nifti_common_lesions_mask = template_mask;
% nifti_common_lesions_mask.img = common_lesions_mask;
% save_untouch_nii(nifti_common_lesions_mask,'F:\Utente\TESI\Registrazione_SEL\000027\test\Jacobian_output\common_lesions_mask.nii');

%% ULTERIORI CONSIDERAZIONI:
% Analisi per determinare se diverse CC della maschera baseline si sono
% unite spazialmente in un unica CC presente nella maschera del follow-up

% Vado a creare un elemento cella che ad ogni elemento sar� associato una diversa componente connessa
% della baseline; ogni elemento sar� in formato double e conterr� due colonne:
% I COLONNA: tutti gli indici dei voxel che compongono quella specifica
% componente connessa
% II COLONNA: il valore in unit8 (ottenuto tramite labelmatrix) che quello specifico voxel,
% identificato con l'indice della prima colonna, presenta nella L_follow 
% (nella maschera di lesioni del follow-up)

% voxel_lesions_baseline_within_lesions_mask_follow = CC_baseline.PixelIdxList;
% 
% for i = 1:num_CC_baseline
%     voxel_lesions_baseline_within_lesions_mask_follow{1,i}(:,2) = L_follow(voxel_lesions_baseline_within_lesions_mask_follow{1,i}); 
% end

% Seguendo il punto precedente: identifico quali sono le componenti connesse
% relative alla maschera di lesioni follow-up che contengono voxel delle
% componenti connesse della maschera baseline 

CC_follow_useful = unique(L_follow(ind_voxel_CC_baseline));

% Valuto la percentuale di voxel, che compongono le singole CC del follow-up, che sono presenti
% anche nella maschera di lesioni baseline

% perc_voxel_lesions_follow_within_lesions_mask_baseline = [];
% for i=1:num_CC_follow
%     vet_diff = setdiff(CC_follow.PixelIdxList{1,i},ind_voxel_CC_baseline);
%     dim_vett_diff = size(vet_diff);
%     dim_CC = size(CC_follow.PixelIdxList{1,i});
%     perc_voxel_lesions_follow_within_lesions_mask_baseline(i) = ((dim_CC(1) - dim_vett_diff(1))/dim_CC(1))*100;
% end

% Le componenti che hanno percentuale dello 0% vuol dire che sono comparse
% nel tempo mentre al tempo in cui � stata acquisita la baseline non erano
% presenti (nuove lesioni)

%% IDENTIFICAZIONE SEL INIZIALI
% Uso prima common_lesions_mask
% poi utilizzo lesions_mask_baseline
% jacobian -> normalization_detJ

EJ1 = 0.125;
jacobian_mask_EJ1 = detJ >= 0.125;

% Salvo questa maschera
% template_jacobian = log_detJ;
% nifti_jacobian_mask = template_jacobian;
% nifti_jacobian_mask.img = jacobian_mask_EJ1;
% save_untouch_nii(nifti_jacobian_mask,'F:\Utente\TESI\Registrazione_SEL\000027\test\Jacobian_output\jacobian_mask.nii');


% Numero di voxel che hanno una rate expansion maggiore o uguale a EJ1
voxel_SEL_iniziali = size(find(jacobian_mask_EJ1));
voxel_SEL_iniziali = voxel_SEL_iniziali(1);

%% PRIMA MASCHERA: common_lesions_mask

% Identifico quali di questi voxel che hanno una rate expansion maggiore o
% uguale di EJ1 sono all'interno delle lesioni pre-esistenti
jacobian_lesions_mask_1 = and(common_lesions_mask,jacobian_mask_EJ1); 

% definisco le componenti connesse
CC_jacobian_lesions_mask_1 = bwconncomp(jacobian_lesions_mask_1,18);

%% DILATAZIONE DELLE COMPONENTI CONNESSE E SCELTA DEI SEL CANDIDATI

[SEL_1, CC_SEL_1] = dilation(jacobian_lesions_mask_1,detJ);

%% SECONDA MASCHERA: lesions_mask_baseline

% Identifico quali di questi voxel che hanno una rate expansion maggiore o
% uguale di EJ1 sono all'interno delle lesioni pre-esistenti
jacobian_lesions_mask_2 = and(lesions_mask_baseline,jacobian_mask_EJ1);

% definisco le componenti connesse
CC_jacobian_lesions_mask_2 = bwconncomp(jacobian_lesions_mask_2,18);

%% DILATAZIONE DELLE COMPONENTI CONNESSE

[SEL_2, CC_SEL_2] = dilation(jacobian_lesions_mask_2,detJ);

end

    



