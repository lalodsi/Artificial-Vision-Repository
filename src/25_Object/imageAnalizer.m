clc
clear all
close all

% Getting the first webcam object
cam = webcam();
% Settings
cam.Resolution = '640x360';
 
EE = [0 1 0
    1 1 1
    0 1 0];


while true
    % image = imread("lata_buena.jpg");
    image = snapshot(cam);
    %image = imcrop(image, [140 30 380 300]);
    image_gray = rgb2gray(image);
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
    image_thined = bwmorph(image_bordered, "thin", Inf);
    imshow(image_thined)
    % newImg = zeros(size(image));
    % newImg(:,:,1) = uint8(eroded).*image(:,:,1);
    % newImg(:,:,2) = uint8(eroded).*image(:,:,2);
    % newImg(:,:,3) = uint8(eroded).*image(:,:,3);
    % imshow(uint8(newImg))
    drawnow
    %min = min + 0.05;
end