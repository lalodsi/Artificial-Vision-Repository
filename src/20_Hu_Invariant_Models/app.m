clc
clear
close all

% Create path
for k = 1:25
    ruta = strcat('Modelos/', num2str(k), '.bmp');

    image = imread(ruta);
    gray = rgb2gray(image);
    f = double(gray < 200);

    m00 = momento_inicial(f,0,0);
    m10 = momento_inicial(f,1,0);
    m01 = momento_inicial(f,0,1);

    Xc = m10/m00;
    Yc = m01/m00;

    u00 = momento_central(f,0,0,Xc,Yc);
    u20 = momento_central(f,2,0,Xc,Yc);
    u02 = momento_central(f,0,2,Xc,Yc);
    u11 = momento_central(f,1,1,Xc,Yc);

    n20 = momento_central_normalizado(u20,2,0,u00);
    n02 = momento_central_normalizado(u02,2,0,u00);
    n11 = momento_central_normalizado(u11,1,1,u00);
    n30 = mcn(f,3,0);
    n12 = mcn(f,1,2);
    n21 = mcn(f,2,1);
    n03 = mcn(f,0,3);

    phi1 = n02 + n20;
    phi2 = (n02 - n20)^2 + 4*n11^2;
    phi3 = (n30 - 3*n12)^2 + (3*n21 - n03)^2;
    phi4 = (n30 + n12)^2 + (n21 + n03)^2;
    phi5 = (n30 - 3*n12)*(n30 + n12)*((n30 + n12)^2 - 3*(n21 + n03)) + (3*n21 - n03)*(n21+n03) * (3*(n30 + n12)^2 - (n21 + n03)^2);
    phi6 = (n20 - n02)*((n30+n12)^2 - (n21+n03)^2) + 4*n11*(n30+n12)*(n21+n03);
    phi7 = (3*n21-n03)*(n30+n12)*((n30+n12)^2 - 3*(n21+n03)^2) + (3*n12-n03)*(n21+n03)*(3*(n30+n12)^2 - (n21+n03)^2);

    
    phi1 = abs(log(abs(phi1)));
    phi2 = abs(log(abs(phi2)));
    phi3 = abs(log(abs(phi3)));
    phi4 = abs(log(abs(phi4)));
    phi5 = abs(log(abs(phi5)));
    phi6 = abs(log(abs(phi6)));
    phi7 = abs(log(abs(phi7)));

    subplot(5,5,k)
    imshow(image)
    title(num2str(phi6));

end