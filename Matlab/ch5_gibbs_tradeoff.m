% Victor Z
% UW-Madison, 2024
% regularization for Gibbs reactor
clc; clear all; close all hidden; format short e;

%% generate dataset
% get data (pressure, conversion, flow co, flow h2, flow ch3oh)
load ('./Data/gibbs_covariance.dat')
datat=gibbs_covariance;
% get temperature data
load ('./Data/gibbs_lowtemp_class.dat')
datan=gibbs_lowtemp_class;
% join data (pressure, conversion, flow co, flow h2, flow ch3oh, temperature)
data=[datat datan(:,1)];

% perturb data with noise
rng(1); % For reproducibility 
[S,n]=size(data);
data(:,2)=data(:,2)+normrnd(0,0.05,S,1);

% construct input-output data matrices
Y=data(:,2);  % conversion
X=data(:,[1 3 4 5 6]); % rest of variables as inputs
% scale data
mu=mean(X);
sig=std(X);
X=(X-mu)./sig;
% join data (ones, pressure, flow co, flow h2, flow ch3oh, temperature)
X=[ones(S,1) X]; 

%% solve estimation problem
dat.y=Y;
dat.X=X;
dat.kappa=0;
theta=ones(6,1);
options = optimoptions(@fmincon,'Algorithm','trust-region-reflective','display','none');
[thetahat] = fmincon(@myfun,theta,[],[],[],[],[],[],[],[],options,dat)

% evaluate fit
MSE=msefun(thetahat,dat)

% compare predictions and observations
Yhat=dat.X*thetahat;
figure(1)
subplot(2,2,1)
xx=linspace(0,1);
plot(Y,Yhat,'blacko','MarkerFaceColor','w')
hold on
plot(xx,xx,'black')
grid on
xlabel('$y$','Interpreter','latex','FontSize',14)
ylabel('$\hat{y}$','Interpreter','latex','FontSize',14)
axis([0.2 1 0.2 1])


%% compare with analytical solution
thetan=(X'*X)\(X'*Y)
MSEn=msefun(thetan,dat)

% get hessian
H=X'*X
lam=eigs(H)

%% solve regularized problem
kappa=logspace(-12,1,100);
for k=1:length(kappa)
dat.kappa=kappa(k);
options = optimoptions(@fmincon,'Algorithm','trust-region-reflective','display','none');
[theta] = fmincon(@myfun,theta,[],[],[],[],[],[],[],[],options,dat);

thetav(:,k)=theta;
MSE(k)=msefun(thetav(:,k),dat);
rho(k)=rhofun(thetav(:,k));

% count number of non-zero parameters
nnz(k)=sum(abs(thetav(:,k))>1e-4);

end

%% compare fit to model with 3 parameters (keep input variables 1,3,4,5)
thetasparse=thetav(:,87)
Xnew=[X(:,1),X(:,3),X(:,4)];
thetan=(Xnew'*Xnew)\(Xnew'*Y);
Yhat=Xnew*thetan;
datnew.X=Xnew;
datnew.y=Y;
MSEsparse=msefun(thetan,datnew)

figure(1)
subplot(2,2,2)
xx=linspace(0,1);
plot(Y,Yhat,'blacko','MarkerFaceColor','w')
hold on
plot(xx,xx,'black')
grid on
xlabel('$y$','Interpreter','latex','FontSize',14)
ylabel('$\hat{y}$','Interpreter','latex','FontSize',14)
axis([0.2 1 0.2 1])
print -depsc ch5_gibbs_fit.eps


%% draw trade-off curve
figure(2)
subplot(2,2,1)
semilogx(rho,MSE,'blacko-','MarkerFaceColor','black')
grid on
xlabel('$\rho$','Interpreter','latex','FontSize',14)
ylabel('$MSE$','Interpreter','latex','FontSize',14)
axis([min(rho) 1 0 max(MSE)])


subplot(2,2,2)
semilogy(nnz,MSE,'blacko','MarkerFaceColor','black')
grid on
xlabel('$NNZ$','Interpreter','latex','FontSize',14)
ylabel('$MSE$','Interpreter','latex','FontSize',14)
axis([0 6 0 0.2])

print -depsc ch5_gibbs_tradeoff.eps



%% define SSE function
function MSE=msefun(theta,dat)

yhat=dat.X*theta;

MSE=mean((yhat-dat.y).^2);

end

%% define penalty function
function rho=rhofun(theta)

rho=sum(abs(theta));

end

%% define objective function
function F=myfun(theta,dummy,dat)

X=dat.X;
y=dat.y;
y=X*theta;

MSE=mean((y-dat.y).^2);
rho=sum(abs(theta));

F = MSE + dat.kappa*rho;

end
