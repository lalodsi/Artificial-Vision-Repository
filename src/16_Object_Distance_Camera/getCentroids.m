function [xc, yc] = getCentroids(ImageBinary)
    [filas, columnas] = size(ImageBinary);
    x = 1 : columnas;
    y = 1 : filas;

    fx = sum(ImageBinary,1);
    fy = sum(ImageBinary,2)';
    % Centroides
    xc = sum(x.*fx)/sum(fx);
    yc = filas - sum(y.*fy)/sum(fy);
end