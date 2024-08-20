% Victor Z
% UW-Madison, 2024
% system identification example
clc; clear all; close all hidden;

% load data
load 'Data/data_sysid_co2.dat';
t = data_sysid_co2(:,1);
u = data_sysid_co2(:,2);
x = data_sysid_co2(:,3);
L = length(t);
T = (t(2)-t(1));

% adjust using reference of 400 ppm
x = x-400;

% get empirical spectrum of u
om = logspace(-3,0,100); % frequency range (rad/s)

for k=1:length(om)
    sum1 = u.*cos(om(k)*t);
   B1(k) = trapz(sum1);
    sum2 = u.*sin(om(k)*t);
   B2(k) = trapz(sum2);   
 magu(k) = sqrt(B1(k)^2 + B2(k)^2); 
end

% get empirical spectrum of x
for k=1:length(om)
    sum1 = x.*cos(om(k)*t);
   A1(k) = trapz(sum1);
    sum2 = x.*sin(om(k)*t);
   A2(k) = trapz(sum2);   
 magx(k) = sqrt(A1(k)^2 + A2(k)^2); 
end

% visualize spectrum
figure(2)
subplot(2,2,1)
semilogx(om,magu,'black-','LineWidth',1.5)
hold on
xlabel('$\omega$ [rad/min]','Interpreter','latex','FontSize',14)
ylabel('$|u(\omega)|$','Interpreter','latex','FontSize',14)
grid on
subplot(2,2,2)
semilogx(om,magx,'black-','LineWidth',1.5)
hold on
xlabel('$\omega$ [rad/min]','Interpreter','latex','FontSize',14)
ylabel('$|x(\omega)|$','Interpreter','latex','FontSize',14)
grid on

% get empirical amplitude ratio
AR = magx./magu;


%% formulate estimation problem
th=[1,1];
thlb=[0,0];
thub=[100,100];
data.AR=AR;
data.om=om;

options = optimoptions(@lsqnonlin,'Display','iter','MaxFunctionEvaluations',5000);
[thhat,~,~,~,~,~,J] = lsqnonlin(@lsfun,th,thlb,thub,options,data);

thhat

%% compare model and empirical spectrum
K=thhat(1);
tau=thhat(2);
ARhat=K./sqrt((tau*om).^2+1);

subplot(2,2,[3 4])
semilogx(om,AR,'o','MarkerFaceColor','w','Color',[0.5 0.5 0.5])
hold on
semilogx(om,ARhat,'black-','LineWidth',1.5)
xlabel('$\omega$ [rad/min]','Interpreter','latex','FontSize',14)
ylabel('$|y(\omega)|$ [rad/min]','Interpreter','latex','FontSize',14)
grid on
legend('Empirical','Model')
print -depsc ch6_sysid_results.eps

% back calculate parameters 
   V = 10000;        %  cf  (building volume)
   Q = V/tau
   G = K*Q

%% verify using Matlab built-in functons

% create data object using x(t),u(t)
 data = iddata(x,u,T);
 
% identify system (fit it to 1st-order system)
sys_estimated = procest(data,'P1') 


%% define residual function
function F=lsfun(th,data)

AR=data.AR;
om=data.om;
K=th(1);
tau=th(2);
ARhat=K./sqrt((tau*om).^2+1);

F=AR-ARhat;

end
 






