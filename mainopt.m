clear;clc;
global fcount;
%config = 'SP';   % configuration

nvars = 18;
%IntCon = [12 16];

lb = [1e-6,1e-6,20e-3,0,0,30e3, 1e-6,1e-6,20e-3,0,0, 0.1e-3,0.1e-3,0.1e-3, 0.1e-3,0.1e-3,0.1e-3, 10];
ub = [50e-5,50e-5,20e-2,0,0,150e3, 50e-5,50e-5,20e-2,0,0, 3e-3,3e-3,3e-3, 3e-3,3e-3,3e-3,  200,];

%TX varargin (C,L,Rs,Cf,Lf,f,coilgeom);
%coil=struct ('n',,'r0',,'p',,'r',,);
%Zload from 10 to 200

%{
opts = gaoptimset('Generations',200,'PopulationSize',200, ...
                      'PlotFcns',@gaplotbestf);
opts.FitnessLimit = -100;              
rng default % For reproducibility
[x,fval] = ga(@objfun,nvars,[],[],[],[],lb,ub,@confun,opts);
%}

opts1 = optimoptions('particleswarm','SwarmSize',600,'HybridFcn',@fmincon,'MaxIterations',2000,'PlotFcns',@pswplotbestf);
rng default % For reproducibility
[xopt,fval] = particleswarm(@objfun,nvars,lb,ub,opts1);

display(xopt);
display(fval);
display(fcount);