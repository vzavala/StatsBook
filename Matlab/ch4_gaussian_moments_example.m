% Victor Z
% UW-Madison, 2022
% Gaussian moment example

clc; clear all; close all hidden;

%% try few data points
S=10;

% generate data using true model
mu=1
sig=2
rng(1);
X=normrnd(mu,sig,S,1);

% use data to infer parameters using moment mathching
muhat=mean(X)
sighat=std(X)


% compare truth against estima
subplot(2,2,1)
histogram(X,'BinWidth',0.5,'Normalization','pdf','EdgeColor','black','FaceColor','none','LineWidth',1)
hold on
x=linspace(-10,10,100);
plot(x,normpdf(x,mu,sig),'color','black','LineWidth',1.5)
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$f(x)$','Interpreter','latex','FontSize',14)
grid on

% compute and plot empirical cdf 
subplot(2,2,2)
[F,t]=ecdf(X);
stairs(t,F,'LineWidth',1,'Color','black')
hold on
plot(x,normcdf(x,mu,sig),'color','black','LineWidth',1.5)
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$F(x)$','Interpreter','latex','FontSize',14)
title('')
grid on

%% try more data
S=100;
rng(1);
X=normrnd(mu,sig,S,1);

% use data to infer parameters using moment mathching
muhat=mean(X)
sighat=std(X)

% compare truth against estima
subplot(2,2,3)
histogram(X,'BinWidth',0.5,'Normalization','pdf','EdgeColor','black','FaceColor','none','LineWidth',1)
hold on
plot(x,normpdf(x,mu,sig),'color','black','LineWidth',1.5)
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$f(x)$','Interpreter','latex','FontSize',14)
grid on

% compute and plot empirical cdf 
subplot(2,2,4)
[F,t]=ecdf(X);
stairs(t,F,'LineWidth',1,'Color','black')
hold on
plot(x,normcdf(x,mu,sig),'color','black','LineWidth',1.5)
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$F(x)$','Interpreter','latex','FontSize',14)
title('')
grid on

print -depsc ch4_gaussian_moments_example.eps