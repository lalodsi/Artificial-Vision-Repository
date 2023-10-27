clc
close all
clear all

% Mostrar un degradado en todos los colores de una sola línea

V1 = 255 * ones(1, 256);
V0 = zeros(1,256);
Vi = 0 : 255;
Vd = 255 : -1 : 0;

ImagenH(:,:,1) = [V1 Vd V0 V0 Vi V1];
ImagenH(:,:,2) = [Vi V1 V1 Vd V0 V0];
ImagenH(:,:,3) = [V0 V0 Vi V1 V1 Vd];

figure, imshow(uint8(ImagenH))

% Leer una imagen y obtener unicamente el arreglo de Value

Foto = imread('cubo.jpg');

figure, imshow(uint8(Foto))

HSV = rgb2hsv(Foto);

Hue = HSV(:,:,1);
Saturation = HSV(:,:,2);
Value = HSV(:,:,3);

% figure, imshow(Hue)
% figure, imshow(Saturation)
% figure, imshow(Value)

[filas, columnas, capas] = size(Foto);

for j=1:filas
    for i=1:columnas
        if HSV(j,i,2)<= 0.25 && HSV(j,i,3)>=0.75
            P=[255; 255; 255];
        elseif HSV(j,i,2) <= 0.25 && HSV(j,i,3) <= 0.75
            P=[0;0;0];
        else
            P = ImagenH(1, uint16(Hue(j,i)*1535+1),:);
        end
        Matiz(j,i,:) = P;
    end
end

figure, imshow(uint8(Matiz))