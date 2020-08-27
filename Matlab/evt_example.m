% Victor Z
% UW-Madison, 2020
% simulating the extreme value theorem

clc; clear all;  close all hidden; 

rng(0)
N=1000;  % number of samples

figure(1)
subplot(2,2,1)
xgrid=linspace(2-5,2+7,1000);
plot(xgrid,normpdf(xgrid,2,1),'black','LineWidth',1.5)
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$f(x)$','Interpreter','latex','FontSize',14)
grid on
axis([-3 7 0 0.5])

S=10; % sample size
for j=1:N
x = normrnd(2,1,S,1);
m(j) = max(x);
end

subplot(2,2,2)
histogram(m,'Normalization','pdf','EdgeColor','black','FaceColor','none','LineWidth',1)
xlabel('$x_{max}$','Interpreter','latex','FontSize',14)
ylabel('$f(x_{max})$','Interpreter','latex','FontSize',14)
grid on
axis([2 7 0 1.5])

S=100;  % number of samples
for j=1:N
x = normrnd(2,1,S,1);
m(j) = max(x);
end
subplot(2,2,3)
histogram(m,'Normalization','pdf','EdgeColor','black','FaceColor','none','LineWidth',1)
xlabel('$x_{max}$','Interpreter','latex','FontSize',14)
ylabel('$f(x_{max})$','Interpreter','latex','FontSize',14)
grid on
axis([2 7 0 1.5])

S=1000;  % number of samples
for j=1:N
x = normrnd(2,1,S,1);
m(j) = max(x);
end
pd = fitdist(m','GeneralizedExtremeValue')
xx=linspace(0,7);

subplot(2,2,4)
histogram(m,'Normalization','pdf','EdgeColor','black','FaceColor','none','LineWidth',1)
hold on
plot(xx,gevpdf(xx,pd.k,pd.sigma,pd.mu),'black','LineWidth',1.5)
xlabel('$x_{max}$','Interpreter','latex','FontSize',14)
ylabel('$f(x_{max})$','Interpreter','latex','FontSize',14)
grid on
axis([2 7 0 1.5])

print -depsc evt_weibull.eps

% determine probability P(X>5)
P=1-gevcdf(5,pd.k,pd.sigma,pd.mu)

% determine probability P(X>7)
P=1-gevcdf(7,pd.k,pd.sigma,pd.mu)
