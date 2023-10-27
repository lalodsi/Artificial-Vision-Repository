clc
clear all
close all


Imagen = imread('foto2.jpg');

% Descomponer en diferentes colores
R = Imagen(:,:,1);
G = Imagen(:,:,2);
B = Imagen(:,:,3);

for j=1:800
    for i =1:800   
        ImagenNueva(j,i,1) = 255 - R(j,i);
        ImagenNueva(j,i,2) = 255 - G(j,i);
        ImagenNueva(j,i,3) = 255 - B(j,i);
    end
end


% Mostrar las diferentes composiciones
figure,imshow(R)
title("Red Image")
figure,imshow(G)
title("Green Image")
figure,imshow(B)
title("Blue Image")

figure, imshow(uint8(ImagenNueva))
title("Image Inverted")