clc
clear all
close all

% Crear más datos para el reporte
nombres = {'Juan', 'María', 'Carlos', 'Laura', 'Pedro'};
edades = [25, 30, 22, 28, 35];
puntajes = [90, 85, 78, 92, 88];

% Obtener la fecha actual en formato 'yyyymmdd'
fechaActual = datestr(now, 'yyyymmdd');

% Combinar los datos en una matriz
datos = [nombres', num2cell(edades'), num2cell(puntajes')];

% Definir el nombre del archivo de Excel con la fecha actual
nombreArchivo = ['reporte_' fechaActual '.xlsx'];

% Escribir los datos en una hoja de Excel
xlswrite(nombreArchivo, {'Nombre', 'Edad', 'Puntaje'}, 'Hoja1', 'A1');
xlswrite(nombreArchivo, datos, 'Hoja1', 'A2');

% Mostrar un mensaje de confirmación
disp(['Reporte exportado exitosamente como ' nombreArchivo]);
