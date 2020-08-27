% Victor Z
% UW-Madison, 2020
% Gaussian process (kriging) prediction for gibbs data
% https://www.mathworks.com/help/stats/fitrgp.html
% https://www.mathworks.com/help/stats/compactregressiongp.predict.html

clc; clear all; close all hidden

% create data set
load ('./Data/gibbs_hightemp_class.dat')
datahigh=gibbs_hightemp_class;
load ('./Data/gibbs_lowtemp_class.dat')
datalow=gibbs_lowtemp_class;
data=[datahigh;datalow];
n=length(data);

rng(0);
inputs=data(:,1:2)'+rand(2,n)*0.1;  % temperature and pressure
targets=data(:,3)'+rand(1,n)*0.1;   % yield

% define kriging model

gprMdl = fitrgp(inputs',targets','KernelFunction','squaredexponential')
[outputsgpr,outputsd,outputsci] = predict(gprMdl,inputs');
eps=targets'-outputsgpr;

% plot fit
figure(1)
subplot(2,2,1)
xx=linspace(0,1.1);
plot(targets,outputsgpr,'blacko','MarkerFaceColor','w')
grid on
hold on
plot(xx,xx,'black-')
xlabel('$y$','Interpreter','latex','FontSize',14)
ylabel('$\hat{y}$','Interpreter','latex','FontSize',14)
axis([0,1.1,0,1.1])

% define linear regression model
mdl = fitlm(inputs',targets')
outputsLR = predict(mdl,inputs');
eps2=targets'-outputsLR;

figure(1)
subplot(2,2,2)
plot(targets,outputsLR,'blacko','MarkerFaceColor','w')
hold on
grid on
plot(xx,xx,'black-')
xlabel('$y$','Interpreter','latex','FontSize',14)
ylabel('$\hat{y}$','Interpreter','latex','FontSize',14)
axis([0,1.1,0,1.1])
print -depsc fit_gibbs_kriging_linear.eps

% compare benchmark using cdfs and pdfs of residuals
figure(3)
subplot(2,2,1)
histogram(eps,'BinWidth',0.005,'Normalization','count','EdgeColor','black','FaceColor','none','LineWidth',1)
grid on
xlabel('$\epsilon$','Interpreter','latex','FontSize',14)
ylabel('$f(\epsilon)$','Interpreter','latex','FontSize',14)
axis([-0.2 0.07 0 35])
subplot(2,2,2)
histogram(eps2,'BinWidth',0.005,'Normalization','count','EdgeColor','black','FaceColor','none','LineWidth',1)
grid on
xlabel('$\epsilon$','Interpreter','latex','FontSize',14)
ylabel('$f(\epsilon)$','Interpreter','latex','FontSize',14)
axis([-0.2 0.07 0 35])

[F1,X1]=ecdf(abs(eps));
[F2,X2]=ecdf(abs(eps2));
subplot(2,2,[3 4])
stairs(X1,F1,'black-','LineWidth',1.5)
hold on
stairs(X2,F2,'black--','LineWidth',1.5)
grid on
axis([0,0.1,0,1.05])
xlabel('$t$','Interpreter','latex','FontSize',14)
ylabel('$P(|\epsilon|\leq t)$','Interpreter','latex','FontSize',14)
legend('$\textrm{Kriging}$','$\textrm{Linear}$','Location','southeast','Interpreter','latex','FontSize',14)
print -depsc benchmark_gibbs_kriging_linear_pdf_cdf.eps

% plot confidence intervals for gpr
c1=outputsci(:,1);
c2=outputsci(:,2);
E=(c2-c1)/2;

figure(4)
subplot(2,2,[1:2])
errorbar(1:50,targets(1:50),E(1:50),'black.');
hold on;
scatter(1:50,outputsgpr(1:50),'blacko','MarkerFaceColor','w')
%stairs(c1(1:50),'Color',[0.5 0.5 0.5]);
%stairs(c2(1:50),'Color',[0.5 0.5 0.5]);
axis([0 51 0.25 0.75])
xlabel('Observation $\omega$','Interpreter','latex','FontSize',16)
ylabel('Output $y$','Interpreter','latex','FontSize',16)
grid on
print -depsc conf_gibbs.eps

