% Victor Z
% UW-Madison, 2020
% gibbs reactor example

clc; clear all; close all hidden;

% load data
load ('./Data/gibbs_hightemp.dat')
datahigh=gibbs_hightemp;
load ('./Data/gibbs_lowtemp.dat')
datalow=gibbs_lowtemp;

% compare pdf and cdf of pressure
figure(1)
% outcomes
subplot(3,1,1)
plot(datahigh(:,1),'blacko','MarkerFaceColor','w','MarkerSize',4)
xlabel('Outcome $\omega$','Interpreter','latex','FontSize',14)
ylabel('$x_\omega$ [bar]','Interpreter','latex','FontSize',14)
grid on

% compute and plot empirical pdf
dx=10;
lb=0;
ub=0;
t=60:dx:240;
x=datahigh(:,1);
N=length(x);

% compute using indicator
for i=1:length(t) 
    f(i)=0;
    lb(i)=t(i);
    ub(i)=t(i)+dx;
    for j=1:N
        f(i)=f(i)+(x(j)<ub(i) && x(j)>=lb(i));
    end
end

% can also automatically visualize empirical pdf using histogram
subplot(3,1,3)
histogram(datahigh(:,1),'BinWidth',10,'Normalization','count','EdgeColor','black','FaceColor','none','LineWidth',1)
xlabel('$x$ [bar]','Interpreter','latex','FontSize',14)
ylabel('$\textrm{Frequency}$','Interpreter','latex','FontSize',14)
axis([60 240 0 180])
grid on

% compute and plot empirical cdf
t=60:dx:240;

for i=1:length(t) 
    F(i)=0;
    for j=1:length(x)
        F(i)=F(i)+(x(j)<=t(i));
    end
end
subplot(3,1,2)
stairs(t,F,'LineWidth',1,'Color','black')
xlabel('$x$ [bar]','Interpreter','latex','FontSize',14)
ylabel('$\textrm{Cumulative Freq.}$','Interpreter','latex','FontSize',14)
title('')
grid on
print -depsc gibbs_press_pdf_cdf.eps


% get hyperparameters for Gaussian from data
% and compare empirical and theoretical pdf/cdf
param = fitdist(datahigh(:,1),'normal')
x=linspace(50,250);

figure(2)
subplot(2,2,1)
histogram(datahigh(:,1),'BinWidth',10,'Normalization','pdf','EdgeColor','black','FaceColor','none','LineWidth',1)
hold on
plot(x,normpdf(x,param.mu,param.sigma),'black','LineWidth',1.5)
xlabel('$x$ [bar]','Interpreter','latex','FontSize',14)
ylabel('$f(x)$','Interpreter','latex','FontSize',14)
grid on
axis([50 250 0 0.02])

subplot(2,2,2)
stairs(t,F/N,'LineWidth',1,'Color','black')
hold on
plot(x,normcdf(x,param.mu,param.sigma),'black','LineWidth',1.5)
grid on
xlabel('$x$ [bar]','Interpreter','latex','FontSize',14)
ylabel('$F(x)$','Interpreter','latex','FontSize',14)
title('')
axis([50 250 0 1.01])
print -depsc gibbs_press_pdf_cdf_fit.eps


% show convergence of empirical approximations
% as increasing S
figure(3)
dataP=datahigh(:,1);
Sv=5:5:1000;
rng(1); % For reproducibility 
for j=1:length(Sv)
y = datasample(dataP,Sv(j));
e(j) = mean(y);
v(j) = sqrt(var(y));
end
et=linspace(param.mu,param.mu,length(Sv));
vt=linspace(param.sigma,param.sigma,length(Sv));

subplot(3,1,1)
plot(Sv,et,'black-','LineWidth',1.5)
hold on
plot(Sv,e,'blacko','MarkerFaceColor','w','MarkerSize',4)
xlabel('Sample Size ($S$)','Interpreter','latex','FontSize',14)
ylabel('$E[X]$','Interpreter','latex','FontSize',14)
grid on
subplot(3,1,2)
plot(Sv,vt,'black-','LineWidth',1.5)
hold on
plot(Sv,v,'blacko','MarkerFaceColor','w','MarkerSize',4)
xlabel('Sample Size ($S$)','Interpreter','latex','FontSize',14)
ylabel('$SD[X]$','Interpreter','latex','FontSize',14)
grid on
print -depsc gibbs_press_exp_var.eps

% compute sample moments 
m1=moment(dataP,1)
m2=moment(dataP,2)
m3=moment(dataP,3)
m4=moment(dataP,4)
sk=skewness(dataP)
ku=kurtosis(dataP)

% compute empirical quantile function
t=60:5:240;
x=datahigh(:,1);
N=length(x);
for i=1:length(t)
    F(i)=0;
    for j=1:length(x)
        F(i)=F(i)+(x(j)<=t(i))*(1/N);
    end
end

figure(4)
yy1=linspace(0.5,0.5,100);
xx1=linspace(quantile(dataP,0.5),quantile(dataP,0.5));
yy2=linspace(0.9,0.9,100);
xx2=linspace(quantile(dataP,0.9),quantile(dataP,0.9));
xx=linspace(60,240);
yy=linspace(0,1);
stairs(t,F,'LineWidth',1,'Color','black')
hold on
x=linspace(50,250);
plot(x,normcdf(x,param.mu,param.sigma),'black','LineWidth',1.5)
axis([60 240 0 1])
plot(xx,yy1,'black--')
hold on
plot(xx1,yy,'black--')
hold on
plot(xx,yy2,'black--')
hold on
plot(xx2,yy,'black--')
grid on
xlabel('$Q(\alpha)$ [bar]','Interpreter','latex','FontSize',16)
ylabel('$\alpha$','Interpreter','latex','FontSize',16)
set(gca,'FontSize',14)
title('')
print -depsc gibbs_press_quantile.eps


% compare pressure and conversion pdfs at high temperature
figure(5)
subplot(2,2,1)
histogram(datahigh(:,1),'BinWidth',10,'Normalization','count','EdgeColor','black','FaceColor','none','LineWidth',1)
xlabel('$x$ [bar]','Interpreter','latex')
ylabel('$\textrm{Frequency}$','Interpreter','latex','FontSize',14)
grid on
axis([60 240 0 170])

subplot(2,2,2)
histogram(100*datahigh(:,2),'BinWidth',4,'Normalization','count','EdgeColor','black','FaceColor','none','LineWidth',1)
xlabel('$y$ [\%]','Interpreter','latex')
ylabel('$\textrm{Frequency}$','Interpreter','latex','FontSize',14)
grid on
axis([10 90 0 170])

print -depsc gibbs_press_extent.eps


% compare conversion at low and high temperature
figure(6)
subplot(2,2,1)
histogram(100*datahigh(:,2),'BinWidth',4,'Normalization','count','EdgeColor','black','FaceColor','white','LineWidth',1)
hold on
histogram(100*datalow(:,2),'BinWidth',4,'Normalization','count','EdgeColor','black','FaceColor','black','LineWidth',1)
hold on
xlabel('$y$ [\%]','Interpreter','latex','FontSize',14)
ylabel('$\textrm{Frequency}$','Interpreter','latex','FontSize',14)
grid on
legend('High','Low','Location','northwest')

subplot(2,2,2)
t=10:5:100;
F=[];
x=100*datahigh(:,2);
N=length(x);
for i=1:length(t)
    F(i)=0;
    for j=1:length(x)
        F(i)=F(i)+(x(j)<=t(i))*(1/N);
    end
end

stairs(t,F,'LineWidth',1,'Color','black','LineStyle','--')
hold on

t=10:5:100;
x=100*datalow(:,2);
F=[]
N=length(x);
for i=1:length(t)
    F(i)=0;
    for j=1:length(x)
        F(i)=F(i)+(x(j)<=t(i))*(1/N);
    end
end

stairs(t,F,'LineWidth',1,'Color','black','LineStyle','-')
grid on
axis([10 100, 0 1.01])
title('')
xlabel('$y$ [\%]','Interpreter','latex','FontSize',14)
ylabel('${P}(Y\leq y)$','Interpreter','latex','FontSize',14)
title('')
legend('High','Low','Location','northwest')

print -depsc gibbs_extent_temp.eps
