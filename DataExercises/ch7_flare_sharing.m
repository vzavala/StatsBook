% Javier Tovar and Victor Z
% UW-Madison, 2024
% flare sizing 

clc; clear all; close all hidden; format short e;

%% design specifications
 Kmax = 3000;         % Maximum allowable radiation BTU/(h*ft^2)
Mamax = 0.7;		  % Maximum allowable Mach number (-)

% design variables 
  diam = 1;	        % Diameter, (ft) (no more than 5 ft)
height = 20;	    % Height of flare stack, (ft) (no more than 150 ft)

%% load input mass flow data (lb/h) 
load ('Data/flow_flare.dat');
M = flow_flare;
S = length(M); 

%% evaluate flare design at different flows 
for i=1:S
[cost,Ma(i),K(i)]=flare_model(diam,height,M(i));
end


%% flare model

function [cost,Ma,K,U]=flare_model(diam,height,M)

%% model parameters
 mw = 46.1;		   % molecular weight of reactant (lb/lbmol)
  t = 760;		   % temperature (°R)
  z = 1;		   % Compressibility factor (-)
 hc = 21500;	   % heat of combustion (btu/lb)
  p = 14.7;		   % absolute pressure (psi)
  w = 29.3;	       % wind velocity (ft/s)
  f = 0.3;	       % fraction of heat radiated (-)
rad = 150;	   	   % distance to flare stack (ft)
 hv = mw*hc/379.5; % heating value (btu/scf)	

%% model equations

 H = M*hc;	    			            % heat liberated (BTU/h)

 L = 10^(0.4507*log10(H)-1.9885);		% flame length (ft)

 Q = (M/3600)*(379.1/mw)*(t/520);	    % gas volume flow (ft3/s)

Ma = 1.702e-5*(M/(p*diam^2))*sqrt(z*t/mw); % Mach number (-)

 U = 4*Q/(pi*diam^2);                   % Flare tip exit velocity (ft/s)

DX = exp(log(L*0.9838) + 0.0754*(log(w/U))); % Flame distortion measure (ft) 

DY = exp(log(L*0.0985) -  0.705*(log(w/U))); % Flame distortion measure (ft) 

Hr = height + 0.5*DY;      % Height of flame (ft)

Rr = rad - 0.5*DX;         % Reference radius (ft)

D = sqrt(Rr^2+Hr^2);       % Distance from the reference point to flame (ft) 

K = f*H/(D^2*4*pi);        % Radiation, (BTU/(h*ft^2)) 

cost = (94.3+11.05*(diam*12)+0.906*height)^2; % (USD)

end
