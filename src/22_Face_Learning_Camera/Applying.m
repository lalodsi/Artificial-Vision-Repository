clc
clear all
close all

PHOTO_SIZE=230400;

% Load W learned
load('clase.mat',"W")

% Getting the first webcam object
cam = webcam();
% Settings
% cam.Resolution = '1280x720';
cam.Resolution = '640x360';

texts = {'Luis', 'Hector', 'Geissler'};
while true
    image = snapshot(cam);
    imgray = double(rgb2gray(image));
    imarr = reshape(imgray, [1, PHOTO_SIZE]);
    % imarr = imarr / norm(imarr);
    a = imarr*W;
    clc
    % a
    imshow(image)
    [F,B] = max(a)
    title(texts(B))
    drawnow
end
