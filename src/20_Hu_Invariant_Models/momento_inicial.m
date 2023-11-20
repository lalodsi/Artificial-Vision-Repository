function mpq = momento_inicial(f,p,q)
    [filas, columnas] = size(f);
    G = zeros(filas, columnas);
    for j = 1:filas
        for i = 1:columnas
            G(j,i) = (i^p)*(j^q)*f(j,i);
        end
    end
    mpq = sum(sum(G));
end