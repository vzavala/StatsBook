% Victor Z
% UW-Madison, 2019
% pdf and cdf of a simple continuous RV

clc; clear all; close all hidden;

rng(1); % For reproducibility 
mu=0;
sigma=1;
color="black";
x=linspace(-5,5,1000);

figure(1)

% plot pdf
subplot(2,2,1)
plot(x,normpdf(x,mu,sigma),color,'LineWidth',1.5)
hold on
grid on
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$f(x)$','Interpreter','latex','FontSize',14)
title('')
axis([-5 5 0 0.42])

% plot cdf
subplot(2,2,2)
for k=1:length(mu)
plot(x,normcdf(x,mu(k),sigma(k)),color(k),'LineWidth',1.5)
hold on
end
grid on
xlabel('$t$','Interpreter','latex')
ylabel('$F(t)$','Interpreter','latex')
title('')
axis([-5 5 -0.01 1.01])

% plot discrete approximation of pdf
N=1000;
x = normrnd(0,1,N,1);
subplot(2,2,1)
histogram(x,'BinWidth',1/2,'Normalization','pdf','EdgeColor','black','FaceColor','none','LineWidth',1)
xlabel('$x$ [bar]','Interpreter','latex')
ylabel('$S\times {P}(X=x)$','Interpreter','latex')
grid on
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$f(x)$','Interpreter','latex','FontSize',14)
axis([-5 5 0 0.42])

t=-5:0.5:5;
for i=1:length(t)
    F(i)=0;
    for j=1:length(x)
        F(i)=F(i)+(x(j)<=t(i))*(1/N);
    end
end

% plot discrete approximation of cdf
subplot(2,2,2)
stairs(t,F,'LineWidth',1,'Color','black')
xlabel('$x$','Interpreter','latex')
ylabel('$F(x)$','Interpreter','latex')
grid on
title('')
axis([-5 5 -0.01 1.01])

print -depsc pdfcdfcontinuous.eps
