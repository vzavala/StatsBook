% Victor Z
% UW-Madison, 2020
% hougen watson with constraints
% https://www.mathworks.com/help/stats/rsmdemo.html

clc
clear all
close all hidden
format bank 

S = load('reaction');
X = S.reactants; % experimental reactant concentrations
y = S.rate; % experimental reaction rates
beta = S.beta; % guess for parameters
[n,m]=size(X);

data.x=X;
data.y=y;
data.n=n;
data.m=m;

% solve unconstrained problem
beta=ones(5,1)*(-1);
options = optimoptions(@lsqnonlin,'Algorithm','trust-region-reflective','Display','iter');
[betahat,resnorm,residual,exitflag,output,lambda,jacobian]...
    = lsqnonlin(@myfun,beta,[],[],options,data);

display(betahat)
yhat=myfun(betahat,data)+data.y;

figure(2)
xx=linspace(0,15);
plot(yhat,data.y','blacko','MarkerFaceColor','w')
hold on
plot(xx,xx,'black-')
xlabel('$\hat{y}$','Interpreter','latex','FontSize',16)
ylabel('$y$','Interpreter','latex','FontSize',16)
grid on
print -depsc hougen_fit_constraints.eps

% hessian is approximated as

H=full(jacobian'*jacobian);

% check eigenvalues

lambda=eigs(H)

% solve constrained problem
thetalb=zeros(5,1);
thetaub=ones(5,1)*2;
beta=ones(5,1)*(-1);
options = optimoptions(@lsqnonlin,'Algorithm','trust-region-reflective','Display','iter');
[betahat,resnorm,residual,exitflag,output,lambda,jacobian]...
    = lsqnonlin(@myfun,beta,thetalb,thetaub,options,data);

display(betahat)

% hessian is approximated as
H=full(jacobian'*jacobian)

% check eigenvalues

lambda=eigs(H)

% get covariance
e=yhat-y;
sigma2=var(e);

Cov=inv(H)*sigma2

Var=diag(Cov)

function F=myfun(b,data)

b1=b(1);
b2=b(2);
b3=b(3);
b4=b(4);
b5=b(5);

x1=data.x(:,1);
x2=data.x(:,2);
x3=data.x(:,3);

y=(b1*x2-x3/b5)./(1+b2*x1+b3*x2+b4*x3);

F=y-data.y;

end