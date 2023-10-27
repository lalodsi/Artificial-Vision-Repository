function [min, max] = getHueRange(Slice)
    HSV = rgb2hsv(Slice);
    Hue = HSV(:,:,1);

    histogram = zeros(1,256);   

    [slice_rows, slice_cols] = size(Hue);
    for j = 1:slice_rows
        for i = 1:slice_cols
            histogram(floor(255*Hue(j,i)+1)) = histogram(floor(255*Hue(j,i)+1)) + 1;
        end
    end

    min = 0;
    max = 0;
    for i=1:255
        if (histogram(i+1) > 0 && histogram(i) == 0)
            min = (i)/255;
        end
        if (histogram(i) > 0 && histogram(1,i+1) == 0)
            max = (i+1)/255;
        end
    end
end
