clc
clear all
close all

% Getting the first webcam object
cam = webcam('USB CAMERA');

% Settings
cam.Resolution = '1920x1080';

% Get averages and standard deviation of objects
Blue = [0.6127, 0.6296, 0.5798, 0.6052, 0.5949, 0.5926, 0.5882];
BlueAverage = mean(Blue);
BlueStandardDev = std(Blue);

Green = [0.2024, 0.2416, 0.24, 0.2416, 0.2353];
GreenAverage = mean(Green);
GreenStandardDev = std(Green);

Red = [0.0078, 0.0099, 0.0157, 0.0156, 0.0121];
RedAverage = mean(Red);
RedStandardDev = std(Red);

% preallocate variables
blueXC = [];
blueYC = [];
redXC = [];
redYC = [];
greenXC = [];
greenYC = [];

% Start image adquisition
for counter = -10:45
    % Adquire image
    image = snapshot(cam);

    if counter > 0
        HSV = rgb2hsv(image);

        Hue = HSV(:,:,1);
        Saturation = HSV(:,:,2);
        Value = HSV(:,:,3);

        [filas, columnas] = size(Hue);

        BlueBinary = zeros(size(Hue));
        RedBinary = zeros(size(Hue));
        GreenBinary = zeros(size(Hue));
        multiplier = 7;
        for x_pos = 1:filas
            for y_pos = 1:columnas
                if (...
                    Saturation(x_pos, y_pos)>0.5...
                    )
                    if (Hue(x_pos, y_pos)> (BlueAverage-multiplier*BlueStandardDev) && Hue(x_pos, y_pos)< (BlueAverage+multiplier*BlueStandardDev))
                        BlueBinary(x_pos, y_pos) = 1;
                    end
                    if (Hue(x_pos, y_pos)> (RedAverage-multiplier*RedStandardDev) && Hue(x_pos, y_pos)< (RedAverage+multiplier*RedStandardDev))
                        RedBinary(x_pos, y_pos) = 1;
                    end
                    if (Hue(x_pos, y_pos)> (GreenAverage-multiplier*GreenStandardDev) && Hue(x_pos, y_pos)< (GreenAverage+multiplier*GreenStandardDev))
                        GreenBinary(x_pos, y_pos) = 1;
                    end
    
                end
            end
        end

        [blue_xc, blue_yc] = getCentroids(BlueBinary);
        [red_xc, red_yc] = getCentroids(RedBinary);
        [green_xc, green_yc] = getCentroids(GreenBinary);
        blueXC(counter) = blue_xc;
        blueYC(counter) = blue_yc;
        redXC(counter) = red_xc;
        redYC(counter) = red_yc;
        greenXC(counter) = green_xc;
        greenYC(counter) = green_yc;

        colors=zeros(filas, columnas, 3);
        colors(:,:,1) = RedBinary;
        colors(:,:,2) = GreenBinary;
        colors(:,:,3) = BlueBinary;

        [~, pos] = size(redXC);

        sizeOfPoint = 5;
        for i = 1:pos
            try
            image( ...
                filas - (floor(redYC(i))-sizeOfPoint:floor(redYC(i))+sizeOfPoint), ...
                floor(redXC(i))-sizeOfPoint:floor(redXC(i))+sizeOfPoint, ...
                1) = 255*ones(11);
            image(filas - (floor(greenYC(i))-sizeOfPoint:floor(greenYC(i))+sizeOfPoint), ...
                floor(greenXC(i))-sizeOfPoint:floor(greenXC(i))+sizeOfPoint, ...
                2) = 255*ones(11);
            image(filas - (floor(blueYC(i))-sizeOfPoint:floor(blueYC(i))+sizeOfPoint), ...
                floor(blueXC(i))-sizeOfPoint:floor(blueXC(i))+sizeOfPoint, ...
                3) = 255*ones(11);
            catch exception
                
            end
            
        end

        imshow(image)
        drawnow
    end
end

graphic(blueXC, blueYC, BlueBinary, 'Azul');
graphic(redXC, redYC, RedBinary, 'Rojo');
graphic(greenXC, greenYC, GreenBinary, 'Verde');

figure,
plot(redXC, redYC, "LineWidth", 5, "Color", 'r')
hold on
plot(greenXC, greenYC, "LineWidth", 5, "Color", 'g')
hold on
plot(blueXC, blueYC, "LineWidth", 5, "Color", 'b')

title('Posicion XY de los tres objetos')
ylim([0 filas])
xlim([0 columnas])