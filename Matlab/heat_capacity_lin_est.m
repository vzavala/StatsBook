% Victor Z
% UW-Madison, 2020
% linear regression for heat capacity
% see https://www.mathworks.com/help/stats/understanding-linear-regression-outputs.html

clc; clear all; close all hidden;

% generate data (true model is Cp=a0+a1*T+a2*T^2)
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

%%%%% Visualize data

 figure(1)
 scatter(x,y,'blacko','MarkerFaceColor','w','LineWidth',1)
 hold on
 scatter(x,ytrue,'blacko','MarkerFaceColor','black','LineWidth',1)
 xlabel('$T\; [K]$','Interpreter','latex','FontSize',16)
 ylabel('$\textrm{Heat Capacity [cal/mol-K]}$','Interpreter','latex','FontSize',16)
 grid on
 set(gca,'FontSize',16)
 axis([290 910 6.6 8.5])
 print -depsc heat_capacity_data.eps

% construct input and output data matrix for MLE
xsq=x.^2;
X=[ones(N,1),x,xsq];
Y=y;

% assume noise variance is not known and obtain best fit parameters
% by solving SSE minimization problem
thetaest=inv(X'*X)*X'*Y

% confirm that this minimizer is unique
eigs(X'*X)

% get model predictions
Yhat=X*thetaest;

% get residuals
e=Y-Yhat;

% visualize fit
figure(2)
subplot(2,2,1)
xx=linspace(6.5,8.5);
plot(Y,Yhat,'blacko','MarkerFaceColor','w')
hold on
plot(ytrue,Yhat,'blacko','MarkerFaceColor','black')
plot(xx,xx,'black')
grid on
xlabel('$y$','Interpreter','latex','FontSize',14)
ylabel('$\hat{y}$','Interpreter','latex','FontSize',14)
axis([6.5 8.5 6.5 8.5])

pd = fitdist(e,'Normal')
subplot(2,2,2)
histogram(e,'BinWidth',0.1,'Normalization','pdf','EdgeColor','black','FaceColor','none','LineWidth',1)
hold on
xx=linspace(-0.75,0.75);
plot(xx,normpdf(xx,pd.mu,pd.sigma),'black-','LineWidth',1.5)
axis([-0.75 0.75 0 4])
grid on
xlabel('$\epsilon$','Interpreter','latex','FontSize',14)
ylabel('$f(\epsilon)$','Interpreter','latex','FontSize',14)
print -depsc heat_capacity_fit.eps

% assume variance of error is from output measurement
sig2=var(e)
sigest=sqrt(sig2)

% get covariance matrix for parameters
 C=inv(X'*X)*sig2
 
% determine Fisher information matrix
 I=inv(C)
 
% get R2
Ybar=mean(Y)
Sm=norm(Yhat-Ybar)^2
Se=norm(Y-Yhat)^2
Sy=norm(Y-Ybar)^2

R2=Sm/Sy
 
% try matlab built-in functions
X = [x xsq];
Y = y;
lm = fitlm(X,Y,'linear')




