% Victor Z
% UW-Madison, 2020
% illustrate scalar linear estimation
clc; clear all; close all hidden;

% generate data for input
rng(0)
S=100;
xobs=rand(S,1);

% generate true output
theta=2;
y=theta*xobs;

% add noise
sigma=0.25;
eps=normrnd(0,sigma,S,1);
yobs=y+eps;

% now get estimate theta that extracts max knowledge from data
htheta=(xobs'*yobs)/(xobs'*xobs)

% plot model prediction
ypred=htheta*xobs;

figure(3)
plot(xobs,yobs,'blacko','MarkerFaceColor','w')
hold on
grid on
xlabel('$x_\omega$','Interpreter','latex','FontSize',16)
ylabel('$y_\omega$','Interpreter','latex','FontSize',16)
set(gca,'FontSize',16)
print -depsc ch5_lin_est.eps

figure(1)
subplot(2,2,1)
plot(xobs,ypred,'black-','LineWidth',1.5)
hold on
plot(xobs,yobs,'blacko','MarkerFaceColor','w')
hold on
grid on
legend('Model','Data','location','southeast')
xlabel('$x_\omega$','Interpreter','latex','FontSize',14)
ylabel('$y_\omega$','Interpreter','latex','FontSize',14)

% parity plot
subplot(2,2,2)
yy=linspace(min(yobs),max(yobs))
plot(yy,yy,'black-','LineWidth',1.5)
hold on
plot(yobs,ypred,'blacko','MarkerFaceColor','w')
axis([min(yobs) max(yobs) min(yobs) max(yobs)])
grid on
hold on
xlabel('$y_\omega$','Interpreter','latex','FontSize',14)
ylabel('$\hat{y}_\omega$','Interpreter','latex','FontSize',14)

% plot residuals
epsm=yobs-ypred
xx=linspace(0,S)
yy=linspace(0,0)
subplot(2,2,3)
plot(xx,yy,'black-','LineWidth',1.5)
hold on
plot(epsm,'blacko','MarkerFaceColor','w')
axis([0,S,-3*sigma,+3*sigma])
hold on
grid on
xlabel('$\omega$','Interpreter','latex','FontSize',14)
ylabel('$\epsilon_\omega$','Interpreter','latex','FontSize',14)

pd = fitdist(epsm,'Normal')

subplot(2,2,4)
histogram(epsm,'BinWidth',0.1,'Normalization','pdf','EdgeColor','black','FaceColor','none','LineWidth',1)
hold on
xx=linspace(-0.75,0.75)
plot(xx,normpdf(xx,pd.mu,pd.sigma),'black-','LineWidth',1.5)
axis([-0.75 0.75 0 2.2])
grid on
xlabel('$\epsilon$','Interpreter','latex','FontSize',14)
ylabel('$f(\epsilon)$','Interpreter','latex','FontSize',14)
print -depsc ch5_results_lin_est.eps


%%%% now lets evaluate how SSE(theta) varies with amount of data available
% generate data for input
rng(0)
S=10;
xobs=rand(S,1);

% generate true output
theta=2;
y=theta*xobs;

% add noise
eps=normrnd(0,sigma,S,1);
yobs=y+eps;

% span theta
thetav=linspace(0,4);

for k=1:length(thetav)
    ym=thetav(k)*xobs;
    Sf(k)=0.5*(ym-yobs)'*(ym-yobs);
end

figure(2)
plot(thetav,(1/S)*Sf,'black-','LineWidth',1.5)
hold on

% generate data for input
rng(0)
S=100;
xobs=rand(S,1);

% generate true output
theta=2;
y=theta*xobs;

% add noise
eps=normrnd(0,sigma,S,1);
yobs=y+eps;

% span theta
thetav=linspace(0,4);

for k=1:length(thetav)
    ym=thetav(k)*xobs;
    Sf(k)=0.5*(ym-yobs)'*(ym-yobs);
end

figure(2)
plot(thetav,(1/S)*Sf,'black--','LineWidth',1.5)


% generate data for input
rng(0)
S=1000;
xobs=rand(S,1);

% generate true output
theta=2;
y=theta*xobs;

% add noise
eps=normrnd(0,sigma,S,1);
yobs=y+eps;

% span theta
thetav=linspace(0,4);

for k=1:length(thetav)
    ym=thetav(k)*xobs;
    Sf(k)=0.5*(ym-yobs)'*(ym-yobs);
end

figure(2)
plot(thetav,(1/S)*Sf,'blackx')
hold on
grid on
xlabel('$\theta$','Interpreter','latex','FontSize',16)
ylabel('$SSE(\theta)$','Interpreter','latex','FontSize',16)
set(gca,'FontSize',14)
legend('$S=10$','$S=100$','$S=1000$','Interpreter','latex')
print -depsc ch5_sharpness_lin_est.eps

