function [original]=cosramp(original, l_ramp, Fs, varargin);
%%%%%%%%%%%%%%%%----------COSRAMP.M-----"the only ramp function you'll need!"
% cosramp(original signal, length of ramp in secs., Fs, where left in secs., where right in secs.)
%
% This function will cosine ramp the beginning and the end of a sound only
% if the first three arguments are input.
% ***If the 'where' arguments are included only those points will be ramped!!!!
%
% For example if 'where left'=0.5, then there will be 
% a descending ramp from (0.5 -> length ramp)
% If there is no 'where right' then the ascending ramp will start at 0.5 sec.
%
% If on the other hand there is a 'where right' then the ascending ramp will start from there.
%
% Note:
% OMIT 'where(s)' if only ramping the beginning and the end of a sound!!!!!
% OMIT 'where right' if only want to ramp that particular spot
% 
% Created by CPetkov    11/00
%
% See also: RAMP, RAMP_MORE, RAMP_MORE_NOUI (for linear ramps).
x=round(Fs*l_ramp);
z=0:(1/x):1;
ramp=(-0.5*cos(pi*z))+0.5;
l_r=length(ramp);

l_s=length(original);

if nargin > 3 %if we have the 'where' arguments proceed
   error(nargchk(1,5,nargin)) %error message if not
   where=varargin{1};
   where=round(Fs*where);
   if nargin > 4 %ramp right side at a different place
   	where2=varargin{2};
      where2=round(Fs*where2);
      original(1,where2:(where2+(l_r-1)))=original(1,where2:(where2+(l_r-1))).*ramp;
   end
   %ramp left side
   original(1,(where-(l_r-1)):where)=original(1,(where-(l_r-1)):where).*(fliplr(ramp));
   %ramp right side at same place as left side
   if nargin < 5
   original(1,where:(where+(l_r-1)))=original(1,where:(where+(l_r-1))).*ramp;   
	end   
else %if no 'where' arguments ramp the beginning and end of signal
   original(1,1:(l_r))=original(1,1:(l_r)).*(ramp);
   original(1,(l_s-(l_r-1)):(l_s))=original(1,(l_s-(l_r-1)):(l_s)).*(fliplr(ramp));
end

%lines used for testing...
%g=sawcompile(.5,2,1000,2000,50000);% for testing
%p=cosramp(g,0.010,50000);