

function [C1] = resonantcap (L1,L2,omega,M,linkparam)

Zout = linkparam.load;
config = linkparam.config;

 switch config
    %case 'SS'
        %
    %    C1 = (1./(omega.*sqrt(coil1.L))).^2;

    case 'SP'
        %
        C1 = (1./(L1 - ((M.^2)/L2)).*omega.^2);

    case 'PS'
        %
        C1 = L1./(((((omega.*M).^2)/Zout)^2) + (omega^2).*(L1^2));

    case 'PP'
        %
        C1 = (L1-((M.^2)/L2))./((((M.*sqrt(...
        	Zout))./L2).^2)+((omega.^2)*(L1-((M.^2)./L2))));
    
    otherwise
        fprintf('invalid config, must be SS, SP, PS, or PP\n');
	end

	ZC1 = 1./(omega.*C1);
    coil1.ZC = ZC1;
	%coil1.C = C1;
	
end
