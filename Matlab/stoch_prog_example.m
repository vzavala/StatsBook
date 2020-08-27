% Victor Z
% UW-Madison, 2019
% stochastic programming example

clc; clear all; close all hidden;

%%% generate sample for random variable
rng(0)
N=1000
X=normrnd(2,1,N,1);

% find deterministic solution
u=linspace(-10,10,1000);
x=mean(X)

for k=1:length(u)
phid(k)=myfun(u(k),x);
end

figure(2)
subplot(2,2,1)
plot(u,phid)
grid on
hold on
xlabel('$u$','Interpreter','latex')
ylabel('$\rho(\phi(u))$','Interpreter','latex')

idx=find(phid==min(phid));
ud=u(idx)

% evaluate how deterministic solution ud actually behaves
figure(1)
phid=myfun(ud,X);
subplot(2,2,2)
ecdf(phid)
grid on
hold on
subplot(2,2,1)
histogram(phid)
hold on


% now find stochastic solution
for k=1:length(u)
phi=myfun(u(k),X);

Ephi(k)=mean(phi);
Vphi(k)=sqrt(var(phi));
MVphi(k)=Ephi(k)+Vphi(k);
Qphi(k)=quantile(phi,0.9);
end

% select risk measure to optimize
rm=Qphi;

figure(2)
subplot(2,2,1)
plot(u,rm)
grid on

% find solution that minimizes risk
idx=find(rm==min(rm));
us=u(idx)

% evaluate how stochastic solution behaves
figure(1)
phis=myfun(us,X);
subplot(2,2,2)
ecdf(phis)
grid on
axis([-20 5 0 1.05])
xlabel('$\varphi$','Interpreter','latex')
ylabel('$F(\varphi)$','Interpreter','latex')
legend('Deterministic','Stochastic','location','northwest')
subplot(2,2,1)
histogram(phis)
xlabel('$\varphi$','Interpreter','latex')
ylabel('$f(\varphi)$','Interpreter','latex')
grid on
print -depsc det_stoch_comp.eps


 function phi=myfun(u,X)
 
 phi=(u-X).^2 - u*exp(0.5*X);
 
 end