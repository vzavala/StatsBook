% Victor Z
% UW-Madison, 2023
% sample average approximation example

clc; clear all; close all hidden; rng(0);
format compact;

%% general info
 u0 = 1;     % initial guess
alp = 0.05;  % alpha corresponding to confidence level 0.95
  z = norminv(1-alp/2,0,1); % quantile Q(1-alp/2) for N(0,1)
  B = 10;    % batch size for bounds
opt = optimoptions('fmincon','Display','none','Algorithm','sqp');

%% try different sample sizes
S=[1 10 50 100 500 1000 5000 10000];
S=round(S);

for k=1:length(S)
    
%% generate scenarios for random variable
 mu = 1;
sig = 10;
  X = normrnd(mu,sig,S(k),1);

%% get candidate solution
uc(k) = fmincon(@myfun,u0,[],[],[],[],[],[],[],opt,X);
 E(k) = myfun(uc(k),X);

%% obtain upper bound
Eub=[];
for j=1:B
  Xs = normrnd(mu,sig,S(k),1);
  Eub(j) = myfun(uc(k),Xs);    
end
mub(k) = mean(Eub);
sub(k) = std(Eub);
lub(k) = z*sub(k)/sqrt(B);

%% obtain lower bound
ulb=[]; Elb=[];
for j=1:B
  Xs = normrnd(mu,sig,S(k),1);
  ulb(j) = fmincon(@myfun,u0,[],[],[],[],[],[],[],opt,Xs);
  Elb(j) = myfun(ulb(j),Xs);  
end

% lower bound of optimal objective E
 mlb(k) = mean(Elb);
 slb(k) = std(Elb);
 llb(k) = z*slb(k)/sqrt(B);

% lower bound of optimal solution u
mulb(k) = mean(ulb);
sulb(k) = std(ulb);
lulb(k) = z*sulb(k)/sqrt(B);

end

%% analyze results

% gap
gap = [S' abs(mub-mlb)']

% confidence of lower bound
conflb = [S' mlb' llb']

% confidence of solution u
confulb = [S' mulb' lulb']

% visualize
figure(1)
subplot(1,2,1)
semilogx(S,mub+lub,'black--','LineWidth',1.5)
hold on; grid on;
semilogx(S,mlb-llb,'black--','LineWidth',1.5)
S2 = [S, fliplr(S)];
inBetween = [mlb-llb, fliplr(mub+lub)];
fill(S2, inBetween,[0.9 0.9 0.9]);
semilogx(S,E,'black','LineWidth',1.5)
xlabel('$S$','Interpreter','latex','FontSize',14)
ylabel('$\hat{E}_S$','Interpreter','latex','FontSize',14)

figure(1)
subplot(1,2,2)
semilogx(S,mulb-lulb,'black--','LineWidth',1.5)
hold on; grid on
semilogx(S,mulb+lulb,'black--','LineWidth',1.5)
S2 = [S, fliplr(S)];
inBetween = [mulb-lulb, fliplr(mulb+lulb)];
fill(S2, inBetween,[0.9 0.9 0.9]);
semilogx(S,uc,'black','LineWidth',1.5)
xlabel('$S$','Interpreter','latex','FontSize',14)
ylabel('$\hat{u}_S$','Interpreter','latex','FontSize',14)
print -depsc ch7_saa_analysis.eps


%% define function to minimize 
function E=myfun(u,X)
 
phi = (u-X).^2; % - u*exp(0.5*X);
  E = mean(phi);
 
end