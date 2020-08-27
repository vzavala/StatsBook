% Victor Z
% UW-Madison, 2020
% PCA estimation for Gibbs reactor

clc; clear all; close all hidden;
format bank

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

% construct input-outdata matrices
Y=data(:,2);
X=data(:,[1 3 4 5 6]);
[S,n]=size(X);
% join data (ones, pressure, flow co, flow h2, flow ch3oh, temperature)
X=[ones(S,1) X]; % add ones to introduce bias parameter
[S,n]=size(X);

% singular value decomposition
[U,S,V]=svd(X,0);

S=diag(S)'

% visualize first rows of X matrix
X(1:6,:)

eigs(X'*X)

% compute rank as we add columns
rank(X(:,1))
rank(X(:,[1:2]))
rank(X(:,[1:3]))
rank(X(:,[1:4]))
rank(X(:,[1:5]))
rank(X(:,[1:6]))