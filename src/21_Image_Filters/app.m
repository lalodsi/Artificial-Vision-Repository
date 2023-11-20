clc
clear all
close all

image = imread('luis.jpeg');
grayImage = rgb2gray(image);
f = double(grayImage);

for T = 1:2:1001
    % F = filtroBinomial(T);
    % F = filtroPromediador(T);
    F = filtroGaussiano(T,10);

    coef = ceil((T+1)/2-1);
    [rows, cols] = size(f);
    G = zeros(rows, cols);
    for j = coef+1:rows-coef
        for i = coef+1:cols-coef
            G(j,i) = sum(f(j-coef:j+coef, i-coef:i+coef).*F,"all");
        end
    end
    imshow(uint8(G))
    drawnow
end