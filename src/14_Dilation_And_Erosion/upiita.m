clc
clear
close all

Imagen = imread('lego.jpg');
ImagenGrises = rgb2gray(Imagen);
ImageBinary = (ImagenGrises < 127);

HSV = rgb2hsv(Imagen);
Hue = HSV(:,:,1);
figure, imshow(Imagen)
figure, mesh(Hue)
[filas, columnas] = size(ImageBinary);


StructuralElement = [
    0 1 0;
    1 1 1;
    0 1 0
];

OutImage = ImageBinary
for k = 1:50
    OutImage = dilatar(OutImage, StructuralElement, k);
end

