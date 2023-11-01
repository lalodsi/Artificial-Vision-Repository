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
W
PatronPrueba = PatronPrueba / norm(PatronPrueba)

A = compet(W'*PatronPrueba);

[I,B] = max(a)