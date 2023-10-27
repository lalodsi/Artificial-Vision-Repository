function graphic(X, Y, image, color)
    [filas, columnas] = size(image);
    figure, subplot(3,2,1)
    plot(X, "Color", 'k')
    title(strcat(['Centoide X ' color]))
    ylim([0 columnas])

    subplot(3,2,2)
    plot(Y, "Color", 'k')
    title(strcat(['Centoide Y ' color]))
    ylim([0 filas])

    % Velocidades
    [~, positionLength] = size(X);
    for i = 2:positionLength
        VX(i-1) = (X(i) - X(i-1))/0.153822;
        VY(i-1) = (Y(i) - Y(i-1))/0.153822;
    end

    subplot(3,2,3)
    plot(VX, "Color", 'k')
    title(strcat(['Velocidad X ' color]))
    % ylim([0 columnas])

    subplot(3,2,4)
    plot(VY, "Color", 'k')
    title(strcat(['Velocidad Y ' color]))
    % ylim([0 filas])


    % Aceleraciones
    [~, velocityLength] = size(VX);
    for i = 2:velocityLength
        AX(i-1) = (VX(i) - VX(i-1))/0.153822;
        AY(i-1) = (VY(i) - VY(i-1))/0.153822;
    end

    subplot(3,2,5)
    plot(AX, "Color", 'k')
    title(strcat(['Aceleración X ' color]))
    % ylim([0 columnas])

    subplot(3,2,6)
    plot(AY, "Color", 'k')
    title(strcat(['Aceleración Y ' color]))
    % ylim([0 filas])
end