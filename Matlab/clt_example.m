% Victor Z
% UW-Madison, 2020
% simulating the central limit theorem

clc; clear all; close all hidden; 

rng(0);
N=1000;  % number of samples

figure(1)
subplot(2,2,1)
xgrid=linspace(0,10,1000);
plot(xgrid,wblpdf(xgrid,2,1),'black','LineWidth',1.5)
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$f(x)$','Interpreter','latex','FontSize',14)
grid on

S=10; % sample size
for j=1:N
x = wblrnd(2,1,S,1);
m(j) = mean(x);
end

subplot(2,2,2)
histogram(m,'Normalization','count','EdgeColor','black','FaceColor','none','LineWidth',1)
xlabel('$\bar{x}$','Interpreter','latex','FontSize',14)
ylabel('$f(\bar{x})$','Interpreter','latex','FontSize',14)
grid on
axis([0 4 0 150])

S=100;  % number of samples
for j=1:N
x = wblrnd(2,1,S,1);
m(j) = mean(x);
end
subplot(2,2,3)
histogram(m,'Normalization','count','EdgeColor','black','FaceColor','none','LineWidth',1)
xlabel('$\bar{x}$','Interpreter','latex','FontSize',14)
ylabel('$f(\bar{x})$','Interpreter','latex','FontSize',14)
grid on
axis([0 4 0 150])

S=1000;  % number of samples
for j=1:N
x = wblrnd(2,1,S,1);
m(j) = mean(x);
end

v=wblstat(2,1)
pd = fitdist(m','Normal')

subplot(2,2,4)
histogram(m,'Normalization','count','EdgeColor','black','FaceColor','none','LineWidth',1)
xlabel('$\bar{x}$','Interpreter','latex','FontSize',14)
ylabel('$f(\bar{x})$','Interpreter','latex','FontSize',14)
grid on
axis([0 4 0 150])

print -depsc clt_weibull.eps