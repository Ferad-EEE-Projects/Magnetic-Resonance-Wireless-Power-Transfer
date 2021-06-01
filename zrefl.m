function [ zreflval ] = zrefl(config,ZL2,M,omega,Zout,C2)
%ZREFL Returns the value of the reflected impedance Zrefl
%   Detailed explanation goes here



switch config
    case 'SS'
        %
        zreflval = ((omega.*M).^2)./(ZL2 + 1./(1j*omega*C2) + Zout);
    case 'SP'
        %
        zreflval = ((omega.*M).^2)./(ZL2 + 1./((1j*omega*C2) + 1./Zout));

%%%%%% SEC
    case 'PS'
        %
        zreflval = ((omega.*M).^2)./(ZL2 + 1./(1j*omega*C2) + Zout);
    case 'PP'
        %
        zreflval = ((omega.*M).^2)./(ZL2 + 1./((1j*omega*C2) + 1./Zout));
    otherwise
        fprintf('invalid config, must be SS, SP, PS, or PP\n');
end

end

