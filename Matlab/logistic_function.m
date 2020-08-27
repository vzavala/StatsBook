% Victor Z
% UW-Madison, 2019
% visualize logistic function

clc; clear all; close all hidden;

% span parameter
theta=[-1,0,1];

% span x space
x = linspace(-5,5);

for k=1:length(theta)
    theta(k)
    y=1./(1+exp(-theta(k)*x));
    figure(1)
    subplot(3,3,k)
    plot(x,y,'LineWidth',1.5,'Color','black');
    hold on
    grid on
    set(gca,'FontSize',14)
    xlabel('$x$','Interpreter','latex','FontSize', 14)
    ylabel('$g(x,\theta)$','Interpreter','latex','FontSize',14)
    axis([-5 5 0 1])
end
print -depsc logistic.eps

