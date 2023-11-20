clc
clear all
close all

P1 = [1;1];
P2 = [-1;3];
P3 = [-3;-1];
P4 = [-2;-2];
P5 = [1;-2];
P6 = [2;-2];

Pp1 = [0;2];
Pp2 = [3;-3];

P = [P1 P2 P3 P4 P5 P6];
% Numero Elementos y Numero Patrones
[NE,NP] = size(P);

% Familias
F1 = P1;
F2 = P3;
F3 = P5;

W = [F1 F2 F3];

% scatter(P(1,:), P(2,:), 'fill')
% xlim([-4 4])
% ylim([-4 4])

for epocas = 1:100
    epocas
    for j = 1:NP
        hold on
        cla
        % Plotting the original patterns
        color = 'rrggbb';
        for i = 1:NP
            P(:,i) = P(:,i)/norm(P(:,i));
            quiver(0,0,P(1,i),P(2,i), color(i))
        end
        % Plotting the learned points
        color = 'cmy';
        for i = 1:3
            W(:,i) = W(:,i)/norm(W(:,i));
            quiver(0,0,W(1,i),W(2,i), color(i))
        end
        % Using the compet neurone
        a = compet(W'*P(:,j));
        W = W+(0.05*a*P(:,j)')';
        grid
        axis([-2 2 -2 2])
        drawnow
    end
    hold off
end