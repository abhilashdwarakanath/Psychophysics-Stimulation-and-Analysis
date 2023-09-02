x1m=(1:5)-.1;
x1s=(1:5)+.1;

for tt=1:3
  
   
   xm=params(:,tt);
   xs=params(:,tt+3);
   
   um=confint{tt}(:,2);
   us=confint{tt+3}(:,2);
   
   lm=confint{tt}(:,1);
   ls=confint{tt+3}(:,1);
   
    figure
    hold on
    errorbar(x1m, xm', abs(xm'-lm'), abs(xm'-um'), '.k')
    errorbar(x1s', xs', abs(xs'-ls'), abs(xs'-us'), '.r')
    set(gca,'YScale','log')
   
end