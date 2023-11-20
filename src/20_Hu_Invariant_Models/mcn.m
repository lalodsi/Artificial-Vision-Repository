function npq = mcn(f,p,q)
    m00 = momento_inicial(f,0,0);
    m10 = momento_inicial(f,1,0);
    m01 = momento_inicial(f,0,1);

    Xc = m10/m00;
    Yc = m01/m00;

    u00 = momento_central(f,0,0,Xc,Yc);
    upq = momento_central(f,p,q,Xc,Yc);

    gamma = ((p+q)/2)+1;
    npq = upq/(u00^gamma);
end