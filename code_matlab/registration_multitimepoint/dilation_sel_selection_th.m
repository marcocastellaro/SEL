% Nel caso in cui ho già sogliato il determinante normalizzato con la
% soglia EJ2 = 0.04 utilizzo questa linea di codice
function [SEL, CC_SEL] = dilation_sel_selection_th(jacobian_lesions_mask_EJ1,jacobian_mask_EJ2,lesions_prob_base_img)

% Nel caso normale utilizzo questa linea di codice
%function [SEL, CC_SEL] = dilation_sel_selection(jacobian_lesions_mask_EJ1,normalized_detJ,lesions_prob_base_img)

% Definisco come elemento per effettuare la dilatazione una sfera di
% raggio 2 pixel, in quanto una dimensione maggiore comporta un eccessiva 
% dilatazione compormettendo la qualità del processo in quanto posso 
% ricadere all'interno della regione dilatata anche altre lesioni
% non volute e che non rispettano le condizioni imposte dalla soglia
% precedentemente definita e pari a EJ1

SE = strel('sphere',2);
dilate_jacobian_lesions_mask = imdilate(jacobian_lesions_mask_EJ1,SE);


% Prendo prima tutti i voxel che presentano un tasso di espansione maggiore
% di EJ2

% Nel caso normale utilizzo questa linea di codice
%jacobian_mask_EJ2 = normalized_detJ >= EJ2;

% Selezioni solo quei voxel che hanno un tasso di espansioni maggiore di
% EJ2 e che rappresentano una lesione pre-esistente dilatata

% Creo una nuova variabile che mi servirà per poter confrontare le maschere
% ad ogni processo di dilatazione in modo che, quando si verifica una
% uguagliaza tra le maschere ottenute allo step i e allo step (i+1) vuol
% dire che i contorni finali sono stati ottenuti e quindi non sono
% possibili ulteriori dilatazioni

% Il ciclo while inizierà con il primo confronto tra la prima maschera dilatata
% ottenuta in precedenza e la maschera iniziale
prev_dilate_mask = jacobian_lesions_mask_EJ1; 

while (~isequal(dilate_jacobian_lesions_mask,prev_dilate_mask)) % condizione: ~isequal = 1 se le due matrici sono diverse 
    prev_dilate_mask = dilate_jacobian_lesions_mask;   % quando le matrici dilatate allo step i e i+1 sono uguali esce dal ciclo
    
    
    jacobian_lesions_mask_EJ2 = and(jacobian_mask_EJ2,dilate_jacobian_lesions_mask);
    jacobian_lesions_mask_EJ2 = and(lesions_prob_base_img,jacobian_lesions_mask_EJ2);
    
    dilate_jacobian_lesions_mask = imdilate(jacobian_lesions_mask_EJ2,SE); 
    %i = i + 1;
    dilate_jacobian_lesions_mask = and(jacobian_mask_EJ2,dilate_jacobian_lesions_mask);
    dilate_jacobian_lesions_mask = and(lesions_prob_base_img,dilate_jacobian_lesions_mask);
end



% Definisco le componenti connesse della maschera ottenuta; questi sono i
% candidati SEL iniziali
CC_dilate_mask = bwconncomp(dilate_jacobian_lesions_mask,18);

% Per concludere l'analisi elimino tutte quelle componenti che presentano
% un numero di voxel inferiore a 10 (Elliot et al.), settando a zero tutti
% i voxel delle componenti che verificano la condizione (1)
num_CC = CC_dilate_mask.NumObjects;
num_minimo_voxel = 20;

% Creo la matrice che successivamente conterrà i candidati SEL finali 
SEL = dilate_jacobian_lesions_mask;

for i = 1:num_CC
    % Determino la dimensione di ogni singola componente
    dim_CC = size(CC_dilate_mask.PixelIdxList{1,i});
    dim_CC = dim_CC(1);
    if (dim_CC < num_minimo_voxel) % (1)
        for j = 1:dim_CC
            SEL(CC_dilate_mask.PixelIdxList{1,i}(j)) = 0;
        end
    end
end

% Infine determino quelle che sono le componenti rimanenti che
% corrispondono ai SEL candidati
CC_SEL = bwconncomp(SEL,18);

end

