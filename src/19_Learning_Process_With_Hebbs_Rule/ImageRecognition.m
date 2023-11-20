clc
clear all
close all

for i = 1:36
    ima = imread(strcat('images/', num2str(i),'.jpg'));
    gris = rgb2gray(ima);
    f = double(reshape(gris,90000,1));
    N(i) = norm(f);
    P(:,i) = f/N(i);
    % imshow(ima)
end
% W=rand(90000,8);
W=P(:,1:8);
for epoca = 1:200
    for j = 1:36
        for i = 1:8
            W(:,i) = W(:,i) / norm(W(:,i));
        end
        a = compet(W'*P(:,j));
        W = W+(0.1*a*P(:,j)')';
    end
end
for k = 1:8
    imagen = uint8(reshape(N(k)*W(:,k),300,300));
    subplot(2,4,k)
    imshow(imagen)

end