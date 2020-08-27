% Victor Z
% UW-Madison, 2019
% compare alternatives using mean-variance

clc; clear all; close all hidden;
format long e

x=linspace(0,10,1000);

figure(1)
plot(x,normpdf(x,3,1.5),'b-','LineWidth',1.5)
hold on
plot(x,normpdf(x,4,0.5),'r-','LineWidth',1.5)
grid on
xlabel('$y$','Interpreter','latex')
ylabel('$f(y)$','Interpreter','latex')
legend('Option 1 ($Y(u_1)$)','Option 2 ($Y(u_2)$)','Interpreter','latex')
print -depsc mean_var_options.eps

figure(2)
subplot(2,2,1)
plot(x,normpdf(x,3,1.5),'b-','LineWidth',1.5)
hold on
plot(x,normpdf(x,4,0.5),'r-','LineWidth',1.5)
grid on
xlabel('$y$','Interpreter','latex')
ylabel('$f(y)$','Interpreter','latex')
subplot(2,2,2)
plot(x,normcdf(x,3,1.5),'b-','LineWidth',1.5)
hold on
plot(x,normcdf(x,4,0.5),'r-','LineWidth',1.5)
grid on
legend('Option 1 ($Y(u_1)$)','Option 2 ($Y(u_2)$)','Interpreter','latex','location','southeast')
xlabel('$y$','Interpreter','latex')
ylabel('$F(y)$','Interpreter','latex')
print -depsc mean_var_options_pdf_cdf.eps

% summarizing stats
y=5;
ploss1=1-normcdf(y,3,1.5)
ploss2=1-normcdf(y,4,0.5)

y=4;
ploss1=1-normcdf(y,3,1.5)
ploss2=1-normcdf(y,4,0.5)

alpha=0.9
Q1=norminv(alpha,3,1.5)
Q2=norminv(alpha,4,0.5)

N=1000
X1=normrnd(3,1.5,N,1);
X2=normrnd(4,0.5,N,1);

S1=0;
S2=0;
for k=1:length(X1)
    S1=S1+(Q1+(1/alpha)*max(X1(k)-Q1,0));
    S2=S2+(Q1+(1/alpha)*max(X2(k)-Q2,0));
end
S1=S1/N
S2=S2/N