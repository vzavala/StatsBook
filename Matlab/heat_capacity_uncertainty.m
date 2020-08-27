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
theta=[a0,a1,a2]'

% 3 sets of experiments at T=300K, T=600K, and T=900K
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

% construct input and output data matrix for MLE
xsq=x.^2;
X=[ones(N,1),x,xsq];
Y=y;

% obtain best fit parameters
thetaest=inv(X'*X)*X'*Y;
Yhat=X*thetaest;
e=Y-Yhat;
pd = fitdist(e,'Normal')
sig2=(pd.sigma)^2;
C=inv(X'*X)*sig2;

% visualize 1-2 pair
Sigma=C(1:2,1:2);
mu= [0,0];

% compute the 95% confidence interval ellipse
alpha = 0.95; % confidence 
n = 2; % dimension of variable
A = inv(Sigma); % inverse covariance
b = chi2inv(alpha, n); % confidence level on 2d from chi2 distribution
[xe, ye, major, minor, bbox] = ellipse(A, b, 100, mu); % ellipse

% plot the ellipse
figure(1);
subplot(3,3,1)
plot(xe,ye,'black') % plot the ellipse
hold on
plot(0,0,'black+')
grid on
hold on
xlabel('$\Delta \theta_0$','Interpreter','latex','FontSize',16)
ylabel('$\Delta \theta_1$','Interpreter','latex','FontSize',16)

% visualize 2-3 pair
Sigma=C(2:3,2:3);
mu= [0,0];

% compute the 95% confidence interval ellipse
alpha = 0.95; % confidence 
n = 2; % dimension of variable
A = inv(Sigma); % inverse covariance
b = chi2inv(alpha, n); % confidence level on 2d from chi2 distribution
[xe, ye, major, minor, bbox] = ellipse(A, b, 100, mu); % ellipse

% plot the ellipse
figure(1);
subplot(3,3,2)
plot(xe,ye,'black') % plot the ellipse
hold on
plot(0,0,'black+')
grid on
hold on
xlabel('$\Delta \theta_1$','Interpreter','latex','FontSize',16)
ylabel('$\Delta \theta_2$','Interpreter','latex','FontSize',16)

% visualize 1-3 pair
Sigma=C([1,3],[1,3]);
mu= [0;0];

% compute the 95% confidence interval ellipse
alpha = 0.95; % confidence 
n = 2; % dimension of variable
A = inv(Sigma); % inverse covariance
b = chi2inv(alpha, n); % confidence level on 2d from chi2 distribution
[xe, ye, major, minor, bbox] = ellipse(A, b, 100, mu); % ellipse

% plot the ellipse
figure(1);
subplot(3,3,3)
plot(xe,ye,'black') % plot the ellipse
grid on
hold on
plot(0,0,'black+')
hold on
xlabel('$\Delta \theta_0$','Interpreter','latex','FontSize',16)
ylabel('$\Delta \theta_2$','Interpreter','latex','FontSize',16)

print -depsc ellipsoids_heat_capacity.eps

% parameters confidence 95% intervals (boundingbox)
% compare against true parameters
chi= chi2inv(0.95,3) 
conf=sqrt(diag(C)*chi)
Confth=[thetaest-conf,thetaest+conf,theta]

% parameters confidence 95% intervals (marginals)
% compare against true parameters
chi= chi2inv(0.95,1)
conf=sqrt(diag(C)*chi)
Confth=[thetaest-conf,thetaest+conf,theta]

% outputs confidence 95% intervals 
% compare against predicted and measured outputs
 chi= chi2inv(0.95,N)
 Cy=X*C*X';
 conf=sqrt(diag(Cy)*chi);
 Confy=[Yhat-conf,Yhat+conf,Yhat,Y];
 
figure(3)
plot(Yhat,'blacko','MarkerFaceColor','black')
hold on
plot(y,'blacko','MarkerFaceColor','w')
hold on
plot(Yhat-conf,'black--','MarkerFaceColor','w')
hold on
plot(Yhat+conf,'black--','MarkerFaceColor','w')
grid on
xlabel('$\omega$','Interpreter','latex','FontSize',16)
ylabel('$y_\omega$','Interpreter','latex','FontSize',16)
set(gca,'FontSize',14)
print -deps heat_capacity_outputs.eps

% try matlab built-in functions
X = [x xsq];
Y = y;
lm = fitlm(X,Y,'linear')

%  get parameter confidence intervals
CI=coefCI(lm)