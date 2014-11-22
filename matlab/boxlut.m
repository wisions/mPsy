function out = boxlut(c,Lbg,Lmin,Lmax,gamma,BTRR)
    if nargin < 6, BTRR = 63.2; end
    Lc = (1+c).*Lbg;
    U = 255.0*((Lc-Lmin)/(Lmax-Lmin)).^(1/gamma);
    b1 = (BTRR+1)./BTRR;
    b = min(floor(U*b1),255);
    out = [round((U-b./b1).*(BTRR+1)), 0, round(b)]/255.0;
