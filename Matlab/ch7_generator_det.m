% Victor Z
% UW-Madison, 2022
% generator sizing example (deterministic solution)

clc; clear all; close all hidden;

%% generate scenarios for random load
rng(0)
N=1000;
X=wblrnd(10,2,N,1);

%% find deterministic solution
u=0:2:10;
x=max(X);

for k=1:length(u)
yd(k)=myfun(u(k),x);
end

% visualize deterministic objective against decision
figure(1)
subplot(2,2,1)
histogram(X,0:1:30,'Normalization','count','EdgeColor','black','FaceColor','white','LineWidth',1)
grid on
hold on
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$\textrm{Frequency}$','Interpreter','latex','FontSize',14)
subplot(2,2,2)
plot(u,yd,'LineWidth',1,'Color','black','LineStyle','--')
grid on
hold on
xlabel('$u$','Interpreter','latex','FontSize',14)
ylabel('$y(u)$','Interpreter','latex','FontSize',14)

% find optimal size that 
idx=find(yd==min(yd));
ud=u(idx);

% evaluate how the deterministic solution ud behaves
% when it confronts uncertainty
yd=myfun(ud,X);
subplot(2,2,3)
[F,t]=ecdf(yd);
stairs(t,F,'LineWidth',1,'Color','black','LineStyle','--')
grid on
hold on
subplot(2,2,4)
histogram(yd,0:100:3000,'Normalization','count','EdgeColor','black','FaceColor','white','LineWidth',1)
hold on

% mean
Ed = mean(yd)


%% compare against do nothing
u0=0;
y0=myfun(u0,X);

subplot(2,2,3)
[F,t]=ecdf(y0);
stairs(t,F,'LineWidth',1,'Color','black','LineStyle','-')
grid on
axis([ 0 max(y0) 0 1.05])
xlabel('$y$','Interpreter','latex','FontSize',14)
ylabel('$F(y)$','Interpreter','latex','FontSize',14)
legend('Deterministic','Do Nothing','location','southeast')
subplot(2,2,4)
histogram(y0,0:100:3000,'Normalization','count','EdgeColor','black','FaceColor','black','LineWidth',1)
grid on
legend('Deterministic','Do Nothing')
xlabel('$y$','Interpreter','latex','FontSize',14)
ylabel('$\textrm{Frequency}$','Interpreter','latex','FontSize',14)
print -depsc -r1200 ch7_generator_det.eps

% mean
E0 = mean(y0)

 function y=myfun(u,X)
 
   R = max(X-u,0);
 y = 5*(R.^2) + 15*u.^2;
 
 end