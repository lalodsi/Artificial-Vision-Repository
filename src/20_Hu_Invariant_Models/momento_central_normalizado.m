function npq = momento_central_normalizado(upq,p,q,u00)
    gamma = ((p+q)/2)+1;
    npq = upq/(u00^gamma);
end