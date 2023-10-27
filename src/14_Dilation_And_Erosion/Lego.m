 clc
clear
close all


% Imagen = imread('lego.jpg');
Imagen = imread('upiita.jpg');
ImagenGrises = rgb2gray(Imagen);
UpiitaBinary = (ImagenGrises < 127);

HSV = rgb2hsv(Imagen);
Hue = HSV(:,:,1);

Binary = (Hue >= 0.583 & Hue <= 0.595);
figure, imshow(UpiitaBinary)
% figure, imshow(Binary)
% figure, imshow(Imagen)

StructuralElement = [
    0 1 0;
    1 1 1;
    0 1 0
];

% Erosion = Binary;
OutBinary = dilatar(UpiitaBinary,StructuralElement,1);
