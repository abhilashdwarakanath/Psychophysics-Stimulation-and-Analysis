function inverseCLUT = genInvGamma(lut,points)

% Modified after (Frank Schieber, University of South Dakota, schieber@usd.edu June 13, 2007)

%% Calculate fit

lums=lut-lut(1);

normalizedLum=lums./max(lums);

pixels=points(2:end);
normalizedLum=normalizedLum(2:end);

fitType = 2;  %extended power function
outputx = [0:255];
[extendedFit,extendedX]=FitGamma(pixels',normalizedLum',outputx',fitType);

maxLum = max(lut);
luminanceRamp=[0:1/255:1];
pow=extendedX(1);
offset=extendedX(2);
invertedRamp=((maxLum-offset)*(luminanceRamp.^(1/pow)))+offset; %invert gamma w/o rounding
%normalize inverse gamma table
invertedRamp=invertedRamp./max(invertedRamp);
inverseCLUT = repmat(invertedRamp',1,3);

save CALIBRATION.mat inverseCLUT;

%% Plot

figure(1); clf;
set(gcf,'PaperPositionMode','auto');
set(gcf,'Position',[30 140 800 800]);
subplot(2,2,1);
plot(points,lut,'+');
hold on;
xlabel('Pixel Values');
ylabel('Luminance (cd/m2)');
strTitle{1}='Sampled Luminance Function';
strTitle{2}='Phase-1 Linear CLUT';
title(strTitle);
axis([0 256 0 max(lut)]);
axis('square');
hold off;

subplot(2,2,2); hold on;
plot(pixels,normalizedLum,'+'); %sampled luminance
plot(outputx,extendedFit,'r');  %curve fit results
axis([0 256 0 1]);
xlabel('Pixel Values');
ylabel('Normalized Luminance');
strTitle{1}='Power Function Fit to Sampled Luminance Readings';
strTitle{2}=['Exponent = ',num2str(extendedX(1)),'; Offset = ',num2str(extendedX(2))];
title(strTitle);
hold off;

subplot(2,2,3); hold on;
pels=[0:255];
plot(pels,invertedRamp,'r');
axis('square');
axis([0 255 0 1]);
xlabel('Pixel Values');
ylabel('Inverse Gamma Table');
strTitle{1}='Inverse Gamma Table Function';
strTitle{2}=['for Exponent = ',num2str(extendedX(1)),'; Offset = ',num2str(extendedX(2))];
title(strTitle);
hold off;


