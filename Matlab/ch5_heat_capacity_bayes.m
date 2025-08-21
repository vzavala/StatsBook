% Victor Z
% UW-Madison, 2024
% estimation of heat capacity using bayes
clc; clear all; close all hidden; format short e; 

%% generate data (true model is Cp=a0+a1*T+a2*T^2)
% CP in cal/mol-K and T in K
a0=+0.6190e+1;
a1=+0.2923e-2;
a2=-0.7052e-6;
theta=[a0,a1,a2]';

% 3 sets of experiments at T=300K, T=400K, and T=500K
n=20;
N=3*n;
x1=linspace(300,300,n)';
x2=linspace(600,600,n)';
x3=linspace(900,900,n)';
 x=[x1; x2; x3];
    
% generate true outputs 
rng(0);
y1=a0+a1*x1+a2*x1.^2;
y2=a0+a1*x2+a2*x2.^2;
y3=a0+a1*x3+a2*x3.^2;
ytrue=[y1; y2; y3];

% add random noise to true outputs
sigma=0.1;
y=ytrue+normrnd(0,sigma,N,1);

% construct input and output data matrix
xsq=x.^2;
X=[ones(N,1),x,xsq];
Y=y;

% suffle data
idx = 1:1:N;
idxS = randperm(numel(idx));
X=X(idxS,:);
Y=Y(idxS);

%% formulate bayesian estimation problem (full data)

% covariance of the noise
Sigy=eye(N,N)*sigma^2;

% prior covariance 
Sigp=eye(3,3);

% base estimate 
thp=ones(3,1);

% build data structure
dat.Sigy=Sigy;
dat.Sigp=Sigp;
dat.thp=thp;
dat.X=X;
dat.Y=Y;
dat.flag=0; %ignores prior

%% solve problem
  options = optimoptions('fmincon');
  options.Display='off';
[thp] = fmincon(@myfun,ones(3,1),[],[],[],[],[],[],[],[],options,dat)

% evaluate fit on full dayaset
MSE=msefun(thp,X,Y)

% covariance of estimates
Sig_full=inv(dat.X'*inv(Sigy)*dat.X + inv(Sigp))


%% now do recursively 

% batch size
S=10;

% covariance of the noise
Sigy=eye(S,S)*sigma^2;

% initialize prior covariance 
Sigp=eye(3,3);

% initialize priot estimate 
thp=ones(3,1);

for k = 1:N/S

% build data structure
dat.Sigy=Sigy;
dat.Sigp=Sigp;
dat.thp=thp;

 in=(k-1)*S+1
out=in+S-1

dat.X=X(in:out,:);
dat.Y=Y(in:out);
dat.flag=1; 

% solve estimation problem and use solution as prior for next round
[thp] = fmincon(@myfun,ones(3,1),[],[],[],[],[],[],[],[],options,dat)

% obtain covariance of estimates and set as prior for nextround
Sigp=inv(dat.X'*inv(Sigy)*dat.X + inv(Sigp))

% evaluate fit on full dataset
MSE=msefun(thp,X,Y)



end



%% define objective function
function F=myfun(th,dummy,dat)

X=dat.X;
Y=dat.Y;
Sigy=dat.Sigy;
Sigp=dat.Sigp;
thp=dat.thp;

Yhat=X*th;

 like = 0.5*((Yhat-Y)')*inv(Sigy)*(Yhat-Y);
prior = 0.5*((th-thp)')*inv(Sigp)*(th-thp);

F = like + dat.flag*prior;

end


%% define SSE function
function MSE=msefun(theta,X,Y)

Yhat=X*theta;

MSE=mean((Yhat-Y).^2);

end

