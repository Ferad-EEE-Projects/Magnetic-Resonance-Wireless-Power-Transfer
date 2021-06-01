clc; clear all;

coilgeom1 = struct ('n',50,'r0',0.25e-3,'p',3*0.25e-3,'r',20e-3);
coilgeom2 = struct ('n',30,'r0',0.25e-3,'p',3*0.25e-3,'r',20e-3);

f = 1e3;
coil1 = coilparam (0,0,0,0,0,coilgeom1.n,coilgeom1,f); %TX varargin: (C,L,Rs,Cf,Lf,coilgeom,f)
coil2 = coilparam (0,0,0,0,0,coilgeom2.n,coilgeom2,f); %RX

res = 100; %Set resolution
config = 'SS'; % Alternate to SP,PS,PP,SLCC,LCCS etc
linkparam = struct ('dists',linspace(10e-3,300e-3,res)...
			,'lat',0,'config',config,'load',10);

[M,k,gainout,effout,zlinkout,zreflout] = linkcharvsdist(coil1,coil2,linkparam);

figure (1)
plot(linkparam.dists,effout)
ylabel('Efficiency');
yyaxis right
plot (linkparam.dists,gainout,'r--')
set(gca,'YScale','log')

title(['Efficiency and Gain for ',config], 'FontSize', 12) % Alternate to SP,PS,PP,SLCC,LCCS etc
xlabel('distance(m)');
ylabel('Gain');
legend('Efficiency','Gain')


% Parameters Needed
% Mutual (n,dist,r0,p,r) or mutualIdeal(coil1,coil2,dists(a));
% gain (config,ZL1,ZL2,M,omega,Zout,C1,C2,Zlink,Zrefl)
% Efficiency (config,linkgain,Zlink,Zout)
% zlink (config,coil1.coilZ,coil2.coilZ,M(a),2*pi*freq,Zout,C1,C2);
% zrefl(config,coil2.coilZ,M(a),2*pi*freq,Zout,C2)
% maxEff (k,coil1.Q,coil2.Q);