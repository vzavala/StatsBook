% Victor Z
% UW-Madison, 2022
% generator sizing example 
% explore conflict resolution (mean vs. variance)

clc; clear all; close all hidden;

%% generate scenarios for random load
rng(0)
N=1000;
X=wblrnd(10,2,N,1);


 lb = 0; ub=+10; %upper bound for sizes 
opt = optimoptions('fmincon','Display','iter','Algorithm','sqp');
 u0 = 1;
kappa = 0:1:15;
  
for k=1:length(kappa)
    
    u(k) = fmincon(@myfun,u0,[],[],[],[],lb,ub,[],opt,X,kappa(k));
 rho1(k) = myfun1(u(k),X);
 rho2(k) = myfun2(u(k),X);
 
end

figure(1)
subplot(2,2,1)
plot(rho1,rho2,'LineWidth',1,'Color','black','LineStyle','-')
hold on
scatter(rho1,rho2,'MarkerFaceColor','w','MarkerEdgeColor','black')
grid on
hold on
xlabel('$E[Y(u)]$','Interpreter','latex','FontSize',14)
ylabel('$SD[Y(u)]$','Interpreter','latex','FontSize',14)
axis([min(rho1) max(rho1) min(rho2) max(rho2)])
subplot(2,2,2)
plot(kappa,u,'LineWidth',1,'Color','black','LineStyle','-')
hold on
scatter(kappa,u,'MarkerFaceColor','w','MarkerEdgeColor','black')
grid on
hold on
xlabel('$\kappa$','Interpreter','latex','FontSize',14)
ylabel('$u^*$','Interpreter','latex','FontSize',14)
axis([min(kappa) max(kappa) min(u) max(u)])


%% now span CVaR with alpha
alpha = 0:0.1:1;
u=[];
rho1=[];
rho2=[];
u0=1;
for k=1:length(alpha)
    
    u(k) = fmincon(@myfun3,u0,[],[],[],[],lb,ub,[],opt,X,alpha(k));
 rho1(k) = myfun1(u(k),X);
 rho2(k) = myfun2(u(k),X);
     u0  = u(k)
 
end

figure(1)
subplot(2,2,3)
plot(rho1,rho2,'LineWidth',1,'Color','black','LineStyle','-')
hold on
scatter(rho1,rho2,'MarkerFaceColor','w','MarkerEdgeColor','black')
grid on
hold on
xlabel('$E[Y(u)]$','Interpreter','latex','FontSize',14)
ylabel('$SD[Y(u)]$','Interpreter','latex','FontSize',14)
axis([min(rho1) max(rho1) min(rho2) max(rho2)])
subplot(2,2,4)
plot(alpha,u,'LineWidth',1,'Color','black','LineStyle','-')
hold on
scatter(alpha,u,'MarkerFaceColor','w','MarkerEdgeColor','black')
grid on
hold on
xlabel('$\alpha$','Interpreter','latex','FontSize',14)
ylabel('$u^*$','Interpreter','latex','FontSize',14)
axis([min(alpha) max(alpha) min(u) max(u)])
print -depsc ch7_generator_conflict.eps

% combined risk measure
function rho = myfun(u,X,kappa)
 
rho1 = myfun1(u,X);
rho2 = myfun2(u,X);
 rho = rho1 + kappa*rho2;
 
end

% risk measure 1
function rho1 = myfun1(u,X)
 
   R = max(X-u,0);
   y = 5*(R.^2) + 15*u.^2;
rho1 = mean(y);
 
end
 
% risk measure 2
function rho2 = myfun2(u,X)
 
   R = max(X-u,0);
   y = 5*(R.^2) + 15*u.^2;
rho2 = std(y);

end

% cvar
function rho3 = myfun3(u,X,alpha)
 
   R = max(X-u,0);
   y = 5*(R.^2) + 15*u.^2;
   
   Q = quantile(y,alpha);
 loc = y >= Q;
rho3 = mean(y(loc));

end


