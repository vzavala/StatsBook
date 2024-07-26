% Victor Z
% UW-Madison, 2024
% estimate covariance matrix using Monte Carlo

clc; clear all; close all hidden;

%% generate data (true model is Cp=a0+a1*T+a2*T^2)
% CP in cal/mol-K and T in K
a0=+0.6190e+1;
a1=+0.2923e-2;
a2=-0.7052e-6;
theta=[a0,a1,a2]';

% 3 sets of experiments at T=300K, T=400K, and T=500K
n=10;
N=3*n;
x1=linspace(300,300,n)';
x2=linspace(600,600,n)';
x3=linspace(900,900,n)';
 x=[x1; x2; x3];
    
% generate true outputs 
rng(0);
y1=a0+a1*x1+a2*x1.^2;
y2=a0+a1*x2+a2*x2.^2;
y3=a0+a1*x3+a2*x3.^2;
ytrue=[y1; y2; y3];

% add random noise to true outputs
sigma=0.1;
y=ytrue+normrnd(0,sigma,N,1);



%% solve linear estimation problem and get exact param covariance
xsq=x.^2;
X=[ones(N,1),x,xsq];
Y=y;

% solve estimation problem
thetaest=inv(X'*X)*X'*Y

% get model predictions
Yhat=X*thetaest;

% get residuals
e=Y-Yhat;

% obtain estimate of noise variance
sig2=var(e)

% get exact covariance matrix for parameters
 C=inv(X'*X)*sig2
 

%% obtain exact covariance with Monte Carlo
K=100; % repeat estimation 100 times
for k=1:K

% perturb the output data with random noise   
 yp=y+normrnd(0,sqrt(sig2),N,1);
Y=yp;

% solve estimation problem
th(:,k)=inv(X'*X)*X'*Y

end

% sample covariance
thmean=mean(th')';
Cest=zeros(3,3);
for k=1:K
Cest=Cest+(th(:,k)-thmean)*(th(:,k)-thmean)';
end
Cest=(1/K)*Cest

% compare with exact
C=C
