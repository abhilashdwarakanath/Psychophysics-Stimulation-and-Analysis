function out = shifmat(m,nPixel,dir); 

% function out = shifmat(m,nPixel,dir); 
% verschiebt die Matrix um n Pixel in richtung dir.
% dir: 1 links 2 rechts 3 unten 4 oben

out = zeros(size(m));
sm = size(m);

switch dir
  case 1
    out(:,1:(sm(2)-nPixel)) = m(:,(1+nPixel):sm(2));
    out(:,(sm(2)-nPixel+1):sm(2)) = m(:,1:nPixel);
  case 2
    nPixel = sm(2) - nPixel;
    out(:,1:(sm(2)-nPixel)) = m(:,(1+nPixel):sm(2));
    out(:,(sm(2)-nPixel+1):sm(2)) = m(:,1:nPixel);
  case 3
    nPixel = sm(1)-nPixel;
    out([1:(sm(1)-nPixel)],:)   = m([(1+nPixel):sm(1)],:);
    out((sm(1)-nPixel+1):sm(1),:) = m(1:nPixel,:);
  case 4
    out([1:(sm(1)-nPixel)],:)   = m([(1+nPixel):sm(1)],:);
    out((sm(1)-nPixel+1):sm(1),:) = m(1:nPixel,:);
    
end











