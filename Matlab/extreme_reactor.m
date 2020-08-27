% Victor Z
% UW-Madison, 2019
% extreme value pressures

clc; clear all; close all hidden;

% visualize data

x=0.5:1:19.5
w=[2.75,7.8,11.6,13.79,14.20,13.15,11.14,8.72,6.34,4.30,2.73,1.62,...
    0.91,0.48,0.24,0.11,0.05,0.02,0.01,0.001]/100;
xx=linspace(0,19);

% hyperparameters weibull pdf

scale=6; % m/s
shape=2;

figure(1)
subplot(2,2,1)
bar(x,w,'EdgeColor','black','FaceColor','none','LineWidth',0.5)
hold on
plot(xx,wblpdf(xx,scale,shape),'black','LineWidth',1.5)
xlabel('$x\; \textrm{[m/s]}$','Interpreter','latex','FontSize',14)
ylabel('$f(x)$','Interpreter','latex','FontSize',14)
grid on
subplot(2,2,2)
plot(xx,wblcdf(xx,scale,shape),'black','LineWidth',1.5)
grid on
xlabel('$x\; \textrm{[m/s]}$','Interpreter','latex','FontSize',14)
ylabel('$F(x)$','Interpreter','latex','FontSize',14)
grid on
print -depsc windspeed.eps


