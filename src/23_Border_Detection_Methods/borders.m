% Border detection
clc
clear all
close all

% Image reading
imagen = imread("Luis.jpg");
gris = rgb2gray(imagen);
f = double(gris);

[filas, columnas] = size(f);


% Differential method
dx = 1;
dy = dx;

Gx = zeros(filas, columnas);
Gy = zeros(filas, columnas);
G = zeros(filas, columnas);

for j = 2+dy:filas-dy
    for i = 2+dx:columnas-dx
        Gx(j,i) = (f(j,i+dx) - f(j,i-dx)) / (2*dx);
        Gy(j,i) = (f(j+dy,i) - f(j-dy,i)) / (2*dy);
        G(j,i) = sqrt(Gx(j,i)^2 + Gy(j,i)^2);
    end
end

imdiff = G;

% Mask applying
% Sobel and Prewitt methods

T=3;
Sx = createMask(T);
Sy = Sx';

Gx = zeros(filas, columnas);
Gy = zeros(filas, columnas);
G = zeros(filas, columnas);

for j=(T+1)/2:filas-(T-1)/2
    for i=(T+1)/2:columnas-(T-1)/2
        porcionF = f(j-(T-1)/2:j+(T-1)/2,i-(T-1)/2:i+(T-1)/2);
        Gx(j,i) = sum(porcionF.*Sx, 'all');
        Gy(j,i) = sum(porcionF.*Sy, 'all');
        G(j,i) = sqrt(Gx(j,i)^2 + Gy(j,i)^2);
    end
end

immask = G;

% Fourier Fast Transform method

for j = 1:filas
    for i = 1:columnas
        f(j,i) = ((-1)^(j+i))*(f(j,i));
    end
end

F = fft2(f);

filtro = zeros(filas, columnas);
r = 35;
for j = 1:filas
    for i = 1:columnas
        if (i-columnas/2)^2 + (j-filas/2)^2 > r^2
            filtro(j,i) = 1;
        else
            filtro(j,i) = 0;
        end
    end
end

imfft = uint8(abs(real(ifft2(filtro.*F))));

figure, imshow(uint8(5*imdiff))
title("Diferential")
figure, imshow(uint8(immask))
title(strcat("Masks with T = ", num2str(T)))
figure, imshow(4*imfft)
title(strcat("FFT with r = ", num2str(r)))