function err = hrflse(Params,G,N,C50,data)

% function y = hrf(varargin) takes in input 
%               
%           c = contrast values
%           n = order, i.e. slope
%           c50 = value of contrast at 50% performance
%           gain = contrast gain obtained
%           offset = shift of the performance value as the average of the
%           performance corresponding to the first two contrast values
%           data = data to which the HRF model needs to be fitted
%
% and returns the sum of the least squared errors between individual points. This value
% is then minimised to find best fit parameters
%
% Abhilash Dwarakanath. MPI für Biologische Kybernetik. 2012.

%% Generate the LSE

y = hrf(Params,G,N,C50);

err = sum((y - data).^2, 2);

end