clc
clear all
close all

circulo_firma = load("circulo.mat").distancias;

% Getting the first webcam object
cam = webcam('HD Webcam');
% Settings
cam.Resolution = '640x480';

% Make UI

f = figure("Position", [300 300 700 400]);
current_object_panel = uipanel(f,"Title","Current Object", Position=[0.01,0.8,0.35,0.15]);
current_object_text_state = uicontrol(current_object_panel,Style="text", String="State", Position=[0.2 15 200 15]);

count_panel = uipanel(f,"Title","Count", Position=[0.01,0.6,0.35,0.2]);
current_object_text_accepted = uicontrol(count_panel,Style="text", String="Accepted elements:", Position=[0.2 45 200 15], BackgroundColor='#af0', HorizontalAlignment='left');
current_object_text_rejected = uicontrol(count_panel,Style="text", String="Rejected elements:", Position=[0.2 30 200 15], BackgroundColor='#f68', HorizontalAlignment='left');
current_object_text_total = uicontrol(count_panel,Style="text", String="Total elements:", Position=[0.2 15 200 15], BackgroundColor='#acb', HorizontalAlignment='left');

control_panel = uipanel(f,"Title","Control", Position=[0.01 0.3 0.35,0.3]);
button_start = uicontrol(control_panel,"Style","pushbutton", "String", "Start", "Position", [10 10 100 95], "BackgroundColor", "#0f9", 'Callback', @(src, event) toggle_start());
button_stop = uicontrol(control_panel,"Style","pushbutton", "String", "Stop", "Position", [110 10 100 95], "BackgroundColor", "#f37", 'Callback', @(src, event) toggle_stop());

image_panel = uipanel(f,"Title","Camera", Position=[0.4,0.35,0.6,0.7]);
image_ax = axes("Parent", image_panel);
start_image = zeros(640,360,3);
imshow(start_image, "Parent", image_ax)

absolute_color_panel = uipanel(f,"Title","Absolute Color", Position=[0.4,0.05,0.3,0.3]);
abs_color_ax = axes("Parent", absolute_color_panel);

% absolute_color_panel = uipanel(f,"Title","State", Position=[00,0.05,0.3,0.25]);
% state_color_ax = axes("Parent", absolute_color_panel);

data_panel = uipanel(f,"Title","Properties", Position=[0.7,0.05,0.3,0.3]);
area_text = uicontrol(data_panel,Style="text", String="Area", Position=[0.2 70 200 15], BackgroundColor='#af0', HorizontalAlignment='left');
% area_percentage_text = uicontrol(data_panel,Style="text", String="Approval range: ", Position=[0.2 55 200 15], BackgroundColor='#af0', HorizontalAlignment='left');
object_accepted_text = uicontrol(data_panel,Style="text", fontsize=15, BackgroundColor='#fff', String="No state", Position=[0.2 5 200 30], HorizontalAlignment='left');


% red_image = zeros(100,100,3);
% red_image(:,:,1) = 255;
% green_image = zeros(100,100,3);
% green_image(:,:,2) = 255;
% global red_image
% global green_image



% image_figure = uiimage(image_panel);
% image_figure.ImageSource = uint8(zeros(640,360));
% imshow(ax, zeros(640,360));
% image = figure(image, "Position", [0 0 640 360]);

% Connect to Serial Port
Atmega = serialport("COM10", 9600);
global Atmega
Atmega.configureTerminator("LF")

% Main work
global input;

count_accepted = 0;
count_rejected = 0;
global count_accepted
global count_rejected
continue_flag = false;
while true
    % Get data from serial port
    try
        input = jsondecode(Atmega.readline());
        Atmega.flush("input")
        Atmega.flush("output")
    catch exception
        continue
    end

    imageTotal = snapshot(cam);
    imageReal = imcrop(imageTotal, [140 30 380 300]);
    % image = getUtilPixels(image);
    imshow(imageReal, "Parent", image_ax);

    % Get absolute color
    imabs = imageReal;
    [avrR, avrG, avrB] = getAbsoluteColor(imabs);
    imones = ones(size(rgb2gray(imabs)));
    imabs(:,:,1) = uint8(avrR * imones);
    imabs(:,:,2) = uint8(avrG * imones);
    imabs(:,:,3) = uint8(avrB * imones);
    imshow(imabs, "Parent", abs_color_ax)


    if ~input.state
        current_object_text_state.String = "You must click on start in order to make video analysis";
        continue
    end
    sensor_state = "";
    % Start analysis
    if ~input.sensor
        current_object_text_state.String = "There is an object";
        if ~continue_flag
            % Make sure the photo is well
            pause(1);
            snapshot(cam);
            snapshot(cam);
            snapshot(cam);
            snapshot(cam);
            imageTotal = snapshot(cam);
            imageReal = imcrop(imageTotal, [140 30 380 300]);
            [filled, image] = getUtilPixels(imageReal);
            [filas, columnas] = size(image);

            % for j = 1:filas
            %     for i = 1:columnas
            %         if filled(j,i)
            %             imageReal(j,i,:) = [0 0 0];
            %         end
            %     end
            % end
            imshow(filled, "Parent", image_ax);

            % signature = getSignature(image);
            disp("Analizando...")
            area = regionprops(image, "Area");
            area_text.String = strcat("Area: ",string(area(1).Area));

            if area(1).Area > 800
                object_accepted_text.String = "Accepted";
                object_accepted_text.BackgroundColor = "#8f4";
                Atmega.write("accept", "string")
                count_accepted = count_accepted + 1;
                current_object_text_accepted.String = strcat("Accepted elements: ",string(count_accepted));
            else
                object_accepted_text.String = "Rejected";
                object_accepted_text.BackgroundColor = "#f34";
                Atmega.write("reject", "string")
                count_rejected = count_rejected + 1;
                current_object_text_rejected.String = strcat("Rejected elements: ",string(count_rejected));
            end
            current_object_text_total.String = strcat("Total elements: ",string(count_rejected + count_accepted));
            pause(2)
            Atmega.write("continue", "string")
            continue_flag = true;
        else
            current_object_text_state.String = "Please remove the object";
        end
    else
        continue_flag = false;
        current_object_text_state.String = "No object";
    end
end

function toggle_start()
    global Atmega
    disp("Starting movement")
    Atmega.write("start", "string");
end
function toggle_stop()
    global Atmega;
    global count_accepted
    global count_rejected
    disp("Stoping movement")
    Atmega.write("stop", "string");

    % Obtener la fecha actual en formato 'yyyymmdd'
    fechaActual = datestr(now, 'yyyymmdd');

    % Combinar los datos en una matriz,
    total = count_accepted + count_rejected;
    if total == 0
        accepted_percentaje = 0;
        rejected_percentaje = 0;
    else
        accepted_percentaje = count_accepted / total * 100
        rejected_percentaje = count_rejected / total * 100;
    end
    datos = [datestr(now, 'yyyy/mm/dd'), datestr(now, 'hh:mm'), count_accepted, count_rejected, total, strcat(string(accepted_percentaje),'%'), strcat(string(rejected_percentaje),'%')];
    headers = {'Fecha'; 'Hora'; 'Total Aceptados'; 'Total Rechazados'; 'Total'; 'Porcentaje Aceptados'; 'Porcentaje Rechazados'};

    % Definir el nombre del archivo de Excel con la fecha actual
    nombreArchivo = ['reporte_' fechaActual '.xlsx'];

    % Escribir los datos en una hoja de Excel
    xlswrite(nombreArchivo, headers, 'Hoja1', 'A1');
    xlswrite(nombreArchivo, datos', 'Hoja1', 'B1');

    % Mostrar un mensaje de confirmación
    disp(['Reporte exportado exitosamente como ' nombreArchivo]);
end