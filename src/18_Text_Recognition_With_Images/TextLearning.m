clc
clear all
close all

Alfabeto = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ';

image = imread("patrones.bmp");
% image = imread("masqueamor.bmp");
grayImage = rgb2gray(image);
invertedImage = double(grayImage < 127);

imshow(invertedImage)
title('This program will learn from these letters images and save the result ')

% Get rows
XSum = sum(invertedImage, 2);
counter1 = 1;
counter2 = 1;

for row = 2:length(XSum)-1
    if XSum(row) == 0 && XSum(row+1) > 0
        risingEdgeRowPos(counter1) = row;
        counter1 = counter1 + 1;
    end
    if XSum(row-1) > 0 && XSum(row) == 0
        fallingEdgeRowPos(counter2) = row;
        counter2 = counter2 + 1;
    end
end

% Show every row
W = zeros(30*30, 26);
for i = 1:length(risingEdgeRowPos)
    row = invertedImage(risingEdgeRowPos(i):fallingEdgeRowPos(i), :);
    YSum = sum(row,1);
    counter3 = 1;
    counter4 = 1;

    for col = 2:length(YSum)-1
        if YSum(col) == 0 && YSum(col+1) > 0
            risingEdgeColPos(counter3) = col;
            counter3 = counter3 + 1;
        end
        if YSum(col-1) > 0 && YSum(col) == 0
            fallingEdgeColPos(counter4) = col;
            counter4 = counter4 + 1;
        end
    end

    n=(i-1) * 26 + 1;

    for j = 1:length(risingEdgeColPos)
        space = zeros(30);
        word = row(:,risingEdgeColPos(j):fallingEdgeColPos(j));
        [rows, cols] = size(word);
        space(1:rows,1:cols) = word;
        character = space;
        singleArrWord = reshape(character, 30*30,1);
        normalizeArrWord = singleArrWord/norm(singleArrWord);
        W(:,n) = normalizeArrWord;
        n = n+1;
    end
end

save('learned.mat',"W")
