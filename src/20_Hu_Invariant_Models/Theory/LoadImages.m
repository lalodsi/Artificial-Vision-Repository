function [IMAGENES,IMMATRIX,ORIGINALES] = LoadImages(primera,ultima,FilePath,extension,framemask,scale)

    fprintf('Loading sequence....\n');    
    
    Im = imread([FilePath framestr(primera,framemask) extension]); 
    
    
    Im = rgb2gray(Im);    
    Im = imresize(Im,scale);
    Im = im2uint8(Im); 
   
    [N M] = size(Im);
    
    IMAGENES   = zeros(ultima,N,M,'uint8');
    IMMATRIX   = zeros(ultima,N,M,'uint8');
    ORIGINALES = zeros(ultima,N,M,3,'uint8');
   
    for i= primera:ultima
        Im = imread([FilePath framestr(i,framemask) extension]); 
        
        ORIGINALES(i,:,:,:) = Im(:,:,:);        
        Im = rgb2gray(Im);  
        Im = imresize(Im,scale);  
        Im = im2uint8(Im);
        IMAGENES(i,:,:)   = im2uint8(Im);
        IMMATRIX(i,:,:)   = im2uint8(Im);
        
    end   
    
    fprintf('Sequence loaded....\n');
    
    
 
end

