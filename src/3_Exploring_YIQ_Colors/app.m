clc
close all
clear all

Imagen = imread('foto2.jpg');

% Descomponer en colores RGB
R = double(Imagen(:,:,1));
G = double(Imagen(:,:,2));
B = double(Imagen(:,:,3));

% yIQ

Transformacion = [0.299 0.587 0.114;
    0.596 -0.275 -0.321;
    0.212 -0.523 0.311];

[filas, columnas, capas] = size(Imagen);
Z = uint8(zeros(filas,columnas));
Unos = 255 * uint8(ones(filas, columnas));

for i=1:filas
    for j=1:columnas
        y(i,j)=0.299*R(i,j)+0.587*G(i,j)+0.114*B(i,j);
        I(i,j)=0.596*R(i,j)-0.275*G(i,j)-0.321*B(i,j);
        Q(i,j)=0.212*R(i,j)-0.523*G(i,j)+0.311*B(i,j);
    end
end

figure, imshow(uint8(y));
figure, imshow(uint8(I));
figure, imshow(uint8(Q));
% Compare results with this function
Gray = rgb2gray(Imagen);
figure, imshow(uint8(Gray))