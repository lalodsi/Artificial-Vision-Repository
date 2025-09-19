clc
clear all
close all

f = figure("Position", [300 300 700 400]);

global min_value
global max_value
min_value = '0';
max_value = '0.5';

control_panel = uipanel(f,"Title","Control", Position=[0.1 0.05 0.75,0.3]);
min_value_control = uicontrol(control_panel, "Style", "edit", "BackgroundColor", "#f37", 'Callback', @(src, event) handle_change_min(src), Position=[30 30 100 45]);
max_value_control = uicontrol(control_panel, "Style", "edit", "BackgroundColor", "#f37", 'Callback', @(src, event) handle_change_max(src), Position=[350 30 100,45]);
min_value_text = uicontrol(control_panel, "Style", "text", Position=[30 10 100 35]);
max_value_text = uicontrol(control_panel, "Style", "text", Position=[350 10 100,35]);
% button_stop = uicontrol(control_panel,"Style","pushbutton", "String", "Stop", "Position", [110 10 100 95], , e);

% Camera
image_panel = uipanel(f,"Title","Camera", Position=[0,0.35,1,0.7]);
image_ax = uiaxes("Parent", image_panel);

cam = webcam('USB CAMERA');
% Settings
cam.Resolution = '640x480';
while true
    image = snapshot(cam);

    image_gray = rgb2gray(image);
    % Pre-analisys Filtering
    EE = [0 1 0; 1 1 1; 0 1 0];
    HSV = rgb2hsv(image);
    Hue = HSV(:,:,1);
    Saturation = HSV(:,:,2);
    Value = HSV(:,:,3);
    [rows, cols] = size(Hue);

    gen_bin = zeros(size(Hue));
    for j = 1:rows
        for i = 1:cols
            % Use sigmoid function as filter
            % gen_bin(j,i) =1 - 1/(1+exp(-40*(Value(j,i)-0.4)));
            z_value = 1 - 1/(1+exp(-40*(Value(j,i)-0.75)));
            z_saturation = 1/(1+exp(-50*(Saturation(j,i)-0.2)));
            gen_bin(j,i) = z_value * 255;
        end
    end
    % gen_bin = gen_bin > 0.5;
    image_dilated = imdilate(gen_bin, EE);
    image_eroded = imerode(image_dilated, EE);
    image_gaussian = imgaussfilt(image_eroded,2);

    try
        image_bordered = edge(image_gaussian, "Canny", [str2double(min_value) str2double(max_value)]);
        for n = 1:2
            image_bordered = imdilate(image_bordered, EE);
        end
        image_filled = imfill(image_bordered, "holes");
        for n = 1:2
            image_filled = imerode(image_filled, EE);
        end
        min_value_text.String = min_value;
        max_value_text.String = max_value;
        imshow(image_gaussian, "Parent", image_ax)
        drawnow
    catch exception

    end
end

function handle_change_min(hObject)
    global max_value;
    global min_value;
    value = hObject.String;
    min_value = value;
    min_double = str2double(value);
    max_double = str2double(max_value);

end
function handle_change_max(hObject)
    global max_value;
    global min_value;

    value = hObject.String;
    max_value = value;
    min_double = str2double(min_value);
    max_double = str2double(value);

end