% Victor Z
% UW-Madison, 2023
% compare alternatives using mean-variance

clc; clear all; close all hidden; format long e;

x=linspace(0,10,1000);

figure(1)
plot(x,normpdf(x,3,1.5),'LineWidth',1,'Color','black','LineStyle','-')
hold on
plot(x,normpdf(x,4,0.5),'LineWidth',1,'Color','black','LineStyle','--')
grid on
xlabel('$y$','Interpreter','latex','FontSize',14)
ylabel('$f(y)$','Interpreter','latex','FontSize',14)
legend('Option I','Option II','Interpreter','latex','location','northeast')
print -depsc ch7_mean_var_options.eps

figure(2)
subplot(2,2,1)
plot(x,normpdf(x,3,1.5),'LineWidth',1,'Color','black','LineStyle','-')
hold on
plot(x,normpdf(x,4,0.5),'LineWidth',1,'Color','black','LineStyle','--')
grid on
xlabel('$y$','Interpreter','latex','FontSize',14)
ylabel('$f(y)$','Interpreter','latex','FontSize',14)
legend('Option I','Option II','Interpreter','latex','location','northeast')
subplot(2,2,2)
plot(x,normcdf(x,3,1.5),'LineWidth',1,'Color','black','LineStyle','-')
hold on
plot(x,normcdf(x,4,0.5),'LineWidth',1,'Color','black','LineStyle','--')
grid on
legend('Option I','Option II','Interpreter','latex','location','southeast')
xlabel('$y$','Interpreter','latex','FontSize',14)
ylabel('$F(y)$','Interpreter','latex','FontSize',14)
axis([0 10 0 1.05])
print -depsc ch7_mean_var_options_pdf_cdf.eps

% summarizing statistics
y=5;
ploss1=1-normcdf(y,3,1.5)
ploss2=1-normcdf(y,4,0.5)

y=4;
ploss1=1-normcdf(y,3,1.5)
ploss2=1-normcdf(y,4,0.5)

alpha=0.9;
Q1=norminv(alpha,3,1.5)
Q2=norminv(alpha,4,0.5)

N=1000;
rng(1)
X1=normrnd(3,1.5,N,1);
X2=normrnd(4,0.5,N,1);

%% expected shortfall (CVaR)

loc = X1 >= Q1;
CVaR1 = mean(X1(loc))

loc = X2 >= Q2;
CVaR2 = mean(X2(loc))

% alternative way to compute expected loss
S1=0;
S2=0;
for k=1:N
    S1=S1+(Q1+(1/(1-alpha))*max(X1(k)-Q1,0));
    S2=S2+(Q2+(1/(1-alpha))*max(X2(k)-Q2,0));
end
CVaR1=S1/N
CVaR2=S2/N

