clc
clear all


f = @(x1,x2) (1/(1*10))*exp(-x1./1 -x2./10);

integral2(f,1,inf,1,inf)


t1=1
t2=1
F=(1-exp(-t1/1))*(1-exp(-t2/10))