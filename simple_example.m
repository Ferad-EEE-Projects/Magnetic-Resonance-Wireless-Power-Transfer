%Simple example, shows use of SolWireCoil step by step, this isn't the
%optimum method for design, but should show relevant process steps in
%detail that's easy to follow

%Instantiate some fairly arbitrary Tx and Rx coils

%Tx dimensions

n1 = 5; %10 turns on Tx
r01 = 0.25e-3; %Use 0.5mm diameter wire (0.25mm radius)
p1 = 3*r01; %Set the pitch equal to 3 wire radii
r1 = 20e-3; %total coil radius is 20e-3 (diameter 40e-3)

%Rx dimensions, we can make it a little smaller than the Tx

n2 = 7; %7 turns on Rx
r02 = 0.25e-3; %Use 0.5mm diameter wire (0.25mm radius)
p2 = 3*r02; %Set the pitch equal to 3 wire radii
r2 = 10e-3; %total coil radius is 10e-3 (diameter 20e-3)

%We can assume that we are unsure about the best frequency to drive the
%coils at, so can specify them with a sweep

res = 100; %Set resolution

%sweep from 1MHz to 30MHz
freq = linspace(1e6,30e6,res);

%Since Tx and Rx have more than 3 turns, it's fairly safe to let the
%constructor method guess the SRF, therefore we should set the CP vars to 0

CP1 = 0;
CP2 = 0;

%We should also assume a small source resistance, most likely dominated by
%the primary switch in the Tx, it's less important for the Rx, but should
%be considered anyway, to account for losses inherent in the construction.

%Use some typical example values for now
sourceres1 = 50e-3;
sourceres2 = 50e-3;

%Instantiate the coils

coil1 = SolWireCoil(n1,r01,p1,r1,freq,CP1,sourceres1); %Tx coil
coil2 = SolWireCoil(n2,r02,p2,r2,freq,CP2,sourceres2); %Rx coil

%Now we can plot the two coil Q profiles against frequency

figure
plot(freq/1e6,coil1.Q,'-k')
hold on
grid on
plot(freq/1e6,coil2.Q,'--r')
hold off

%The plot shows that the Q-factor of the Tx peaks at ~15MHz, and starts
%dropping at higher frequencies; this limits operation of the link to
%<15MHz.

%Can choose fixed frequency operation at 13.56MHz in this case. So should
%reinstantiate the coil objects with a single frequency value.

singlefreq = 13.56e6;

coil1 = SolWireCoil(n1,r01,p1,r1,singlefreq,CP1,sourceres1); %Tx coil
coil2 = SolWireCoil(n2,r02,p2,r2,singlefreq,CP2,sourceres2); %Rx coil

%now we can characterize the link over a range of distances.

dists = linspace(1e-3,100e-3,res);

M = zeros(1,res);
k = zeros(1,res);
linkgain = zeros(1,res);
Zlink = zeros(1,res);
Zrefl = zeros(1,res);

%For now assume an SP config with a 2kOhm load (fairly arbitrary)

config = 'SP';
Zload = 2e3;


%Crude approx to offset parasitics, can subtract from nominal resonant
%capacitance.

C1 = coil1.C-coil1.CP;
C2 = coil2.C-coil2.CP;

%Calculate mutual inductance, link impedance, and link gain.

for a=1:res
    [M(a),k(a)] = mutualIdeal(coil1,coil2,dists(a));
    Zrefl(a) = zrefl(config,coil2.coilZ,M(a),2*pi*singlefreq,Zload,C2);
    Zlink(a) = zlink(config,coil1.coilZ,coil2.coilZ,M(a),2*pi*singlefreq,Zload,C1,C2);
    linkgain(a) = gain(config,coil1.coilZ,coil2.coilZ,M(a),2*pi*singlefreq,Zload,C1,C2,Zlink(a));
end

%plot gain against distance

figure
%plot(dists*1e3,rad2deg(angle(linkgain)),'-k')
plot(dists*1e3,abs(linkgain),'-k')
grid on

%Plot shows the characteristic bell shape, with gain maximized at kcrit (bear in
%mind the loaded Q of the secondary).
