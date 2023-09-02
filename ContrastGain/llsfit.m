function llsMin = llsfit(Params,B,T,data,x)

y = psychWeibull(Params.a,B,T,x);
y = y*.999+.001;
llsMin = -sum(data.*log(y) + (1-data).*log(1-y));

end