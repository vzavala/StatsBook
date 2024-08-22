% Victor Z
% UW-Madison, 2020
% implementation of gibbs reactor equilibrium model

clc; clear all; close all hidden;

% simulate reactor to obtain conversion
T=300;   % temperature (degC)
P=200;   % pressure (bar)
xi0=0.5; % initial guess for conversion
options = optimoptions('fsolve','Display','none');

xi = fsolve(@gibbsfun,xi0,options,P,T)

% reactor model
function f=gibbsfun(x,P,T)

% define equilibrium constant at T 
T=T+273.15;
Keq=10^(-12.275+4938/T);

% gibbs equilibrium condition
muinCO=100;
muinH2=600;
muinCH3OH=0;

% conversion is unknown variable
xi=x(1);

% compute output flows
muCO=muinCO-muinCO*xi;
muH2=muinH2-2*muinCO*xi;
muCH3OH=muinCH3OH+muinCO*xi;
mutot=muCO+muH2+muCH3OH;
    
% state equation to solve
num = muCH3OH/mutot;
den1 = muCO/mutot;
den2 = muH2*muH2/(mutot*mutot);

f(1) = num/(den1*den2) - (P^2)*Keq;

end
