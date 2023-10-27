clc
close all
clear all

Imagen = imread('foto.jpg');

% Descomponer en colores RGB
R = double(Imagen(:,:,1));
G = double(Imagen(:,:,2));
B = double(Imagen(:,:,3));

[filas, columnas, capas] = size(Imagen);

HSV = rgb2hsv(Imagen);

H = HSV(:,:,1);
S = HSV(:,:,2);
V = HSV(:,:,3);

figure, imshow(H);
figure, imshow(S);
figure, imshow(V);
figure, imshow(1-S);