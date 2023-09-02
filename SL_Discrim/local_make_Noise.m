function [NOISE] = local_make_Noise(IMGSIZE,IMG_BGND,G_BAND,G_CONTR)

[X,Y] =meshgrid([-IMGSIZE(2)/2+1:IMGSIZE(2)/2],[-IMGSIZE(1)/2+1:IMGSIZE(1)/2]);
MASK = exp( -(X.^2 + Y.^2) / (2*G_BAND^2)).^2;
MASK(find(MASK(:)<0.02)) = 0;
MASK(MASK>0) = 1;
%Wave = 0+(255-0).*rand(1200,1600);
Wave = randn(IMGSIZE(1),IMGSIZE(2));
ind = find(MASK(:)>0.02);
Wave = Wave /std(Wave(ind)) * G_CONTR/100 * IMG_BGND;
NOISE = MASK.*Wave + IMG_BGND;
