% Victor Z
% UW-Madison, 2019
% compare chi-squared

clc; clear all; close all hidden;

 beta=[2,2,2,2];
alpha=[1/2,2/2,3/2,4/2];
color=["blue","red","green","black"];
x=linspace(0,4,1000);

subplot(2,2,1)
for k=1:length(beta)
plot(x,gampdf(x,alpha(k),beta(k)),color(k),'LineWidth',1.5)
hold on
end
grid on
xlabel('$x$','Interpreter','latex')
ylabel('$f(x)$','Interpreter','latex')
title('')
axis([0,4,0,1])

subplot(2,2,2)
for k=1:length(beta)
plot(x,gamcdf(x,alpha(k),beta(k)),color(k),'LineWidth',1.5)
hold on
end
grid on
lgd=legend('$r=1$','$r=2$','$r=3$','$r=4$','Interpreter','latex','location','southeast')
lgd.FontSize = 8;
xlabel('$x$','Interpreter','latex')
ylabel('$F(x)$','Interpreter','latex')
title('')
print -depsc chisq.eps


% plot quantile functions for chi2(1) and normal(0,1)
alpha=linspace(0.01,1);
figure(2)
subplot(2,2,1)
plot(alpha,chi2inv(1-alpha,1),'b-','LineWidth',1.5)
grid on
lgd=legend('$\chi^2(1)$','Interpreter','latex','location','northeast')
lgd.FontSize = 8;
ylabel('$Q(1-\alpha)$','Interpreter','latex')
xlabel('$\alpha$','Interpreter','latex')
title('')
subplot(2,2,2)
plot(alpha,norminv(1-alpha/2).^2,'b-','LineWidth',1.5)
grid on
lgd=legend('$N(0,1)$','Interpreter','latex','location','northeast')
lgd.FontSize = 8;
ylabel('$Q(1-\alpha/2)^2$','Interpreter','latex')
xlabel('$\alpha$','Interpreter','latex')
title('')
print -depsc quantiles_norm_chi2.eps