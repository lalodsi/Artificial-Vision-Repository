function F = filtroGaussiano(T,sig)
    for j = 1:T
        for i = 1:2:T
            F(j,i) = exp(-((i-T/2)^2+(j-T/2)^2)/sig^2);
        end
    end
    F = F / sum(F,"all");
end