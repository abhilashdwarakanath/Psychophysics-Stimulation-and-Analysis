function [GABOR] = local_make_Gabor(IMGSIZE,IMG_BGND,G_FREQ,G_BAND,G_ORI,G_CONTR)

[X,Y] =meshgrid([-IMGSIZE(2)/2+1:IMGSIZE(2)/2],[-IMGSIZE(1)/2+1:IMGSIZE(1)/2]);
Fimg = G_FREQ/IMGSIZE(1);
Xb = X;
X = X*sin(G_ORI)-Y*cos(G_ORI);
Y = Xb*cos(G_ORI)+Y*sin(G_ORI);
MASK = exp( -(X.^2 + Y.^2) / (2*G_BAND^2)).^2;
MASK(find(MASK(:)<0.02)) = 0;
Wave = real(exp(i*(2*pi*Fimg*X)));
ind = find(MASK(:)>0.02);
Wave = Wave /std(Wave(ind)) * G_CONTR/100 * IMG_BGND;
GABOR = MASK.*Wave + IMG_BGND;



