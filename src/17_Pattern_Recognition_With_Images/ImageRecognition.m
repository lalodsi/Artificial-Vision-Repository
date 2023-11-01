clc
clear
close all

imagesToTest = 8;
totalImages = 36;

% Training
vectorizedImagesJunk = zeros(90000, imagesToTest);
for i = 1:imagesToTest
    ruta = strcat('images/', string(i), '.jpg');
    image = imread(ruta);
    imageGray = double(rgb2gray(image));
    vectorizedImage = reshape(imageGray, 90000, 1);
    normalizedImage = vectorizedImage/norm(vectorizedImage);
    vectorizedImagesJunk(:,i) = normalizedImage;
end
clear normalizedImage vectorizedImage imageGray image

% Comprobation

% vectorizedImagesJunk = zeros(90000, totalImages);
for i = 1:totalImages
    ruta = strcat('images/', string(i), '.jpg');
    image = imread(ruta);
    subplot(6,6,i)
    imshow(image)
    imageGray = double(rgb2gray(image));
    vectorizedImage = reshape(imageGray, 90000, 1);
    normalizedImage = vectorizedImage/norm(vectorizedImage);
    a = vectorizedImagesJunk'*normalizedImage;
    [F,B] = max(a)
    title(string(B))
    % title()
end