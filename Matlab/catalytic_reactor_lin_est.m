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

figure(1)
scatter3(X(:,2),X(:,3),Y,'o','MarkerFaceColor','w')
xlabel('Temperature')
ylabel('Pressure')
zlabel('Conversion')
print -depsc data_reactor.eps

% obtain best fit parameters
theta=inv(X'*X)*X'*Y

% get predictions
Yhat=X*theta

% get residuals
e=Y-Yhat

% root of mean squared error
rmse=sqrt(mean(e.^2))

% get R2
Ybar=mean(Y);
SSR=norm(Yhat-Ybar)^2;
SSE=norm(Yhat-Y)^2;
SSy=norm(Y-Ybar)^2;

R2=100*SSR/SSy

% visualize fit
figure(2)
subplot(2,2,1)
x=linspace(min(Y)-1,max(Y)+1);
plot(Y,Yhat,'o','MarkerFaceColor','w')
hold on
plot(x,x)
grid on
axis([min(Y)-1 max(Y)+1 min(Y)-1 max(Y)+1])
xlabel('$y$','Interpreter','latex')
ylabel('$\hat{y}$','Interpreter','latex')

% visualize residuals
subplot(2,2,2)
histfit(e,[],'Normal')
grid on
xlabel('$\epsilon$','Interpreter','latex')
ylabel('$f(\epsilon)$','Interpreter','latex')
print -depsc model_reactor.eps

% assume variance of error is from  sample
sig2=var(e)

% get covariance matrix for parameters
C=inv(X'*X)*sig2

% parameters confidence 95% intervals (marginals)
chi= chi2inv(0.95,1);
conf=sqrt(diag(C)*chi);
theta
[theta-conf,theta+conf]

% outputs confidence 95% intervals (marginals)
chi= chi2inv(0.95,1);
Cy=X*C*X';
conf=sqrt(diag(Cy)*chi);
Yhat
[Yhat-conf,Yhat+conf]

figure(3)
plot(Yhat,'o','MarkerFaceColor','w')
hold on
plot(Yhat-conf,'black--','MarkerFaceColor','w')
hold on
plot(Yhat+conf,'black--','MarkerFaceColor','w')
grid on
axis([1,32, 85, 91])
xlabel('$\omega$','Interpreter','latex')
ylabel('$y_\omega$','Interpreter','latex')
legend('Observation','Conf Interval','location','southeast')
print -deps output_reactor.eps


% try matlab built-in functions
X = data(:,2:3);
Y = data(:,1);
lm = fitlm(X,Y,'linear')

% get confidence intervals
CI=coefCI(lm)


