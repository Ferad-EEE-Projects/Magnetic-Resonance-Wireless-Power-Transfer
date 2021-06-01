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
            %NOTE: sourceres is a minimum resistance supplied by the user,
            %that should be based on the source resistance for the Tx coil,
            %or tracks connecting to the load for the Rx coil. A typical
            %value for standard PCB traces could be something in the region
            %of 0.01 Ohms, for 1oz copper traces to and from the coil in
            %the region of 10 squares in size. For otherwise very high Q
            %coils, this can dominate the loss and should be included.
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
            
            %Resistivity
            %resist = 16.8e-9;
            
            %wire length formula
            wirelen = 2*pi*r.*n;
            
            %DC res
            %Rdc = (resist*wirelen)/(pi.*(r0.^2));
            
            %Taking skin and prox effect into account
            
            Hmpair = zeros(1,n);
            Hmasy = zeros(1,n);
            %First work out Hmasy
            for m=1:n
                if m==(n/2+0.5)
                    %Full symmetry, no fields
                    Hmasy(m)=0;
                elseif m<(n/2)
                    %'Left' block
                    for k=2*m:n
                        Hmasy(m) = Hmasy(m) + (1/(2*pi)).*((coilobj.p.*abs(m-k))./(coilobj.p.^2*abs(m-k).^2+r0.^2));
                    end
                elseif (m>(n/2) && m<n)
                    %'Right' block
                    for k=1:(2*m-n-1)
                        Hmasy(m) = Hmasy(m) + (1/(2*pi)).*((coilobj.p.*abs(m-k))./(coilobj.p.^2*abs(m-k).^2+r0.^2));
                    end
                elseif m==n
                    %Final case
                    for k=1:(n-1)
                        Hmasy(m) = Hmasy(m) + (1/(2*pi)).*((coilobj.p.*abs(m-k))./(coilobj.p.^2.*abs(m-k).^2+r0.^2));
                    end
                end
            end

            %Next work out Hmpair in a similar way
            for m=1:n
                if m==1
                    Hmpair(m) = 0;
                elseif m==n
                    Hmpair(m) = 0;
                elseif m<=(n/2)
                    for i=1:m-1
                        Hmpair(m) = Hmpair(m) + (1/(2*pi))*((2*r0)./(coilobj.p.^2*(m-i).^2-r0.^2));
                    end
                elseif m>(n/2)
                    for i=(2*m-n):m-1
                        Hmpair(m) = Hmpair(m) + (1/(2*pi)).*((2.*r0)./(coilobj.p.^2*(m-i).^2-r0.^2));
                    end
                end
            end
            
            Hm = Hmpair + Hmasy;
            sigma = 58.5e6; %Conductivity of Cu = 58.5e6 S/m
            delta = 1./((pi.*f*mu0*sigma).^(1/2));
            x = 2*r0./delta;
            
            KimRDC = 1./(pi.*r0.^2.*sigma); %RDC per unit length
            KimRloss = (KimRDC./(16*x)).*((2.*x+1).^2 + 2 + ((8*pi.^2*delta.^2.*x.^3.*(x-1))./(n)).*sum(Hm.^2));

            %KimRskin = KimRDC.*(1/4 + r0./(2*delta) + (3/32)*(delta./r0));
            %Rsskin = KimRskin.*wirelen;
            
            
            Rsfull = KimRloss.*wirelen + sourceres;
            
            
            
            coilobj.Rs = Rsfull;
            
            %Q factor
            omega = 2*pi*f;
            coilobj.Q = (omega.*coilobj.L)./(Rsfull);
            %lg = -4*coilobj.n*(-dout+coilobj.n*(s+w)+w)-w;
            %Cp = (0.9*1 + 0.1*4.4)*8.85e-12*(thk/s)*lg;
            %coilobj.Q = (omega*coilobj.L - omega*(coilobj.Rs^2 + omega^2*coilobj.L^2)*Cp)/coilobj.Rs;
            
            
            
            %ResCap
            coilobj.C = (1./(omega.*sqrt(coilobj.L))).^2;
            
            coilobj.fSRF = (((300/(4*wirelen*(1+0.225*2*r/coilobj.l)))^0.8)/((((2*r)^2)/(73*coilobj.p))^0.2))*1e6;
            %if CP is not provided, generate CP from predicted SRF,
            %otherwise override with user-supplied value, and override SRF
            %based on user-supplied CP
            if(~CP)
                coilobj.CP = (1./(2*pi*coilobj.fSRF.*sqrt(coilobj.L)))^2;
            else
                coilobj.CP = CP;
                coilobj.fSRF = 1/(2*pi*sqrt(coilobj.L*coilobj.CP));
            end
            coilobj.coilZ = 1./(1./(1j*omega*coilobj.L + Rsfull) + 1j*omega*coilobj.CP);
            coilobj.Q = imag(coilobj.coilZ)./real(coilobj.coilZ);
        end
    end
    
end

