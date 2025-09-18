        clc
clear all
close all

cuadrado = load("square.mat").distancias;
flecha = load("arrow.mat").distancias;

Imagen = imread("cuadrado.bmp");
ImagenEnGrises = rgb2gray(Imagen);
f = (ImagenEnGrises < 127);
f = bwmorph(f, "thin", Inf);

[filas, columnas] = size(f);

for i = 1:filas
    for j = 1:columnas
        if f(i,j) == 1
            break
        end
    end
    if f(i,j) == 1 
        break
    end
end

MatrizPonderaciones = [
    3, 2, 1;
    4, 0, 8;
    5, 6, 7
];

x = 1:columnas;
y = 1:filas;
fx = sum(double(f),1);
fy = sum(double(f),2)';
centroideX = sum(x.*fx)/sum(fx);
centroideY = sum(y.*fy)/sum(fy);

f(uint16(centroideY),uint16(centroideX)) = 1;

contador = 1;

% Deshacer el circulo
while f(i,j) == 1
    distancias(contador) = sqrt((centroideX-j)^2 + (centroideY-i)^2);
    contador = contador + 1;
    %
    MatrizVecindad = f(i-1:i+1,j-1:j+1);
    MatrizDireccion = MatrizVecindad .* MatrizPonderaciones;
    Maximo = max(max(MatrizDireccion));
    f(i,j) = 0;
    switch Maximo
        case 1
            i = i-1;
            j = j+1;
        case 2
            i = i-1;
            % j = j;
        case 3
            i = i-1;
            j = j-1;
        case 4
            % i = i-1;
            j = j-1;
        case 5
            i = i+1;
            j = j-1;
        case 6
            i = i+1;
            % j = j-1;
        case 7
            i = i+1;
            j = j+1;
        case 8
            % i = i+1;
            j = j+1;
        otherwise
    end

    % imshow(f)
    % drawnow
end

% Ajusta la longitud de la señal más corta para que coincida con la más larga
min_length = min(length(flecha), length(distancias));
flecha = flecha(1:min_length);
distancias = distancias(1:min_length);

x = corrcoef(flecha, distancias);
% plot(x)
x(1,2)
% sum(x,"al
% 
% l")