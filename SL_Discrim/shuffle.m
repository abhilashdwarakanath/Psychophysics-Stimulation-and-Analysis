function [xout,i]=shuffle(x,dim)
% shuffle: randomly shuffle a set of elements
% usage: xout=shuffle(x);
% or: [xout,ind]=shuffle(x);
% or: xout=shuffle(x,dim);
% or: [xout,ind]=shuffle(x);
%
% arguments:
% x (nxm) - any vector or matrix to be shuffled by row or column
% dim (optional scalar) - dimension along which to shuffle
%
% xout (nxm) - shuffled vector or matrix
% ind (optional vector) - index vector which relates x to xout by:
% xout = x(ind,:) if dim==1 and ndims==2
% xout = x(:,ind,:) if dim==2 and ndims==3, etc.

% author: N. Cahill
% email: cahill@kodak.com
% date: 1/29/98

% check inputs
if nargin==0, help shuffle; return; end

% get number of dimensions of x
nd=ndims(x);

% get size of each dimension of x
s=size(x);

% see if dim is specified, if not, set to first non-singleton dimension
if nargin<2
  nsing=find(s~=1);
  if isempty(nsing)
    dim=1;
  else
    dim=nsing(1);
  end
end

% check dim to see if it is valid
if dim<1|dim>nd
  error('dim is invalid');
end

% set up random index
i=randperm(s(dim))';

% now write xout
xout=zeros(size(x));

% set up string to eval
str=blanks(2*nd-1);
str(1:2:2*nd-1)=':';
str(2:2:2*nd-1)=',';
str(2*dim-1)='i';

% now perform eval
eval(['xout=x(',str,');']);