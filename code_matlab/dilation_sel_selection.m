function [SEL, CC_SEL] = dilation(jacobian_mask, log_detJ)

% Ho definito come elemento per effettuare la dilatazione una sfera di
% raggio 10 pixel, in quanto una dimensione minore risulta essere
% computazionalmente troppo onerosa, mentre una dimensione maggiore può
% compromettere la qualità del processo.
SE = strel('sphere',10);
dilate_mask = imdilate(jacobian_mask,SE);

% Definisco la seglia EJ2 = 0.04 per identificare i contorni finali dei SEL
% candidati al termine della fase di dilatazione dei contorni iniziali
EJ2 = 0.04;

% Creo una nuova variabile che mi servirà per poter confrontare le maschere
% ad ogni processo di dilatazione in modo che, quando si verifica una
% uguagliaza tra le maschere ottenute allo step i e allo step (i+1) vuol
% dire che i contorni finali sono stati ottenuti e non risulta possibile
% ulteriori dilatazioni

% Il ciclo while inizierà con il primo confronto tra la prima maschera dilatata
% ottenuta in precedenza e la maschera iniziale
prev_dilate_mask = jacobian_mask; 
i = 1;
while (~isequal(dilate_mask,prev_dilate_mask)) % condizione: ~isequal = 1 se le due matrici sono diverse 
    prev_dilate_mask = dilate_mask;            % quando le matrici dilatate allo step i e i+1 sono uguali esce dal ciclo
    tmp = log_detJ.*dilate_mask;
    tmp = tmp >= EJ2;
    dilate_mask = imdilate(tmp,SE); 
    i = i + 1;
end

% Definisco le componenti connesse della maschera ottenuta; questi sono i
% candidati SEL iniziali
CC_dilate_mask = bwconncomp(dilate_mask,18);

% Per concludere l'analisi elimino tutte quelle componenti che presentano
% un numero di voxel inferiore a 10 (Elliot et al.), settando a zero tutti
% i voxel delle componenti che verificano la condizione (1)
num_CC = CC_dilate_mask.NumObjects;
num_minimo_voxel = 10;

% Creo la matrice che successivamente conterrà i candidati SEL finali 
SEL = dilate_mask;

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

