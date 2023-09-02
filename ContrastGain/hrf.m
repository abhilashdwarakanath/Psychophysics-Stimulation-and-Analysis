function y = hrf(Params,gain,n,c50)

% function y = hrf(varargin) takes in input 
%               
%           c = contrast values
%           n = order, i.e. slope
%           c50 = value of contrast at 50% performance
%           gain = contrast gain obtained
%           offset = shift of the performance value as the average of the
%           performance corresponding to the first two contrast values
%
% Abhilash Dwarakanath. MPI für Biologische Kybernetik. 2012.

%% Define parameters and model

y = ((gain.*(Params.C.^n))./(Params.C.^n + c50^n))+Params.offset; % The hyperbolic ration function for contrast gain

end