function F = filtroBinomial(T)
    for k = 0:T-1
        h(k+1) = nchoosek(T-1,k);
    end
    F = (h'*h) / sum(h'*h,"all");
end