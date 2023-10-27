clc
clear all
close all

ImagenLeft = imread("SVA VE IMAGENES\Left Image 1.png");
ImagenRight = imread("SVA VE IMAGENES\Right Image 1.png");

[filas, columnas] = size(ImagenLeft);
ImagenLeft(:,columnas/2) = zeros(filas, 1);
ImagenLeft(filas/2,:) = zeros(1, columnas);

[xi, yi, P] = impixel(ImagenLeft);

xi = xi - columnas/2;
yi = filas/2 - yi;
% [x, y]
% imshow(Imagen)

[filas, columnas] = size(ImagenLeft);
ImagenLeft(:,columnas/2) = zeros(filas, 1);
ImagenLeft(filas/2,:) = zeros(1, columnas);

[xd, yd, P] = impixel(ImagenRight);
xd = xd - columnas/2;
yd = filas/2 - yd;

% Centimeters
% Z = 50;
d = 30;
Foco = 216.82;

Z = Foco*d/(xi-xd)

