% Victor Z
% UW-Madison, 2019
% linear regression for catalytic reactor
% see https://www.mathworks.com/help/stats/understanding-linear-regression-outputs.html

clc; clear all; close all hidden;

load data_ex16_8.dat
data=data_ex16_8
[n,m]=size(data)

% get input and output data (add column of ones)
X=[ones(n,1) data(:,2:3)];
Y=data(:,1);

% obtain best fit parameters
theta=inv(X'*X)*X'*Y;
Yhat=X*theta;
e=Y-Yhat;
sig2=var(e);
C=inv(X'*X)*sig2;

% visualize 1-2 pair
Sigma=C(1:2,1:2);
mu= [0;0];

% compute the 95% confidence interval ellipse
alpha = 0.95; % confidence 
n = 2; % dimension of variable
A = inv(Sigma); % inverse covariance
b = chi2inv(alpha, n); % confidence level on 2d from chi2 distribution
[xe, ye, major, minor, bbox] = ellipse(A, b, 100, mu); % ellipse

% plot the ellipse
figure(1);
subplot(3,3,1)
plot(xe,ye,'b') % plot the ellipse
grid on
hold on

% visualize 2-3 pair
Sigma=C(2:3,2:3);

% compute the 95% confidence interval ellipse
alpha = 0.95; % confidence 
n = 2; % dimension of variable
A = inv(Sigma); % inverse covariance
b = chi2inv(alpha, n); % confidence level on 2d from chi2 distribution
[xe, ye, major, minor, bbox] = ellipse(A, b, 100, mu); % ellipse

% plot the ellipse
figure(1);
subplot(3,3,2)
plot(xe,ye,'b') % plot the ellipse
grid on
hold on

% visualize 1-3 pair
Sigma=C([1,3],[1,3]);

% compute the 95% confidence interval ellipse
alpha = 0.95; % confidence 
n = 2; % dimension of variable
A = inv(Sigma); % inverse covariance
b = chi2inv(alpha, n); % confidence level on 2d from chi2 distribution
[xe, ye, major, minor, bbox] = ellipse(A, b, 100, mu); % ellipse

% plot the ellipse
figure(1);
subplot(3,3,3)
plot(xe,ye,'b') % plot the ellipse
grid on
hold on

%%%%%% repeat using less data

load data_ex16_8.dat
data=data_ex16_8
[n,m]=size(data)

% get input and output data (add column of ones)
X=[ones(n,1) data(:,2:3)];
X=X(1:n/2,:)
Y=data(:,1);
Y=Y(1:n/2);

% obtain best fit parameters
theta=inv(X'*X)*X'*Y;
Yhat=X*theta;
e=Y-Yhat;
sig2=var(e);
C=inv(X'*X)*sig2;

% visualize 1-2 pair
Sigma=C(1:2,1:2);

% compute the 95% confidence interval ellipse
alpha = 0.95; % confidence 
n = 2; % dimension of variable
A = inv(Sigma); % inverse covariance
b = chi2inv(alpha, n); % confidence level on 2d from chi2 distribution
[xe, ye, major, minor, bbox] = ellipse(A, b, 100, mu); % ellipse

% plot the ellipse
figure(1);
subplot(3,3,1)
plot(xe,ye,'k') % plot the ellipse
grid on
xlabel('$\theta_0$','Interpreter','latex')
ylabel('$\theta_1$','Interpreter','latex')
legend('S=32','S=16')

% visualize 2-3 pair
Sigma=C(2:3,2:3);

% compute the 95% confidence interval ellipse
alpha = 0.95; % confidence 
n = 2; % dimension of variable
A = inv(Sigma); % inverse covariance
b = chi2inv(alpha, n); % confidence level on 2d from chi2 distribution
[xe, ye, major, minor, bbox] = ellipse(A, b, 100, mu); % ellipse

% plot the ellipse
figure(1);
subplot(3,3,2)
plot(xe,ye,'k') % plot the ellipse
grid on
xlabel('$\theta_1$','Interpreter','latex')
ylabel('$\theta_2$','Interpreter','latex')

% visualize 1-3 pair
Sigma=C([1,3],[1,3]);

% compute the 95% confidence interval ellipse
alpha = 0.95; % confidence 
n = 2; % dimension of variable
A = inv(Sigma); % inverse covariance
b = chi2inv(alpha, n); % confidence level on 2d from chi2 distribution
[xe, ye, major, minor, bbox] = ellipse(A, b, 100, mu); % ellipse

% plot the ellipse
figure(1);
subplot(3,3,3)
plot(xe,ye,'k') % plot the ellipse
grid on
xlabel('$\theta_0$','Interpreter','latex')
ylabel('$\theta_2$','Interpreter','latex')
print -depsc ellipsoids_reactor.eps