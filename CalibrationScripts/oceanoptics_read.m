function [lambda,values]=oceanoptics_read(filename,unit,therange);
% function [lambda,values]=read_oceanoptics(filename,unit,therange);
% e.g. :
%  [lambda,values]=read_oceanoptics(filename,1,[360 830]);
% abartels 22.07.2004
% 
% read output spectra from Ocean optics Spectrometer
% e.g. blabla.Master.Sample, or blabla.Master.Irradiance
% file has 19 headerlines, followed by wavlength intensity value pairs.
% therange: e.g. [360 830] nanometers
% unit: e.g. : 1 (nanometers)
% see oceanoptics_read.m, oceanoptics_gamma.m and oceanoptics_howto. img_gammaLUT.m
try
	[lambda,values]=textread(filename,'%f%f','headerlines',19,'delimiter','>>>>>End Spectral Data<<<<<'); % OObase32 .irradiance file
catch
	[lambda,values]=textread(filename,'%f%f','headerlines',19,'delimiter','DATA');	% OOiirrad2beta .ird file
end;
thei=find(lambda==0);
lambda(thei)=[]; % delete 0s.
values(thei)=[]; % delete 0s.

% limit wavelength-entries to range and interpolate to unit:
lambda2=interp1(lambda,lambda,[therange(1):unit:therange(2)]);
values=interp1(lambda,values,[therange(1):unit:therange(2)]);
lambda=lambda2;
return;