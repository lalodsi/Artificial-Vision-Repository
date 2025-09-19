function [promedioR, promedioG, promedioB] = getAbsoluteColor(img)
    R = img(:,:,1);
    G = img(:,:,2);
    B = img(:,:,3);

    histogramaR = zeros(1, 256);
    histogramaG = zeros(1, 256);
    histogramaB = zeros(1, 256);

    [filas, columnas, capas] = size(img);

    for j=1:filas
        for i=1:columnas
            histogramaR(1, R(j,i)+1) = histogramaR(1, R(j,i) + 1) + 1;
            histogramaG(1, G(j,i)+1) = histogramaG(1, G(j,i) + 1) + 1;
            histogramaB(1, B(j,i)+1) = histogramaB(1, B(j,i) + 1) + 1;
        end
    end

    promedioR = sum(sum(R)) / (filas * columnas);
    promedioG = sum(sum(G)) / (filas * columnas);
    promedioB = sum(sum(B)) / (filas * columnas);
end