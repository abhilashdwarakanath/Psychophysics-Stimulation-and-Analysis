function [LSE] = lse(starting,data,x)

        b0 = starting(1);
        t0 = starting(2);
        
        y = psychWeibull(b0,t0,x);
        errVec = y - data;
        LSE = sum(errVec.^2);

end