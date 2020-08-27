% Victor Z
% UW-Madison, 2020
% example log normal RV in pharam products

clc; clear all; close all hidden;

% generate data
mu=log(200)
logq=log(400)
alpha=0.9;
sigma=(logq-mu)/(sqrt(2)*erfinv(2*alpha-1))
x=linspace(10,1000,1000);
expF=[0.1 0.5 0.9];
expx=[95 200 411];

figure(1)

% visualize cdf
subplot(2,1,1)
semilogx(x,logncdf(x,mu,sigma),'black-','LineWidth',1.5)
hold on
scatter(expx,expF,'blacko','MarkerFaceColor','white','MarkerEdgeColor','black') 
hold on
grid on
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$F(x)$','Interpreter','latex','FontSize',14)
lgd=legend('Theoretical','Experimental Data','Location','northwest');
lgd.FontSize = 10;
title('')

% visualize pdf
subplot(2,1,2)
semilogx(x,lognpdf(x,mu,sigma),'black-','LineWidth',1.5)
hold on
grid on
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$f(x)$','Interpreter','latex','FontSize',14)
title('')
print -depsc lognormalpsd.eps

% compute probability that 250<X<400

P=logncdf(400,mu,sigma)-logncdf(250,mu,sigma)