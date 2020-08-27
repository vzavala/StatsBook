% Victor Z
% UW-Madison, 2020
% pdf and cdf of a hypergeometric RV

clc; clear all; close all hidden;

% pdf
N=500;
n=50;
Ny=50;
x=0:1:min(n,Ny);
n=length(x);

for j=1:n
   f(j)=nchoosek(Ny,x(j))*nchoosek(N-Ny,n-x(j))/nchoosek(N,n);
   %f(j)=hygepdf(x(j),N,Ny,n) %matlab built-in function
end

% compute cdf empirically, since the cdf formula is too complex
t = 0:1:n+1;
for i=1:length(t)
    F(i)=0;
for j=1:length(x)
    F(i)=F(i)+(x(j)<=t(i))*f(j);
end
% F(i)=hygecdf(t(i),N,Ny,n) %matlab built-in function
end


figure(1)

% visualize pdf
subplot(2,2,1)
for j=1:n
    plot(x(j)*ones(100,1),linspace(0,f(j),100),'black--')
    hold on
end
scatter(x,f,'MarkerFaceColor','w','MarkerEdgeColor','black')
grid on
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$f(x)$','Interpreter','latex','FontSize',14)
axis([min(x)-1 20 min(f) max(f)])

% visualize cdf
subplot(2,2,2)
stairs(t,F,'black-')
hold on
for j=1:n
    scatter(t(j),F(j),'MarkerFaceColor','w','MarkerEdgeColor','black')
    hold on
end
grid on
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$F(x)$','Interpreter','latex','FontSize',14)
axis([min(x)-1 20 -0.02 1.02])

print -depsc pdfcdfhypergeo.eps
