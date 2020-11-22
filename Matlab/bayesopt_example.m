% Victor Z
% UW-Madison, 2020
% bayesian optimization example
% https://www.mathworks.com/help/stats/fitrgp.html
% https://www.mathworks.com/help/stats/compactregressiongp.predict.html

clc; clear all; close all hidden

% options fmincon
opt = optimoptions('fmincon','Display','iter','Algorithm','sqp');
nit = 20;

% set initial database
N=3;
x=rand(N,2);
for i=1:N
y(i)=evalobj(x(i,:));
end
y=y';

% start bayesopt iterations
xit(1,:) = mean(x);
  yit(1) = evalobj(xit(1,:));
   datax = x;
   datay = y;
 
for k=1:nit

% train kriging model with available data
gprMdl = fitrgp(datax,datay,'KernelFunction','squaredexponential');

% determine new experiment
lb=-10*ones(2,1); ub=+10*ones(2,1);
xit(k+1,:) = fmincon(@acqfunc,xit(k,:),[],[],[],[],lb,ub,[],opt,gprMdl);

% evaluate new objective
  yit(k+1) = evalobj(xit(k+1,:));

% update database
datax=[datax; xit(k+1,:)];
datay=[datay; yit(k+1)];

end

% visualize solution
xit
yit

% define acquisition function
function acq=acqfunc(x,gprMdl)

[mu,~,msig] = predict(gprMdl,x);

 mu = mu;
sig = mu-msig(1);

acq = mu - 0.1*sig;

end


% define objective to optimize
function y = evalobj(x)

y=(x(1)-4)^2 + x(2);

end