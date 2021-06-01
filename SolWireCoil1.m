classdef SolWireCoil
    %   SolWireCoil Class to contain necessary data and functions for a single layer wire solenoid coil
    %   The properties include geometric properties (diameters, fill
    %   factor, spacings etc) as well as derived/electromagnetic properties
    %   (inductance, series resistance, Q factor). These properties are
    %   generated on instantiation of the coil by the constructor.
    
    properties
        %Geometric properties
        l; %length
        n; %numturns
        p; %pitch
        r0;%wireradius
        r; %coilradius
        %Derived properties
        L;
        Rs;
        Q;
        C;
        %Frequency
        f;
        %Predicted quarterwave SRF based on geometry
        fSRF;
        %Predicted (or supplied) CP based on SRF, and Z based on everything
        CP;
        coilZ;
    end

    methods
          %Constructor
        function coilobj = SolWireCoil(n,r0,p,r,f,CP,sourceres)

            coilobj.n = n;
            coilobj.r0 = r0;

            if(p<(2*r0))
                %fprintf('pitch too small, setting to minimum (approx 2xr0)\n');
                %coilobj.p = 2*r0;
                coilobj.p = 2*r0/(sqrt(1-(2*r0/(pi*2*r)).^2));
                %Exact minimum pitch formula taken from g3ynh's solenoid
                %document.
            else
                coilobj.p = p;
            end
            coilobj.r = r;
            coilobj.f = f;

            %Now complete geometry
            coilobj.l = 2*r0+(coilobj.p*(n-1));   

            %Now generate derived values
            
            %Free space permeability
            mu0 = (4*pi)*1e-7;
            %Use current sheet inductance with Weaver's continuous Nag
            %coefficient calculation method. This way the L should be valid
            %regardless of D/l
            
            %coefficients
            zk = (2/pi)*(coilobj.l./(2*r));
            k0 = 2.30038;
            k2 = 1.76356;
            k1 = 3.437;
            w1 = -0.47;            
            w2 = 0.755;
            v = 1.44;
            nagK = zk.*(log(1 + 1./zk) + 1./(k0 + k1*(coilobj.l./(2*r)) + k2*(coilobj.l./(2*r)).^2 + w1./((abs(w2) + (2*r)./coilobj.l).^v)));
            
            coilobj.L = (mu0*pi*(r.^2).*(n.^2).*nagK)./coilobj.l;            

        end
    end
end





            

