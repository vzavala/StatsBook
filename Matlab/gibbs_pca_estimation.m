% Victor Z
% UW-Madison, 2020
% PCA estimation for Gibbs reactor

clc; clear all; close all hidden;
format short e 

%% generate dataset
% get data (pressure, conversion, flow co, flow h2, flow ch3oh)
load ('./Data/gibbs_covariance.dat')
datat=gibbs_covariance;
% get temperature data
load ('./Data/gibbs_lowtemp_class.dat')
datan=gibbs_lowtemp_class;
% join data (pressure, conversion, flow co, flow h2, flow ch3oh, temperature)
data=[datat datan(:,1)];

% perturb data with noise
rng(1); % For reproducibility 
[S,n]=size(data);
data(:,2)=data(:,2)+normrnd(0,0.05,S,1);

% construct input-outdata matrices
Y=data(:,2);
X=data(:,[1 3 4 5 6]);
[S,n]=size(X);
% join data (ones, pressure, flow co, flow h2, flow ch3oh, temperature)
X=[ones(S,1) X]; % add ones to introduce bias parameter
[S,n]=size(X);

%% apply standard estimation

theta=(X'*X)\(X'*Y)
Yhat=X*theta;
e=Yhat-Y;
SSE=mean(e.^2)
sig2=var(e);
Covtheta=sig2*inv(X'*X)
diag(Covtheta)
lamk=eigs(X'*X)

% compare predictions and observations
figure(1)
subplot(2,2,1)
xx=linspace(0,1);
plot(Y,Yhat,'blacko','MarkerFaceColor','w')
hold on
plot(xx,xx,'black')
grid on
xlabel('$y$','Interpreter','latex','FontSize',14)
ylabel('$\hat{y}$','Interpreter','latex','FontSize',14)
axis([0.2 1 0.2 1])

%% now apply PCA estimation

% form kernel matrix and compute eigenvectors and eigenvalues
Sigma=X'*X;
[W,lam]=eigs(Sigma);
lam=diag(lam)

% eliminate small eigenvalues
n1=3;
W1=W(:,1:n1);
L1=diag(lam(1:n1));

% project input data
T1=X*W1;

% estimate parameters
gamma=inv(T1'*T1)*T1'*Y
thetan=W1*gamma
Yhatn=X*thetan;
en=Yhatn-Y;
SSE=mean(en.^2)
sig2=var(en);
Covthetan=sig2*(W1*inv(L1)*W1')
diag(Covthetan)'

% compare predictions and observations
figure(1)
subplot(2,2,2)
xx=linspace(0,1);
plot(Y,Yhatn,'blacko','MarkerFaceColor','w')
hold on
plot(xx,xx,'black')
grid on
xlabel('$y$','Interpreter','latex','FontSize',14)
ylabel('$\hat{y}$','Interpreter','latex','FontSize',14)
axis([0.2 1 0.2 1])

print -depsc gibbs_pca_fit.eps



