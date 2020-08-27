% Victor Z
% UW-Madison, 2020
% compare cdfs for standard normal and normal for mixing problem

clc; clear all; close all hidden;

x=linspace(-4,4);
n=length(x);
mu=30; sig=1;

% prob level
alpha=0.977

% the quantile for N(0,1) - zalpha
q1 = norminv(alpha,0,1)

% the quantile of N(mu,sigma) - Qalpha
q1p = mu+q1*sig

% confirm this is true
q1p = norminv(alpha,mu,sig)

% plot quantile function for N(0,1)
subplot(2,2,1)
plot(x,normcdf(x,0,1),'black','LineWidth',1.5)
grid on
hold on
plot(x,alpha*ones(length(x),1),'black--')
hold on
plot(q1*ones(n,1),linspace(0,1),'black--')
text(0.68,0.05,'$z_\alpha\rightarrow$','Interpreter','latex','FontSize',14)
xlabel('$Q(\alpha)$','Interpreter','latex','FontSize',14)
ylabel('$\alpha$','Interpreter','latex','FontSize',14)

% plot quantile function for N(mu,sigma)
x=linspace(mu-4*sig,mu+4*sig);
subplot(2,2,2)
plot(x,normcdf(x,mu,sig),'black','LineWidth',1.5)
grid on
hold on
plot(x,alpha*ones(length(x),1),'black--')
hold on
plot(q1p*ones(n,1),linspace(0,1),'black--')
text(28.7,0.05,'$\mu+z_\alpha\cdot \sigma\rightarrow$','Interpreter','latex','FontSize',14)
xlabel('$Q(\alpha)$','Interpreter','latex','FontSize',14)
ylabel('$\alpha$','Interpreter','latex','FontSize',14)

print -depsc mixing_gauss.eps

%%% compute 90% confidence interval
figure(3)
mu=30; sig=1;
x=linspace(mu-4*sig,mu+4*sig);
n=length(x);

% prob level
alpha=0.10

% the quantile for N(0,1) - zalpha
q = norminv(1-alpha/2,0,1)

% intervals
 qup = mu+q*sig
qlow = mu-q*sig

plot(x,normpdf(x,mu,sig),'black','LineWidth',1.5)
grid on
hold on
plot(qup*ones(n,1),linspace(0,0.4),'black--','LineWidth',1.5)
plot(qlow*ones(n,1),linspace(0,0.4),'black--','LineWidth',1.5)
text(29.75,0.01,'$\Longleftrightarrow$','Interpreter','latex','FontSize',14)
text(qup-0.4,0.41,'$\mu+ z_{\alpha/2}\sigma$','Interpreter','latex','FontSize',14)
text(qlow-0.4,0.41,'$\mu- z_{\alpha/2}\sigma$','Interpreter','latex','FontSize',14)
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$f(x)$','Interpreter','latex','FontSize',14)

print -depsc conf_mixing.eps
