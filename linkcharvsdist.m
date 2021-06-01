function [M,k,gainout,effout,zlinkout,zreflout,effmax] = linkcharvsdist(coil1,coil2,linkparam)
%LINKCHARVSDIST Gives key link characteristics vs distance
%   dists can be a vector, everything else should be single values. C1 and
%   C2 are included as options to allow resonance tweaking if desired.

%config = linkparam.config;
config = linkparam.config;
omega = 2*pi*coil1.f;
Zout = linkparam.load;
dists = linkparam.dists;

M = zeros(1,length(dists));
k = zeros(1,length(dists));
gainout = zeros(1,length(dists));
effout = zeros(1,length(dists));
zlinkout = zeros(1,length(dists));
zreflout = zeros(1,length(dists));

if contains(config,'SS')
    coil1.C = coil1.C;
else
    coil1.C = zeros(1,length(dists));
end

for a=1:length(dists)
    [M(a),k(a)] = mutualIdeal(coil1,coil2,dists(a));
    switch config
        case 'SS'
            coil1.C = (1./(omega.*sqrt(coil1.L))).^2;
        otherwise
            [coil1.C(a)] = resonantcap (coil1.L, coil2.L, omega,M(a),linkparam);
    end
end

for a=1:length(dists)
    switch config
        case 'SS'
            zlinkout(a) = zlink(config,coil1.ZL,omega,coil1.C,M(a),coil2.ZL,coil2.C,Zout);
            zreflout(a) = zrefl(config,coil2.ZL,M(a),omega,Zout,coil2.C);
            gainout(a) = gain(config,coil1.ZL,coil2.ZL,M(a),omega,Zout,coil1.C,coil2.C,zlinkout(a));
            effout(a) = linkeff(config,gainout(a),zlinkout(a),Zout);
        otherwise
            zlinkout(a) = zlink(config,coil1.ZL,omega,coil1.C(a),M(a),coil2.ZL,coil2.C,Zout);
            zreflout(a) = zrefl(config,coil2.ZL,M(a),omega,Zout,coil2.C);
            gainout(a) = gain(config,coil1.ZL,coil2.ZL,M(a),omega,Zout,coil1.C(a),coil2.C,zlinkout(a));
            effout(a) = linkeff(config,gainout(a),zlinkout(a),Zout);
    end
   % effmax = etamax(k,coil1.Q,coil2.Q);
end
end

