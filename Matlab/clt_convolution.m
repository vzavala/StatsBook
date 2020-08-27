% Victor Z
% UW-Madison, 2019
% illustrate central limit using convolutions

clc;  clear all; close all hidden; 
format short 

% get pdf
t=linspace(0,10,100);
f=unifpdf(t,4,6);


%% show that repetitive convolutions yield Gaussian
phi=f;
subplot(2,2,1)
stairs(t,phi/max(phi),'black','LineWidth',1.5)
grid on
ylabel('$\phi(x)$','Interpreter','Latex','FontSize',14)
xlabel('$x$','Interpreter','Latex','FontSize',14)
    
for k=1:3;
    phi=conv(phi,f,'same');
    phi=phi;
    figure(1)
    subplot(2,2,k+1)
    plot(t,phi/max(phi),'black','LineWidth',1.5)
    grid on
    ylabel('$\phi(x)$','Interpreter','Latex','FontSize',14)
    xlabel('$x$','Interpreter','Latex','FontSize',14)
end
print -depsc clt_convolutions.eps