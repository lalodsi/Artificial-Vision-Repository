clc
close all
clear all

Imagen = imread('foto.jpg');

% Descomponer en diferentes colores
R = Imagen(:,:,1);
G = Imagen(:,:,2);
B = Imagen(:,:,3);

% CMY

Cyan = 255 - R;
Magenta = 255 - G;
Yellow = 255 - B;

% Imagen Cyan
ImagenCyan(:,:,1) = Cyan;
ImagenCyan(:,:,2) = Cyan;
ImagenCyan(:,:,3) = Cyan;


% Imagen Magenta
ImagenMagenta(:,:,1) = Magenta;
ImagenMagenta(:,:,2) = Magenta;
ImagenMagenta(:,:,3) = Magenta;

% Imagen Yellow
ImagenYellow(:,:,1) = Yellow;
ImagenYellow(:,:,2) = Yellow;
ImagenYellow(:,:,3) = Yellow;

figure,imshow(ImagenCyan)
figure,imshow(ImagenMagenta)
figure,imshow(ImagenYellow)

ImagenInvertida(:,:,1) = Cyan;
ImagenInvertida(:,:,2) = Magenta;
ImagenInvertida(:,:,3) = Yellow;

imshow(uint8(ImagenInvertida))