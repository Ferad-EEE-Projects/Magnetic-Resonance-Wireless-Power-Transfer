function [ zlinkval ] = zlink (config,ZL1,omega,C1,M,ZL2,C2,Zout)

%ZLINK determines Zlink based on input params
%   config should be a string, either SS, SP, PS, PP. Other params are self
%   explanatory

%{
C1 = coil1.C;
C2 = coil2.C;
L1 = coil1.L;
L2 = coil2.L;
ZL1 = coil1.ZL;
ZL2 = coil1.ZL;
omega = coil1.omega;
Zout = linkparam.load;
config = linkparam.config;
%}

switch config
    case 'SS'
        zlinkval = ZL1 + 1./(1j.*omega.*C1) + ((omega.*M).^2)./(ZL2 + 1./(1j.*omega.*C2) + Zout);
    case 'SP'
        %
       % C1 = (1./(L1 - ((M^2)/L2))*omega^2);
        zlinkval = ZL1 + 1./(1j*omega.*C1) + ((omega.*M).^2)./(ZL2 + 1./((1j*omega*C2) + 1./Zout));
    case 'PS'
        %
       % C1 = L1./(((((omega.*M)^2)/Zout)^2) + (omega^2).*(L1^2));
        zlinkval = 1./(1j.*omega.*C1 + 1./(ZL1 + ((omega.*M).^2)./(ZL2 + 1./(1j*omega*C2) + Zout)));
    case 'PP'
        %
        %C1 = (L1-((M^2)/L2))/((((M.*sqrt(Zout))./L2)^2)+((omega^2)*(L1-((M^2)/L2))));
        zlinkval = 1./(1j.*omega.*C1 + 1./(ZL1 + ((omega.*M).^2)./(ZL2 + 1./((1j*omega*C2) + 1./Zout))));
    otherwise
        fprintf('invalid config, must be SS, SP, PS, or PP\n');        
    end

end

