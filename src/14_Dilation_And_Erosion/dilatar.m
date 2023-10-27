function OutImage = dilatar(ImageBinary,StructuralElement, k)
    [filas, columnas] = size(ImageBinary);

    OutImage = zeros(filas, columnas);
    for N = 1:k
        OutImage = ImageBinary;
        for j = 2:filas-1
            for i = 2:columnas-1
                if i==2 && j==2
                    OutImage(j,i) = 1;
                end
                if ImageBinary(j,i) == 1
                    % OutImage(j-1:j+1,i-1:i+1) = ImageBinary(j-1:j+1,i-1:i+1) | StructuralElement;
                    % OutImage(j-1:j+1,i-1:i+1) = ImageBinary(j-1:j+1,i-1:i+1);
                    OutImage(j-1:j+1,i-1:i+1) = StructuralElement;
                end
            end
        end
    
        imshow(OutImage)
        % imshow(uint8(255*OutImage))
        title(num2str(k))
        drawnow
    end
end