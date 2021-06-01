function coilgeom = coilgeom(varargin)

	% coil geometrical param = coilgeom(varargin)
	% coilparam(n,r0,p,r) %4params
	% no input means default assumed

switch nargin
		case 0
			disp ('no inputs given (defaults assumed)')
			coilobj.n = 5; 			% turns on Tx/RX
			coilobj.r0 = 0.25e-3;	% radius (mm)
			coilobj.p = 3*r02;		% pitch; set to 3*wire radii
			coilobj.r = 10e-3;		% total coil radius (mm)

		case 1
			disp ('1 input given: no of turns')
			coilobj.n = varargin(1); % turns on Tx/RX
			coilobj.r0 = 0.25e-3;	% radius (mm)
			coilobj.p = 3*r02;		% pitch; set to 3*wire radii
			coilobj.r = 10e-3;		% total coil radius (mm)

		case 2
			disp ('2 inputs given: n,r0')
			coilobj.n = varargin(1); % turns on Tx/RX
			coilobj.r0 = varargin(2); % radius (mm)
			coilobj.p = 3*r02;		% pitch; set to 3*wire radii
			coilobj.r = 10e-3;		% total coil radius (mm)

		case 3
			disp ('3 inputs given: n,r0,p')
			coilobj.n = varargin(1); 	% turns on Tx/RX
			coilobj.r0 = varargin(2); 	% radius (mm)
			coilobj.p = varargin(3);  	% pitch; set to 3*wire radii
			coilobj.r = 10e-3;		% total coil radius (mm)

		case 4
			disp ('4 inputs given: n,r0,p,r')
			coilobj.n = varargin(1); 	% turns on Tx/RX
			coilobj.r0 = varargin(2); 	% radius (mm)
			coilobj.p = varargin(3);  	% pitch; set to 3*wire radii
			coilobj.r = varargin(4);	% total coil radius (mm)

		otherwise
			error ('insufficient coilparameter input')
		end
