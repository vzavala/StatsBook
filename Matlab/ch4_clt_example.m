% Victor Z
% UW-Madison, 2020
% simulating the central limit theorem (clt)

clc; clear all; close all hidden; format short e;

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

%% estimate variance of sample estimate using batching
mb=mean(m);
vestS=(1/N)*sum((m-mb).^2)
vest=vestS*S

%% real mean and variance of RV
[mm,vv]=wblstat(2,1)

%% obtain mean and variance from Gaussian fit
pd = fitdist(m','Normal')
v2s=pd.sigma^2
v2=v2s*S

subplot(2,2,4)
histogram(m,'Normalization','count','EdgeColor','black','FaceColor','none','LineWidth',1)
xlabel('$\bar{x}$','Interpreter','latex','FontSize',14)
ylabel('$f(\bar{x})$','Interpreter','latex','FontSize',14)
grid on
axis([0 4 0 150])

print -depsc ch4_clt_weibull.eps