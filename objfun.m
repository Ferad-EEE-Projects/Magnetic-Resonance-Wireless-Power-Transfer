function f = objfun (x)

global fcount
fcount = fcount+1;

C1 = x(1);
L1 = x(2);
Rs1 = x(3);
Cf1 = x(4);
Lf1 = x(5);
f = x(6);

C2 = x(7);
L2 = x(8);
Rs2 = x(9);
Cf2 = x(10);
Lf2 = x(11);

n1 = 30;
r01 = x(12);
p1 = x(13);
r1 = x(14);

n2 = 30;
r02 = x(15);
p2 = x(16);
r2 = x(17);

Zout = x(18);
dists = 400e-3;
omega = 2*pi*f;

coilgeom1 = struct ('n',n1,'r0',r01,'p',p1,'r',r1);
coilgeom2 = struct ('n',n2,'r0',r02,'p',p2,'r',r2);

%coil1 = coilparam (C1,L1,Rs1,Cf1,Lf1,n1,coilgeom1,f); %TX varargin: (C,L,Rs,Cf,Lf,coilgeom,f)
%coil2 = coilparam (C2,L2,Rs2,Cf2,Lf2,n2,coilgeom2,f);

res = 100; %Set resolution
config = 'SS'; % Alternate to SP,PS,PP,SLCC,LCCS etc

%%
[M,k] = mutualIdeal1(p1,n1,n2,dist,r01,r02,L1,L2); %to find the maximum distance is the minimum M
Zlink = zlink(config,coil1.ZL,omega,coil1.C,M,coil2.ZL,coil2.C,Zout);
Zrefl = zrefl(config,coil2.ZL,M,omega,Zout,coil2.C);
vgain = gain(config,coil1.ZL,coil2.ZL,M,omega,Zout,coil1.C,coil2.C,Zlink);
% 
efflink = linkeff(config,vgain,Zlink,Zout);
f = -efflink;