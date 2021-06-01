classdef coilparam
    
    properties
        %Geometric properties
        l; %length
        n; %numturns
        p; %pitch
        r0;%wireradius
        r; %coilradius
        %Derived properties
        L; Lf;
        C; Cf;
        ZC; ZL; ZCf; ZLf;
        Rs;
        Q;
        %Frequency
        f;
        omega;
        %Predicted quarterwave SRF based on geometry
        fSRF;
        %Predicted (or supplied) CP based on SRF, and Z based on everything
        CP;
        coilgeom;
    end
    
    methods
        function coilobj = coilparam(C,Cf,L,Lf,Rs,n,coilgeom,f)
            
            coilobj.n = n;
            coilobj.r0 = coilgeom.r0;
            coilobj.p = coilgeom.p;
            coilobj.r = coilgeom.r;
            
            if(f==0)
                f = 85e3;
            else
                coilobj.f = f;
            end
            coilobj.omega =  2*pi*f;
            
            if(C==0)
                coilobj.C = 0.01e-5;
            else
                coilobj.C = C;
            end
            coilobj.ZC = 1/(coilobj.omega*coilobj.C);
            
            if(L==0)
                coilobj.L = 0.01e-5;
            else
                coilobj.L = L;
            end
            coilobj.ZL = (coilobj.omega*coilobj.L);
            
            
            if(Cf==0)
                coilobj.Cf = 0;
            else
                coilobj.Cf = Cf;
            end
            coilobj.ZCf = 1/(coilobj.omega*coilobj.Cf);
            
            
            if(Lf==0)
                coilobj.Lf = 0;
            else
                coilobj.Lf = Lf;
            end
            coilobj.ZLf = (coilobj.omega*coilobj.Lf);
            
            if(Rs==0)
                coilobj.Rs = 50e-3;
            else
                coil.Rs = Rs;
            end
            coilobj.Q = (coilobj.omega.*coilobj.L)./(coilobj.Rs);
            
        end
    end
end