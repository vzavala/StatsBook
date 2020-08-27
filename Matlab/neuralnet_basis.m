% Victor Z
% UW-Madison, 2020
% basis functions for neural nets
% https://www.mathworks.com/help/stats/rsmdemo.html

clc; clear all; close all hidden;
format long e

% we try to fit this nonlinear model
x=linspace(-1,1,20);
y= sin(4*x)+sin(8*x)+exp(-x);

data.x=x;
data.y=y;
data.m=6; % number of basis functions (perceptrons)
data.n=length(x);

% parameters are mix weights, evidence, and bias
beta=ones(3*data.m,1);

options = optimoptions(@lsqnonlin,'Algorithm','trust-region-reflective','Display','iter','MaxFunctionEvaluations',5000);
[betahat,resnorm,residual,exitflag,output,lambda,jacobian] = lsqnonlin(@myfun,beta,[],[],options,data);

display(betahat)
yhat=myfun(betahat,data)+data.y';

xv=linspace(-1,1)';
figure(1)
subplot(2,2,1)
plot(x,y,'blacko','MarkerFaceColor','w')
hold on
plot(xv,myfun2(betahat,xv,data.m),'black')
grid on
 ylabel('$y$','Interpreter','latex')
  xlabel('$x$','Interpreter','latex')
subplot(2,2,2)
xx=linspace(-1,2.5);
plot(yhat,data.y','blacko','MarkerFaceColor','w')
hold on
plot(xx,xx,'black')
axis([-1,2.5,-1,2.5])
 ylabel('$y_\omega$','Interpreter','latex','FontSize',14)
  xlabel('$\hat{y}_\omega$','Interpreter','latex','FontSize',14)
grid on
print -depsc basis_nn_fit.eps

figure(2)
b=betahat;
for k=1:data.m
    theta(k)=b(k);
        w(k)=b(1*data.m+k);
     bias(k)=b(2*data.m+k);
end

for k=1:data.m
    z = theta(k)*xv'+bias(k);
  yn = 1./(1+exp(-z));  
  subplot(3,3,k)
  plot(xv,yn,'black','LineWidth',1.5)
  grid on
  ylabel('$\phi_k(x)$','Interpreter','latex','FontSize',14)
  xlabel('$x$','Interpreter','latex','FontSize',14)
end
print -depsc basis_nn.eps

% hessian is approximated as

H=full(jacobian'*jacobian);

% check eigenvalues

lambda=eig(H)


function F=myfun(b,data)

for k=1:data.m
    theta(k)=b(k);
        w(k)=b(1*data.m+k);
     bias(k)=b(2*data.m+k);
end

y=zeros(data.n,1);

for k=1:data.m
    z = theta(k)*data.x'+bias(k);
  yn = 1./(1+exp(-z));  
   y = y + w(k)*yn;
end

F=y-data.y';

end

function F=myfun2(b,x,m)

n=length(x)

for k=1:m
    theta(k)=b(k);
        w(k)=b(1*m+k);
     bias(k)=b(2*m+k);
end

y=zeros(n,1);

for k=1:m
    z = theta(k)*x+bias(k);
  yn = 1./(1+exp(-z));  
   y = y + w(k)*yn;
end

F=y;

end