% Victor Z
% UW-Madison, 2020
% pdf and cdf of a binomial RV

clc; clear all; close all hidden;

% pdf
n=10;
p=0.3;
x=0:1:n;
n=length(x);

f=binopdf(x,n,p); %matlab built-in function
F=binocdf(x,n,p); %matlab built-in function

figure(1)

% visualize pdf and cdf
subplot(2,2,1)
for j=1:n
    plot(x(j)*ones(100,1),linspace(0,f(j),100),'black--')
    hold on
end
scatter(x,f,'MarkerFaceColor','w','MarkerEdgeColor','black')
grid on
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$f(x)$','Interpreter','latex','FontSize',14)
axis([min(x)-1 10 min(f) max(f)])
subplot(2,2,2)
stairs(x,F,'black-')
hold on
for j=1:n
    scatter(x(j),F(j),'MarkerFaceColor','w','MarkerEdgeColor','black')
    hold on
end
grid on
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$F(x)$','Interpreter','latex','FontSize',14)
axis([min(x)-1 10 -0.02 1.02])

% compare for different p
 p=[0.95 0.75 0.5];
color=["black","black","black"];
marker=["o-","x-","d-"];

subplot(2,2,3)
for k=1:length(p)
plot(x,binopdf(x,n,p(k)),marker(k),'MarkerFaceColor','w','MarkerEdgeColor',color(k),'Color',color(k))
hold on
end
grid on
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$f(x)$','Interpreter','latex','FontSize',14)
lgd=legend('$p=0.95$','$p=0.75$','$p=0.50$','Interpreter','latex','location','northwest')
lgd.FontSize = 10;

title('')

% demonstrate that hypergeometric converges to binomial
subplot(2,2,4)
p=0.25
n=10;
x=0:1:n;
n=length(x);
N=1000
for j=1:length(N)
Ny=round(p*N(j));
xs=max(n+Ny-N(j),0):1:min(n,Ny);
plot(xs,hygepdf(xs,N(j),Ny,n),'black--','LineWidth',0.5)
hold on
end
grid on
plot(x,binopdf(x,n,p),'blacko','MarkerFaceColor','w','MarkerEdgeColor','black','Color','black','LineWidth',1.5)
lgd=legend('$H(1000,n,p)$','$Bi(n,p)$','Interpreter','latex','location','northeast')
lgd.FontSize = 10;
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$f(x)$','Interpreter','latex','FontSize',14)
print -depsc pdfcdfbinomial.eps