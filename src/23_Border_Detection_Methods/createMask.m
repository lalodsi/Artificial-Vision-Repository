function S = createMask(T)
    S =zeros(T);
    [filas, columnas] = size(S);

    half = (T+1)/2;
    for j = 1:filas
        for i = 1:columnas
            if i < half && j < half || i < half && j > half
                S(j,i) = -1;
            elseif i > half && j < half || i > half && j > half
                S(j,i) = 1;
            elseif i < half && j == half
                % S(j,i) = -2; % Sobel
                S(j,i) = -1; % Prewit
            elseif i > half && j == half
                % S(j,i) = 2; % Sobel
                S(j,i) = 1; % Prewit
            end
        end
    end
end