function [ gainval ] = gain(config,ZL1,ZL2,M,omega,Zout,C1,C2,Zlink)
%GAIN determines gain based on input params
%   config should be a string, either SS, SP, PS, PP. Other params are self
%   explanatory

switch config
    case 'SS'
        %
        gainval = (-1j.*omega.*M.*Zout)./(Zlink.*(ZL2 + 1./(1j.*omega.*C2) + Zout));
    case 'SP'
        %
        gainval = (-1j.*omega.*M)./(Zlink.*(ZL2.*(1j*omega*C2+1./Zout)+1));
    case 'PS'
        %
        Zrefl = zrefl('PS',ZL2,M,omega,Zout,C2);
        gainval = (-1j.*omega.*M.*Zout.*Zlink)./((ZL1+Zrefl).*(ZL2+1./(1j.*omega.*C2)+Zout));
    case 'PP'
        %
        Zrefl = zrefl('PP',ZL2,M,omega,Zout,C2);
        gainval = (-1j.*omega.*M.*Zlink)./((ZL1+Zrefl).*((1j*omega*C2+1./Zout)+1));
    otherwise
        fprintf('invalid config, must be SS, SP, PS, or PP\n');
end


end

