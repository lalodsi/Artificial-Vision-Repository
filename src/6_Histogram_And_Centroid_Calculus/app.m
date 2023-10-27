clc
close all
clear all

% Leer una imagen

Foto = imread('foto.jpg');

figure, imshow(Foto);

Imagen2 = imcrop(Foto);

imshow(Imagen2);

R = Imagen2(:,:,1);
G = Imagen2(:,:,2);
B = Imagen2(:,:,3);
figure, imshow(R)
figure, imshow(G)
figure, imshow(B)

histogramaR = zeros(1, 256);
histogramaG = zeros(1, 256);
histogramaB = zeros(1, 256);

[filas, columnas, capas] = size(Imagen2);

for j=1:filas
    for i=1:columnas
        histogramaR(1, R(j,i)+1) = histogramaR(1, R(j,i) + 1) + 1;
        histogramaG(1, G(j,i)+1) = histogramaG(1, G(j,i) + 1) + 1;
        histogramaB(1, B(j,i)+1) = histogramaB(1, B(j,i) + 1) + 1;
    end
end

figure,
hold on
plot(histogramaR, 'r');
plot(histogramaG, 'G');
plot(histogramaB, 'b');
plot([100,100], 'k');
hold off

x=0:255;
unos = ones(256,1)
centroideR = sum(x.*histogramaR)/sum(histogramaR)
centroideG = sum(x.*histogramaG)/sum(histogramaG)
centroideB = sum(x.*histogramaB)/sum(histogramaB)

PromedioR = sum(sum(R)) / (filas * columnas)
PromedioG = sum(sum(G)) / (filas * columnas)
PromedioB = sum(sum(B)) / (filas * columnas)

% maximoR = 0
% for j=1:filas
%     for i=1:columnas
%         histogramaR(1, R(j,i)+1) = histogramaR(1, R(j,i) + 1) + 1;
%         histogramaG(1, G(j,i)+1) = histogramaG(1, G(j,i) + 1) + 1;
%         histogramaB(1, B(j,i)+1) = histogramaB(1, B(j,i) + 1) + 1;
%     end
% end

resultado(:,:,1) = uint8(centroideR*ones(200));
resultado(:,:,2) = uint8(centroideG*ones(200));
resultado(:,:,3) = uint8(centroideB*ones(200));

resultadoPromedios(:,:,1) = uint8(PromedioR*ones(200));
resultadoPromedios(:,:,2) = uint8(PromedioG*ones(200));
resultadoPromedios(:,:,3) = uint8(PromedioB*ones(200));

resultadoMax(:,:,1) = max(max(R))*uint8(ones(200));
resultadoMax(:,:,2) = max(max(G))*uint8(ones(200));
resultadoMax(:,:,3) = max(max(B))*uint8(ones(200));

figure, imshow(resultado)
figure, imshow(resultadoPromedios)
figure, imshow(resultadoMax)