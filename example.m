clear all
%Tx dimensions
n1 = 50; %10 turns on Tx
r01 = 0.25e-3; %Use 0.5mm diameter wire (0.25mm radius)
p1 = 3*r01; %Set the pitch equal to 3 wire radii
r1 = 20e-3; %total coil radius is 20e-3 (diameter 40e-3)

%Rx dimensions, we can make it a little smaller than the Tx
n2 = 50; %7 turns on Rx
r02 = 0.25e-3; %Use 0.5mm diameter wire (0.25mm radius)
p2 = 3*r02; %Set the pitch equal to 3 wire radii
r2 = 10e-3; %total coil radius is 10e-3 (diameter 20e-3)

singlefreq = 87e3;
sourceres = 50e-3;
res = 100; %Set resolution
CP1 = 0;
CP2 = 0;

coil1 = SolWireCoil(n1,r01,p1,r1,singlefreq,CP1,sourceres); %Tx coil
coil2 = SolWireCoil(n2,r02,p2,r2,singlefreq,CP2,sourceres); %Rx coil

M = zeros(1,res);
k = zeros(1,res);
linkgain = zeros(1,res);
Zlink = zeros(1,res);
Zrefl = zeros(1,res);
effout = zeros(1,res);

dists = linspace(1e-3,100e-3,res);
config = 'SS';
Zload = 20;

for a=1:res
    [M(a),k(a)] = mutualIdeal(coil1,coil2,dists(a));
    Zrefl(a) = zrefl(config,coil2.coilZ,M(a),2*pi*singlefreq,Zload,C2);
    [Zlink(a),C1] = zlink(config,coil1.coilZ,coil2.coilZ,M(a),2*pi*singlefreq,Zload,coil1.L,C2,coil2.L);
    linkgain(a) = gain(config,coil1.coilZ,coil2.coilZ,M(a),2*pi*singlefreq,Zload,C1,C2,Zlink(a));
    effout(a)  = linkeff(config,linkgain(a),Zlink(a),Zload);
end

%plot gain against distance

figure
%plot(dists*1e3,rad2deg(angle(linkgain)),'-k')
plot(dists,abs(effout),'-k')
grid on