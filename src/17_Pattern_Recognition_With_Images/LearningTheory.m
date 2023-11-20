clc
clear
close all

Patron1 = [1;1];
Patron2 = [-1;1];
Patron3 = [-1;-1];
Patron4 = [1;-1];

PatronPrueba = [-0.3;-0.5];

ConjuntoP = [Patron1 Patron2 Patron3 Patron4];

[NE, NP] = size(ConjuntoP);
for i = 1:NP
    W(:,i) = ConjuntoP(:,i)/norm(ConjuntoP(:,i));
end


finishProgram = true;
while finishProgram
    k = waitforbuttonpress;
    % 28 leftarrow
    % 29 rightarrow
    % 30 uparrow
    % 31 downarrow
    value = double(get(gcf,'CurrentCharacter'));
    switch value
        case 28
            PatronPrueba(1,1) = PatronPrueba(1,1) - 0.1;
        case 29
            PatronPrueba(1,1) = PatronPrueba(1,1) + 0.1;
        case 30
            PatronPrueba(2,1) = PatronPrueba(2,1) + 0.1;
        case 31
            PatronPrueba(2,1) = PatronPrueba(2,1) - 0.1;
        otherwise
    end

    % Learning
    PatronPruebaNormalizado = PatronPrueba / norm(PatronPrueba);
    A = compet(W'*PatronPruebaNormalizado);
    [I,B] = max(A);
    clc
    PatronPrueba
    disp(strcat('The Test Pattern is more like the Pattern ', string(B)))

    % Plotting
    cla
    scatter(ConjuntoP(1,:), ConjuntoP(2,:), 'filled')
    hold on
    scatter(PatronPrueba(1,1), PatronPrueba(2,1))
    xlim([-2 2])
    ylim([-2 2])
end