% Victor Z
% UW-Madison, 2023
% Weibull moment example

clc; clear all; close all hidden;

%% try few data points
S=10;

% generate data using true model
beta=1 %(scale)
xi=2 %(shape)
rng(1);
X=wblrnd(beta,xi,S,1);

% estimates of moments
Ehat=mean(X)
Vhat=var(X)

% solve moment matching equations numerically
p0=[1,1];
opt = optimoptions('fsolve','Display','iter');
p = fsolve(@myfun,p0,opt,X);

% estimated parameters
betahat=p(1)
xihat=p(2)

% compare truth against estima
subplot(2,2,1)
histogram(X,'BinWidth',0.5,'Normalization','pdf','EdgeColor','black','FaceColor','none','LineWidth',1)
hold on
x=linspace(0,5,100);
plot(x,wblpdf(x,betahat,xihat),'color','black','LineWidth',1.5)
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$f(x)$','Interpreter','latex','FontSize',14)
grid on
axis([0 5 0 1])

% compute and plot empirical cdf 
subplot(2,2,2)
[F,t]=ecdf(X);
stairs(t,F,'LineWidth',1,'Color','black')
hold on
plot(x,wblcdf(x,betahat,xihat),'color','black','LineWidth',1.5)
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$F(x)$','Interpreter','latex','FontSize',14)
title('')
grid on

%% try more data points
S=100;
rng(1);

% generate data using true model
beta=1 %(scale)
xi=2 %(shape)
X=wblrnd(beta,xi,S,1);

% estimates of moments
Ehat=mean(X)
Vhat=var(X)

% solve moment matching equations numerically
p0=[1,1];
opt = optimoptions('fsolve','Display','iter');
p = fsolve(@myfun,p0,opt,X)

% estimated parameters
betahat=p(1)
xihat=p(2)

% compare truth against estima
subplot(2,2,3)
histogram(X,'BinWidth',0.5,'Normalization','pdf','EdgeColor','black','FaceColor','none','LineWidth',1)
hold on
x=linspace(0,5,100);
plot(x,wblpdf(x,betahat,xihat),'color','black','LineWidth',1.5)
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$f(x)$','Interpreter','latex','FontSize',14)
grid on
axis([0 5 0 1])

% compute and plot empirical cdf 
subplot(2,2,4)
[F,t]=ecdf(X);
stairs(t,F,'LineWidth',1,'Color','black')
hold on
plot(x,wblcdf(x,betahat,xihat),'color','black','LineWidth',1.5)
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$F(x)$','Interpreter','latex','FontSize',14)
title('')
grid on

print -depsc ch4_weibull_moments_example.eps


function err=myfun(param,X)
% compute empirical estimates
Ehat=mean(X);
Vhat=var(X);

% get theoretical mean and std
beta=param(1);
xi=param(2);
[E,V]=wblstat(beta,xi);

% mismatch error
err(1)=E-Ehat;
err(2)=V-Vhat;
err=err';
end


