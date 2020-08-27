% Victor Z
% UW-Madison, 2019
% MLE for exponential RV

clc
clear all
close all hidden

% generate observations for weibull
rng(0)
S = 1000;
x = exprnd(2,S,1);

% plot log likelihood 
beta=linspace(0,10,100)
ss=sum(x)
logL=-S*log(beta)-(1./beta)*ss;

% estimate
betahat=mean(x);

figure(1)
subplot(2,2,[1 2])
plot(x,'blacko','MarkerFaceColor','w','MarkerSize',4)
xlabel('$\omega$','Interpreter','latex','FontSize',14)
ylabel('$x_\omega$','Interpreter','latex','FontSize',14)
grid on
subplot(2,2,3)
plot(beta,logL,'black-','LineWidth',1.5)
xlabel('$\beta$','Interpreter','latex','FontSize',14) 
ylabel('$\log L(\beta)$','Interpreter','latex','FontSize',14) 
grid on
axis([0,10,-3e3, -1.6e3])
subplot(2,2,4)
xgrid=linspace(0,10,100)
histogram(x,'BinWidth',1,'Normalization','pdf','EdgeColor','black','FaceColor','none','LineWidth',1)
hold on
plot(xgrid,exppdf(xgrid,betahat),'black-','LineWidth',1.5);
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$f(x)$','Interpreter','latex','FontSize',14)
grid on
print -depsc loglike_exp.eps