% Para obtener una imagen con el fondo recortado
% function newImg = getUtilPixels(img)
%     EE = [0 1 0
%     1 1 1
%     0 1 0];
%     image_gray = rgb2gray(img);
%     image_bordered = edge(image_gray, "Canny", [0.2 0.3]);
%     dilated = imdilate(image_bordered,EE);
%     dilated = imdilate(dilated,EE);
%     filled = imfill(dilated, "holes");
%     image_bordered = edge(filled, "Prewitt");
%     image_thined = bwmorph(image_bordered, "thin", Inf);
%     newImg = zeros(size(img));
%     newImg(:,:,1) = uint8(filled).*img(:,:,1);
%     newImg(:,:,2) = uint8(filled).*img(:,:,2);
%     newImg(:,:,3) = uint8(filled).*img(:,:,3);
%     newImg = uint8(newImg);
% end


function [filled, newImg] = getUtilPixels(img)
    EE = [0 1 0
    1 1 1
    0 1 0];
    image_gray = rgb2gray(img);
    image_bordered = edge(image_gray, "Canny", [0.35 0.5]);
    dilated = imdilate(image_bordered,EE);
    dilated = imdilate(dilated,EE);
    dilated = imdilate(dilated,EE);
    dilated = imdilate(dilated,EE);
    dilated = imdilate(dilated,EE);
    dilated = imdilate(dilated,EE);
    dilated = imdilate(dilated,EE);
    filled = imfill(dilated, "holes");
    image_bordered = edge(filled, "Prewitt");
    newImg = bwmorph(image_bordered, "thin", Inf);
end