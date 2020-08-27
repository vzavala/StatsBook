% Victor Z
% UW-Madison, 2020
% covariance and correlation matrix for gibbs reactor

clc; clear all; close all hidden;
format bank;

% data order (pressure, conversion, flow co, flow h2, flow ch3oh)
load('./Data/gibbs_covariance.dat')
data=gibbs_covariance;

% perturb data with noise
rng(1); % For reproducibility 
data(:,1)=data(:,1)+normrnd(0,10,250,1);
data(:,2)=data(:,2)+normrnd(0,0.1,250,1);
data(:,3)=data(:,3)+normrnd(0,10,250,1);
data(:,4)=data(:,4)+normrnd(0,10,250,1);
data(:,5)=data(:,5)+normrnd(0,10,250,1);

% get mean
m=mean(data)'

% get variance
v=var(data)'

% get std dev
s= sqrt(v)

% get covariance matrix
C=cov(data)

% get correlation matrix
R=corrcov(C)

% get eigenvalues of covariance matrix
lambda=eigs(C)

figure(1)
subplot(2,2,1)
plot(data(:,1),data(:,2),'blacko','MarkerFacecolor','w')
xlabel('\textrm{Pressure [bar]}','Interpreter','latex','FontSize',14)
ylabel('\textrm{Conversion [-]}','Interpreter','latex','FontSize',14)
grid on
subplot(2,2,2)
plot(data(:,1),data(:,3),'blacko','MarkerFacecolor','w')
xlabel('\textrm{Pressure [bar]}','Interpreter','latex','FontSize',14)
ylabel('\textrm{Flow CO [mol/s]}','Interpreter','latex','FontSize',14)
grid on
subplot(2,2,3)
plot(data(:,3),data(:,4),'blacko','MarkerFacecolor','w')
ylabel('\textrm{Flow $H{}_2$ [mol/s]}','Interpreter','latex','FontSize',14)
xlabel('\textrm{Flow $CO$ [mol/s]}','Interpreter','latex','FontSize',14)
grid on
subplot(2,2,4)
plot(data(:,4),data(:,5),'blacko','MarkerFacecolor','w')
ylabel('\textrm{Flow $CH_3OH$ [mol/s]}','Interpreter','latex','FontSize',14)
xlabel('\textrm{Flow $H_2$ [mol/s]}','Interpreter','latex','FontSize',14)
grid on
print -depsc correlation_gibbs.eps

%% re-scale variables

% get mean
m=mean(data)'

% get variance
v=var(data)'

% get std dev
s= sqrt(v)

% scale 
for i=1:5
   data(:,i)=(data(:,i)-m(i))/s(i); 
end

% get covariance matrix
CC=cov(data)

% get correlation matrix
R=corrcov(CC)

% get eigenvalues of covariance matrix
lambda=eigs(CC)

%% compute conditional density 

% reorder matrix 

Cr=C([2 1 3 4 5],[2 1 3 4 5])
mr=m([2 1 3 4 5])

% compute quantities
Sig11=Cr(1,1)
Sig22=Cr(2:5,2:5)
mu2=mr(2:5)
mu1=mr(1)
Sig12=Cr(2:5,1)
Sig21=Sig12;
x2p=mr(2:5);

%XI|X2
mu1g2=mu1+Sig12'*inv(Sig22)*(x2p-mu2)
Sig1g2=Sig11-Sig12'*inv(Sig22)*Sig21
