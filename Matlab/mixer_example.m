% Victor Z
% UW-Madison, 2020
% mixer example
clc; clear all; close all hidden;

% generate data for three flows
rng(0)
N=100;
time=0:1:N-1;
F1 = normrnd(100,100*0.01/2.5,N,1);
F2 = normrnd(50,50*0.01/2.5,N,1);
F3 = normrnd(150,150*0.01/2.5,N,1);

% compute conservation error
err = F3-F2-F1;

% visualize flows
figure(1)
subplot(3,1,1)
plot(time,100*1.01*ones(N),'black--')
hold on
plot(time,100*0.99*ones(N),'black--')
plot(time,F1,'blacko','MarkerFaceColor','w')
ylabel('$f_1(\omega)$','Interpreter','latex','FontSize',14)
grid on
axis([0 N 98 102])
subplot(3,1,2)
plot(time,50*1.01*ones(N),'black--')
hold on
plot(time,50*0.99*ones(N),'black--')
plot(time,F2,'blacko','MarkerFaceColor','w')
ylabel('$f_2(\omega)$','Interpreter','latex','FontSize',14)
grid on
axis([0 N 48 52])
subplot(3,1,3)
plot(time,150*1.01*ones(N),'black--')
hold on
plot(time,150*0.99*ones(N),'black--')
plot(time,F3,'blacko','MarkerFaceColor','w')
xlabel('Observation ($\omega$)','Interpreter','latex','FontSize',14)
ylabel('$f_3(\omega)$','Interpreter','latex','FontSize',14)
grid on
axis([0 N 148 152])
print -depsc mixer_flows.eps

% visualize conservation error
figure(2)
subplot(2,1,1)
plot(time,0*ones(N),'black--')
hold on
plot(time, err,'blacko','MarkerFaceColor','w')
grid on
xlabel('Observation ($\omega$)','Interpreter','latex','FontSize',14)
ylabel('$\epsilon(\omega)$','Interpreter','latex','FontSize',14)
print -depsc mixer_flows_error.eps