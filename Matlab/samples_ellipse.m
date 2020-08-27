% Victor Z
% UW-Madison, 2019
% samples of multivariate Gaussian lie on ellipse

clc; 
clear all; 
close all hidden; 
format short 

% specify mean and covariance 
mu = [0 0];
Sigma = [1 -0.5; -0.5 1]; % anticorrelated

% compute the 95% confidence interval ellipse
alpha = 0.95; % confidence 
n = 2; % dimension of variable
A = inv(Sigma); % inverse covariance
b = chi2inv(alpha, n); % confidence level on 2d from chi2 distribution
[xe, ye, major, minor, bbox] = ellipse(A, b, 100, mu); % ellipse

% count the number of samples in the ellipse
rng(0)
nsample = 1000; % number of random samples
sample = mvnrnd(mu,Sigma,nsample); % collect samples

% plot the ellipse and the samples
figure(1); 
plot(xe,ye,'k','LineWidth',1.5) % plot ellipse
hold on;
plot(sample(:,1),sample(:,2),'blacko','MarkerFaceColor','w'); % plot samples
xlabel('$x_1$','Interpreter','latex','FontSize',18); 
ylabel('$x_2$','Interpreter','latex','FontSize',18);
grid on
set(gca,'FontSize',18)
print -depsc gaussian_ellipsoid_points.eps

cnt = 0;
for i=1:nsample
    x = sample(i,:)-mu;
    if x*inv(Sigma)*x'<=b % count if in the confidence interval
        cnt=cnt+1;
    end        
end
fprintf('%i among %i samples in the ellipse\n',cnt,nsample); % print the result

figure(2)
colormap(sample(:,1),sample(:,2))