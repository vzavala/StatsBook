% Victor Z
% UW-Madison, 2020
% least-squares fit of weibull

clc; clear all; close all hidden;

% generate observations for weibull

S = 100;
rng(1);

beta=1 %(scale)
xi=2 %(shape)

xdata = wblrnd(beta,xi,S,1);

%% assume Weibull model and fit to cdf

% generate thresholds and ecdf at thresholds
N = 20;
t = linspace(min(xdata),max(xdata),N);

for k=1:length(t)
   s=0;
   for j=1:S
       if xdata(j)<=t(k)
           s=s+1;
       end
   end
   F(k)=(1/S)*s;
end

% drop last term 
t=t(1:N-1);
F=F(1:N-1);

%% solve least squares problem 

theta=[1,1]; % initial guess for parameters
opt= optimoptions('fmincon','Display','iter','Algorithm','sqp','OptimalityTolerance',1e-10);
theta=fmincon(@lsfunc,theta,[],[],[],[],[],[],[],opt,t,F);

% get optimal estimates
betahat=theta(1) % scale parameter
xihat=theta(2)   % shape parameter

%% alternatively, we can solve least-squares problem (analytically) using log transformation
 
 x = log(t);
 y = log(-log(1 - F));
 
 my=mean(y);
 mx=mean(x);
 theta1=sum(x.*(y-my))/sum(x.*(x-mx))
 theta0=my-theta1*mx
 
 % get estimates
 xilin=theta1
 betalin=exp(-theta0/xilin)
 
%% compare model cdf (with LS estimates) to empirical cdf 
figure(2)
subplot(2,1,1)
tgrid=linspace(0,5,100);
plot(tgrid,wblcdf(tgrid,beta,xi),'black-','LineWidth',1.5);
hold on
plot(t,F,'blacko','MarkerFaceColor','w')
xlabel('$t$','Interpreter','latex','FontSize',14) 
ylabel('$F(t)$','Interpreter','latex','FontSize',14)
axis([0 5 0 1.05])
grid on
subplot(2,1,2)
xgrid=linspace(0.01,16,1000);
histogram(xdata,'BinWidth',0.5,'Normalization','pdf','EdgeColor','black','FaceColor','none','LineWidth',1)
hold on
plot(xgrid,wblpdf(xgrid,beta,xi),'black-','LineWidth',1.5);
axis([0 5 0 1])
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$f(x)$','Interpreter','latex','FontSize',14)
grid on
legend({'Empirical','Least-Squares'},'location','northeast','Interpreter','latex','FontSize',14)
print -depsc ch4_weibull_ls_fit.eps


%% define function to optimize by LS

function LS=lsfunc(theta,t,F)

% evaluate the cdf of the Weibull model

Fmod= wblcdf(t,theta(1),theta(2));

% define squared errors
e = (F-Fmod).^2;

% define LS function
LS = (1/2)*sum(e);

end