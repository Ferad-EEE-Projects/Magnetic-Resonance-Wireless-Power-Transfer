function [M,k] = mutualIdeal(coil1,coil2,dist)
    
    mu0 = (4*pi)*1e-7;
    
    
    %determine distance from centre of coil1 turn 1 to centre of coil2 turn 1
    d121 = coil1.p*(coil1.n-1) + dist + coil1.r0 + coil2.r0;
    
    %create distance array for distances between each turn of each coil
    dists = zeros(coil1.n,coil2.n);
    
    %fill dists array
    for a=1:coil1.n
        for b=1:coil2.n
            dists(a,b) = d121 + (coil2.p*(b-1) - coil1.p*(a-1));
        end
    end
    
    %determining kconst and M here makes the assumption that the radii in
    %the coils are identical (i.e. coils are solenoids) a modified method
    %is needed for pancakes and multi-layer solenoids
    
    
    kconst = sqrt((4*coil1.r.*coil2.r)./(((coil1.r + coil2.r).^2) + dists.^2));
    [K,E] = ellipke(kconst.^2);

    M = sum(sum(mu0*sqrt(coil1.r*coil2.r).*((2./kconst -kconst).*K - (2./kconst).*E)));
    k = M./sqrt(coil1.L*coil2.L);

end