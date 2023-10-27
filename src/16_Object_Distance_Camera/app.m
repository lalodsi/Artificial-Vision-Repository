clc
clear all
close all

% fig = uifigure;
% Getting the first webcam object
cam = webcam('USB CAMERA');

% Settings
cam.Resolution = '1920x1080';

% Experimental values
% Green
min_green = 0.3333;
max_green = 0.4431;
% Pink
min_Pink = 0.8510;
max_Pink = 0.9412;
% Blue Intense
min_blue = 0.5059;
max_blue = 0.5961;
% Orange
min_Orange = 0.0314;
max_Orange = 0.0706;

% To load the webcam correctly
snapshot(cam);
snapshot(cam);
snapshot(cam);
snapshot(cam);
snapshot(cam);

% Create ilustration
[filas, columnas, capas] = size(snapshot(cam));
Ilustration = zeros(filas, columnas, capas);
Ilustration(filas*.8,:,:) = uint8(ones(1, columnas, 3));
for i = 1:filas
    for j = 1:columnas
        % Vision angles
        if (j-0.2*columnas > i) && (columnas*1.1-j > i)
            Ilustration(i,j,1) = 0/256;
            Ilustration(i,j,2) = 100/256;
            Ilustration(i,j,3) = 200/256;
        end
        if (j+0.1*columnas > i) && (columnas*.8-j > i)
            Ilustration(i,j,1) = 0/256;
            Ilustration(i,j,2) = 100/256;
            Ilustration(i,j,3) = 200/256;
        end
        if (j+0.1*columnas > i) && (columnas*.8-j > i) && (j-0.2*columnas > i) && (columnas*1.1-j > i)
            Ilustration(i,j,1) = 0/256;
            Ilustration(i,j,2) = 150/256;
            Ilustration(i,j,3) = 250/256;
        end
        % Axis in the middle of the cam vision
        if (j == columnas*.35)
            Ilustration(i,j,:) = uint8(ones(1,1,3));
        end
        if (j == columnas*.65)
            Ilustration(i,j,:) = uint8(ones(1,1,3));
        end
    end
end
Ilustration(filas*.2-5:filas*.2+5,columnas*.4-5:columnas*.4+5,:) = uint8(ones(11, 11, 3));
Ilustration(filas*.2-5:filas*.2+5,columnas*.45-5:columnas*.45+5,:) = uint8(ones(11, 11, 3));
Ilustration(filas*.2-5:filas*.2+5,columnas*.50-5:columnas*.50+5,:) = uint8(ones(11, 11, 3));
Ilustration(filas*.2-5:filas*.2+5,columnas*.55-5:columnas*.55+5,:) = uint8(ones(11, 11, 3));

figure, imshow(Ilustration)
title('Plano de planta');

% Adquire images
% Adquire left image
questdlg("Move your webcam on the left side.", 'Waiting for your response', 'continue', 'continue')

ImageLeft = snapshot(cam);
% figure, imshow(ImageLeft)

[filas, columnas, ~] = size(ImageLeft);
ImageLeft(:,columnas/2,:) = uint8(zeros(filas, 1,3));
ImageLeft(filas/2,:,:) = uint8(zeros(1, columnas, 3));

% Split objects
FullImageHSV = rgb2hsv(ImageLeft);
FullImageHue = FullImageHSV(:,:,1);
FullImageSaturation = FullImageHSV(:,:,2);
% figure, imshow(FullImageSaturation)
GreenObject = (FullImageHue > min_green & FullImageHue < max_green & FullImageSaturation > 0.4);
BlueObject = (FullImageHue > min_blue & FullImageHue < max_blue & FullImageSaturation > 0.4);
OrangeObject = (FullImageHue > min_Orange & FullImageHue < max_Orange & FullImageSaturation > 0.4);
PinkObject = (FullImageHue > min_Pink & FullImageHue < max_Pink & FullImageSaturation > 0.4);
% Getting centroids
[xc_green_left, yc_green_left]= getCentroids(GreenObject);
[xc_blue_left, yc_blue_left]= getCentroids(BlueObject);
[xc_Orange_left, yc_Orange_left]= getCentroids(OrangeObject);
[xc_Pink_left, yc_Pink_left]= getCentroids(PinkObject);
% Moving reference
xc_green_left = xc_green_left - columnas/2;
xc_blue_left = xc_blue_left - columnas/2;
xc_Orange_left = xc_Orange_left - columnas/2;
xc_Pink_left = xc_Pink_left - columnas/2;

% figure, imshow(GreenObject)
% title('Green')
% figure, imshow(BlueObject)
% title('Blue')
% figure, imshow(OrangeObject)
% title('Orange')
% figure, imshow(PinkObject)
% title('Pink')


% Erosion

[rows, cols] = size(GreenObject);
StructuralElement = [1 1 1
1 1 1
1 1 1];
NewGreenObject = zeros(size(GreenObject));
NewBlueObject = zeros(size(GreenObject));
NewOrangeObject = zeros(size(GreenObject));
NewPinkObject = zeros(size(GreenObject));
for N = 1:2
    for j = 2:rows-1
        for i = 2:cols-1
            if GreenObject(j-1:j+1,i-1:i+1) == StructuralElement
                NewGreenObject(j,i) = 1;
            end
            if BlueObject(j-1:j+1,i-1:i+1) == StructuralElement
                NewBlueObject(j,i) = 1;
            end
            if OrangeObject(j-1:j+1,i-1:i+1) == StructuralElement
                NewOrangeObject(j,i) = 1;
            end
            if PinkObject(j-1:j+1,i-1:i+1) == StructuralElement
                NewPinkObject(j,i) = 1;
            end
            
        end
    end
end
GreenObject = NewGreenObject;
BlueObject = NewBlueObject;
OrangeObject = NewOrangeObject;
PinkObject = NewPinkObject;

clear GreenObject BlueObject OrangeObject PinkObject FullImageHSV FullImageHue FullImageSaturation NewGreenObject NewBlueObject NewOrangeObject NewPinkObject

% Adquire right image
questdlg("Move your webcam on the right side.", 'Waiting for your response', 'continue', 'continue')
close all
ImageRight = snapshot(cam);
ImageRight(:,columnas/2,:) = uint8(zeros(filas, 1,3));
ImageRight(filas/2,:,:) = uint8(zeros(1, columnas, 3));

% Split objects
FullImageHSV = rgb2hsv(ImageRight);
FullImageHue = FullImageHSV(:,:,1);
FullImageSaturation = FullImageHSV(:,:,2);
GreenObject = (FullImageHue > min_green & FullImageHue < max_green & FullImageSaturation > 0.4);
BlueObject = (FullImageHue > min_blue & FullImageHue < max_blue & FullImageSaturation > 0.4);
OrangeObject = (FullImageHue > min_Orange & FullImageHue < max_Orange & FullImageSaturation > 0.4);
PinkObject = (FullImageHue > min_Pink & FullImageHue < max_Pink & FullImageSaturation > 0.4);

NewGreenObject = zeros(size(GreenObject));
NewBlueObject = zeros(size(GreenObject));
NewOrangeObject = zeros(size(GreenObject));
NewPinkObject = zeros(size(GreenObject));
for N = 1:2
    for j = 2:rows-1
        for i = 2:cols-1
            if GreenObject(j-1:j+1,i-1:i+1) == StructuralElement
                NewGreenObject(j,i) = 1;
            end
            if BlueObject(j-1:j+1,i-1:i+1) == StructuralElement
                NewBlueObject(j,i) = 1;
            end
            if OrangeObject(j-1:j+1,i-1:i+1) == StructuralElement
                NewOrangeObject(j,i) = 1;
            end
            if PinkObject(j-1:j+1,i-1:i+1) == StructuralElement
                NewPinkObject(j,i) = 1;
            end
            
        end
    end
end
GreenObject = NewGreenObject;
BlueObject = NewBlueObject;
OrangeObject = NewOrangeObject;
PinkObject = NewPinkObject;


% figure, imshow(GreenObject)
% title('Green')
% figure, imshow(BlueObject)
% title('Blue')
% figure, imshow(OrangeObject)
% title('Orange')
% figure, imshow(PinkObject)
% title('Pink')

% Getting centroids
[xc_green_right, yc_green_right]= getCentroids(GreenObject);
[xc_blue_right, yc_blue_right]= getCentroids(BlueObject);
[xc_Orange_right, yc_Orange_right]= getCentroids(OrangeObject);
[xc_Pink_right, yc_Pink_right]= getCentroids(PinkObject);
% Moving reference
xc_green_right = xc_green_right - columnas/2;
xc_blue_right = xc_blue_right - columnas/2;
xc_Orange_right = xc_Orange_right - columnas/2;
xc_Pink_right = xc_Pink_right - columnas/2;

% Measuring distance
% Centimeters
d = 10;
Foco = 1541.2;
% Foco = Z*(xl-xr)/d

Z_green = Foco*d/(xc_green_left-xc_green_right)
Z_blue = Foco*d/(xc_blue_left-xc_blue_right)
Z_Orange = Foco*d/(xc_Orange_left-xc_Orange_right)
Z_Pink = Foco*d/(xc_Pink_left-xc_Pink_right)

Results = [
    "Results:";
    strcat("Green object: ", string(Z_green), " cm");
    strcat("Blue object: ", string(Z_blue), " cm");
    strcat("Orange object: ", string(Z_Orange), " cm");
    strcat("Pink object: ", string(Z_Pink), " cm");
];
msgbox(Results);

winner = "";
if (Z_green < Z_blue) && (Z_green < Z_Orange) && (Z_green < Z_Pink)
    winner = "Green";
end
if (Z_blue < Z_Orange) && (Z_blue < Z_green) && (Z_blue < Z_Pink)
    winner = "Blue";
end
if (Z_Orange < Z_Pink) && (Z_Orange < Z_blue) && (Z_Orange < Z_green)
    winner = "Orange";
end
if (Z_Pink < Z_Orange) && (Z_Pink < Z_blue) && (Z_Pink < Z_green)
    winner = "Orange";
end
msgbox(["The nearest object is:"; winner]);
% end