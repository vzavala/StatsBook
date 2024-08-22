% Jiaze Ma and Victor Z
% UW-Madison, 2024
% plastic pyrolysis kinetic model
clc; clear all; close all hidden;

% kinetic model info
    R = 8.314; % Gas constant in J/(mol*K)
    A = [1.16E+07, 1.52E+07, 7.20E+06, 7.10E+06, 8.70E+06, 1.31E+07];  % pre-exponential factors
    E = [109, 105, 190, 105, 130, 120] * 1000;                         % activation energies
  beta = 10;                   % heating rate [oC/min] - in the range of 5-20 
    Y0 = [1.0, 0.0, 0.0, 0.0]; % initial concentration (Plastic, Wax, Liquid, Gas)
   tf = 60;                    % batch time [min] - in the range of 10-100 

% simulate reactor model 
  time = linspace(0, tf, 100); 
  [T, Y] = ode45(@(t,Y) model(t, Y, A, E, beta, R), time, Y0);
    
% store the solutions in a table
solutions = table(T, Y(:,1), Y(:,2), Y(:,3), Y(:,4), 'VariableNames', {'Time', 'P', 'W', 'L', 'G'});
solutions.beta = repmat(beta, height(solutions), 1);   

% visualize reactor profiles 
 title off; 
 plot(solutions.Time, solutions.P,'black-','LineWidth',1)
 hold on; 
 grid on;
 plot(solutions.Time, solutions.W,'blackx-','LineWidth',1)
 plot(solutions.Time, solutions.L,'blacko-','LineWidth',1)
 plot(solutions.Time, solutions.G,'blackd-','LineWidth',1)
 legend('Plastic','Wax','Liquid','Gas','Location','NorthWest')
 xlabel('$\textrm{Time}$ [min]','Interpreter','latex','FontSize',14)
 ylabel('$\textrm{Concentration}$ [-]','Interpreter','latex','FontSize',14)
 axis([0,tf,0,max(max(Y))])

% kinetic model 
function dYdt = model(t, Y, A, E, beta, R)

    P = Y(1);
    W = Y(2);
    L = Y(3);
    G = Y(4);
    T = beta * t + 298.15; % heating process starting at 25 oC, convert to Kelvin
    
    dPdt = -A(1) * exp(-E(1) / (R * T)) * P - A(2) * exp(-E(2) / (R * T)) * P - A(3) * exp(-E(3) / (R * T)) * P;
    dWdt =  A(1) * exp(-E(1) / (R * T)) * P - A(4) * exp(-E(4) / (R * T)) * W - A(6) * exp(-E(6) / (R * T)) * W;
    dLdt =  A(2) * exp(-E(2) / (R * T)) * P + A(4) * exp(-E(4) / (R * T)) * W - A(5) * exp(-E(5) / (R * T)) * L;
    dGdt =  A(3) * exp(-E(3) / (R * T)) * P + A(6) * exp(-E(6) / (R * T)) * W + A(5) * exp(-E(5) / (R * T)) * L;
    dYdt = [dPdt; dWdt; dLdt; dGdt];

end


