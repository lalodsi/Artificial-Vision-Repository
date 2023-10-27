function OutImage = erosion(ImageBinary,StructuralElement, k)
    [filas, columnas] = size(ImageBinary);

    OutImage = zeros(filas, columnas);
    % OutImage = ImageBinary;
    for N = 1:k
        for j = 2:filas-1
            for i = 2:columnas-1
                if ImageBinary(j-1:j+1,i-1:i+1) == StructuralElement
                    OutImage(j,i) = 1;
                end
            end
        end

        imshow(uint8(255*OutImage))
        title(num2str(N))
        drawnow

        ImageBinary = OutImage;
    end
end