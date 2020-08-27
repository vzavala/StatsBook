% Victor Z
% UW-Madison, 2020
% show convergence of MC approximation

clc; clear all; close all hidden;

% generate samples of different sizes
% and compute approximations for different quantities
rng(0);
Sv=1:5:2000;
for j=1:length(Sv)
x = wblrnd(2,1,Sv(j),1);
e(j) = mean(x);
v(j) = mean(log(x));
c(j) = var(exp(x)+x.^2);
end

subplot(3,1,1)
plot(Sv,e,'blacko','MarkerFaceColor','w')
ylabel('$E[X]$','Interpreter','latex','FontSize',14)
grid on
subplot(3,1,2)
plot(Sv,v,'blacko','MarkerFaceColor','w')
ylabel('$E[\log(X)]$','Interpreter','latex','FontSize',14)
grid on
subplot(3,1,3)
plot(Sv,v,'blacko','MarkerFaceColor','w')
xlabel('Sample Size ($S$)','Interpreter','latex','FontSize',14)
ylabel('${V}[\exp(X)+X^2]$','Interpreter','latex','FontSize',14)
grid on

print -depsc convergence_mc.eps