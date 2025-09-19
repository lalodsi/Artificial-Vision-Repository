clc
clear all
close all

%configuration
ntimes=100;
scale=1/1; % escala de la imagen
step_size = 1;




%Tracking params

% balls
% dXFACTOR=1.0;
% dYFACTOR=1.0*0.55;
% XOFFSET = -140;
% YOFFSET = 0;
% cradio=60*scale;
%%% uncomment just one
%[IMLIST IMMATRIX ORIGINALES]=LoadImages(1,55,'./secuencias/ballx/ballx','.JPG',3,1);
%[IMLIST IMMATRIX ORIGINALES]=LoadImages(1,55,'./secuencias/bally/bally','.JPG',3,1);
% [IMLIST,IMMATRIX,ORIGINALES]=LoadImages(1,62,'./secuencias/ballxy/ballxy','.jpg',3,1);

% --------------------------------------------------------
% % microphone
% 
% dXFACTOR=1.0*0.85;
% dYFACTOR=1.0*0.80;
% XOFFSET = -40;
% YOFFSET = 0;
% cradio=70*scale;
% %uncomment just one
% [IMLIST IMMATRIX ORIGINALES] = LoadImages(1,30,'./secuencias/micmov/mic','.JPG',3,1);

% --------------------------------------------------------
% cubes at zeros

%Tracking params
 dXFACTOR=1.0*0.25; %% termino de calibraci�n de la velocidad en X
 dYFACTOR=1.0*0.20; %% termino calibraci�n de la velocidad en Y
 XOFFSET = 0;       %% posici�n inicial en X del rectangulo (amarillo) de tracking
 YOFFSET = 0;       %% posici�n inicial en Y del rectangulo (amarillo) de tracking
 cradio=65*scale;   %% tama�o del rectangulo de tracking
% % uncomment just one
% %[IMLIST IMMATRIX ORIGINALES]=LoadImages(1,300,'./secuencias/secuencia_sintetica_gaussianas_traslacion_x/secuencia_tx_','.bmp',5,1);
% %[IMLIST IMMATRIX ORIGINALES]=LoadImages(1,300,'./secuencias/secuencia_sintetica_gaussianas_traslacion_y/secuencia_ty_','.bmp',5,1);
[IMLIST IMMATRIX ORIGINALES]=LoadImages(1,300,'./secuencias/secuencia_cubo_tx/secuencia_cubo_tx_','.bmp',5,1);
% [IMLIST IMMATRIX ORIGINALES]=LoadImages(1,300,'./secuencias/secuencia_cubo_ty/secuencia_cubo_ty_','.bmp',5,1);


im_start = 1; %%frame inicial
im_end   = size(IMMATRIX,1); %%frame final 

ntime=1;  %% contador 
MatrixT1= squeeze(IMMATRIX(1,:,:)); %%inicializar matriz de imagen
[X Y]=size(MatrixT1); 

cx0=(Y/2.0)-cradio+XOFFSET;  %% punto X de esquina superior izquierda de rectangulo tracking
cx1=(Y/2.0)+cradio+XOFFSET;  %% punto X de esquina inferior derecha de rectangulo tracking
cy0=(X/2.0)-cradio-YOFFSET;  %% Y superior izquierda
cy1=(X/2.0)+cradio-YOFFSET;  %% Y inferior derecha

%%% a es una lista de los frames, en orden ascedente y luego descendente.
%%% 1,2,3,4,5,4,3,2,1



%text_color = [108/256 121/256 178/256];
text_color = 'w';

while ntime<ntimes && step_size<im_end-1
    a= [im_start:step_size:im_end im_end:-step_size:im_start];
    
    for FRAME=a       
                
        MatrixT0 = MatrixT1; %% MatrixT1 tiene la matrix en uint8 de las intesidades de cada pixel de la imagen
        MatrixT1 = squeeze(IMMATRIX(FRAME,:,:)); %% squeeze elimina dimension superflua
        
        [A0,LX0,LY0,PX0,PY0,FX0,FY0]=GetMoments(MatrixT0); %%calculo los momentos para el frame anterior 
        [A1,LX1,LY1,PX1,PY1,FX1,FY1]=GetMoments(MatrixT1); %% calculo lo momentos para el frame actual
        
        dX=(PX1-PX0)*dXFACTOR; %% estimo el cambio de posici�n en X
        dY=(PY1-PY0)*dYFACTOR; %% estimo el cambio de posici�n en Y
        dL=(LY1-LY0)*sign(dX)*10; %% estimo el cambio de longitud en X e Y
        c =(LX1/LY1);             %% c es la constante de movimiento en Z
        cp=(LX1/LY1)-(LX0/LY0);   %% cp es  c_t+1 - c_t
        dZ=(LX1-LX0)+(LY1-LY0);   %% estimar velocidad en Z
        %dZ=0

        %%actualizo puntos de rectangulo de tracking
        cx0=cx0+(dX)-dZ*15;  
        cx1=cx1+(dX)+dZ*15;
        cy0=cy0+(dY)-dZ*15;
        cy1=cy1+(dY)+dZ*15;
               
        
        imshow(  squeeze(ORIGINALES(FRAME,:,:,:)) );  %% grafico la imagen original, que puede ser en color
        hold on
        
        %%% valores de los momentos para el frame actual
        
        text(10,15,['\DeltaA:     ' num2str(A1-A0)],'Color',text_color); 
        text(10,35,['\DeltaL_x:       ' num2str(LX1-LX0)],'Color',text_color);
        text(10,55,['\DeltaL_y:       ' num2str(LY1-LY0)],'Color',text_color);
        text(10,75,['\DeltaP_x:    ' num2str(PX1-PX0)],'Color',text_color);
        text(10,95,['\DeltaP_y:    ' num2str(PY1-PY0)],'Color',text_color);

        title(['Frame: ' num2str(FRAME) '   Frame step: ' num2str(step_size) ]);                       
        
        %%% grafico el rectangulo de seguimiento
        plot([cx0 cx1 cx1 cx0 cx0],[cy0 cy0 cy1 cy1 cy0],'Color','y','LineWidth',2);        
        drawnow        
        hold off        
        %pause(0.01)
        
       
    
    end
    ntime=ntime +1;
    step_size = step_size + 1;    
end




