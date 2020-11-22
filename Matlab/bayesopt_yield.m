% Victor Z
% UW-Madison, 2020
% bayesian optimization for extraction system
% https://www.mathworks.com/help/stats/fitrgp.html
% https://www.mathworks.com/help/stats/compactregressiongp.predict.html

clc; clear all; close all hidden

% options fmincon
opt = optimoptions('fmincon','Display','iter','Algorithm','sqp');
nit = 20;

%% set initial database 

% Box-Behnken design
% x=[ 0 -1  +1; 
%    +1  0  -1; 
%    -1  0  +1; 
%    -1  0  -1; 
%     0  0   0; 
%    -1 -1   0;
%     0  0   0; 
%     0  0   0;
%    -1 +1   0; 
%     0 -1  -1; 
%     0  1  -1; 
%     1  0   1; 
%     1  1   0; 
%     0  0   0;
%     1 -1   0;
%     0  1   1
%     0  0   0];

% naive design
x=[ 0  0   0; 
   +1 +1  +1; 
   -1 -1  -1];

N=length(x);
for i=1:N
y(i)=evalobj(x(i,:));
end
y=y'

%% start bayesopt iterations
idx=find(y==min(y));
xit(1,:) = x(idx,:);
  yit(1) = evalobj(xit(1,:));
   datax = x;
   datay = y;
 
for k=1:nit

% train kriging model with available data
gprMdl = fitrgp(datax,datay,'KernelFunction','squaredexponential');

% determine new experiment
lb=-1*ones(3,1); ub=+1*ones(3,1);
xit(k+1,:) = fmincon(@acqfunc,xit(k,:),[],[],[],[],lb,ub,[],opt,gprMdl);

% evaluate new objective
  yit(k+1,1) = evalobj(xit(k+1,:));

% update database
datax=[datax; xit(k+1,:)];
datay=[datay; yit(k+1)];

end

%% visualize solution (scale to original units)
Xopt(1)=interp1([-1,0,1],[70 85 100],xit(nit+1,1));
Xopt(2)=interp1([-1,0,1],[1 1.5 2],xit(nit+1,2));
Xopt(3)=interp1([-1,0,1],[0.1 0.2 0.3],xit(nit+1,3));

xit=xit
Xopt=Xopt'
Yopt=yit

%% plot results

figure(1)
stairs(0:nit,Yopt,'blacko-','MarkerFaceColor','w')
grid on
hold on
xlabel('$\textrm{Experiment}\; \omega$','Interpreter','latex','FontSize',14)
ylabel('$\textrm{Observed Yield}\; y_\omega$','Interpreter','latex','FontSize',14)
print -depsc bayesopt_extraction.eps



%% define acquisition function
function acq=acqfunc(x,gprMdl)

[mu,~,msig] = predict(gprMdl,x);

 mu = mu;
sig = mu-msig(1);

acq = mu - 0.1*sig;

end


%% define objective to optimize
function y = evalobj(x)

% extraction conditions
X1=x(1); X2=x(2); X3=x(3);

% extraction model
b=[16.5780
    3.8563
    0.9250
    0.4212
   -1.2840
   -0.8515
   -1.0940
   -0.1425
    0.1900
   -0.1675];
 
 y = b(1) + b(2)*X1   + b(3)*X2 + b(4)*X3 + b(5)*X1^2 + b(6)*X2^2+...
     b(7)*X3^2+ b(8)*X1*X2 + b(9)*X1*X3 + b(10)*X2*X3;

 y = -y;

end