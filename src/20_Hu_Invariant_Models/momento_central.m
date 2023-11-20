function upq = momento_central(f,p,q,xc,yc)
    [filas, columnas] = size(f);
    G = zeros(filas, columnas);
    for j = 1:filas
        for i = 1:columnas
            G(j,i) = ((i-xc)^p)*((j-yc)^q)*f(j,i);
        end
    end
    upq = sum(sum(G));
end