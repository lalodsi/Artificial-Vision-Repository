clc
close all
clear all

for i=1:193
    num = num2str(i);
    if length(num) ==1
        numero=strcat('00000',num);
    elseif length(num)==2
        numero = strcat('0000',num);
    else
        numero = strcat('000',num);
    end

    ruta = strcat('C:\Archivos Guardados\UPIITA\Sistemas De Vision Artificial\Trabajo de Clase\Clase 26 Septiembre\CENTROIDE UNITY\C_',numero,'.jpg');

    Imagen = imread(ruta);

    HSV = rgb2hsv(Imagen);

    Hue = HSV(:,:,1);
    Saturation = HSV(:,:,2);

    [filas, columnas] = size(Hue);

    RedBinary = zeros(size(Hue));
    for x_pos = 1:filas
        for y_pos = 1:columnas
            if (Hue(x_pos, y_pos)>0.95 && Saturation(x_pos, y_pos)>0.73)
                RedBinary(x_pos, y_pos) = 1;
            end
        end
    end


    % sum(x.*histogramaR)/sum(histogramaR)
    x = 1 : columnas;
    y = 1 : filas;

    fx = sum(RedBinary,1);
    fy = sum(RedBinary,2)';
    % Centroides
    xc = sum(x.*fx)/sum(fx);
    yc = sum(y.*fy)/sum(fy);
    % Arreglo de los centroides
    XC(i) = xc;
    YC(i) = yc;

    % Aceleraciones
    % SizeCentroide = size(XC)
    % for i = 2:SizeCentroide(2)
    %     AX(i-1) = (VX(i) - VX(i-1))/0.03333;
    %     AY(i-1) = (YC(i) - YC(i-1))/0.03333;
    % end
    

    sizePoint = 5;
    Imagen( ...
        uint16(yc)-sizePoint : uint16(yc)+sizePoint, ...
        uint16(xc)-sizePoint : uint16(xc)+sizePoint, ...
        : ...
        ) = 255 * ones(2*sizePoint+1, 2*sizePoint+1, 3);

    % imshow(RedBinary)
    % imshow(Imagen)

    % drawnow
end

% Velocidades
% SizeCentroide = size(XC)
for i = 2:193
    VX(i-1) = (XC(i) - XC(i-1))/0.03333;
    VY(i-1) = (YC(i) - YC(i-1))/0.03333;
end

% Aceleraciones
for i = 2:192
    AX(i-1) = (VX(i) - VX(i-1))/0.03333;
    AY(i-1) = (VY(i) - VY(i-1))/0.03333;
end

figure, plot(XC)
title('Centroide X')
figure, plot(YC)
title('Centroide Y')
figure, plot(XC,YC)
title('XY')
figure, plot(VX)
title('Velocidad X')
figure, plot(VY)
title('Velocidad Y')
figure, plot(AX)
title('Aceleracion X')
figure, plot(AY)
title('Aceleracion Y')

% Graficas de fx y fy
% figure, plot(fx)
% figure, plot(fy)