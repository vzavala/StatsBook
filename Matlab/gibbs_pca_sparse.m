% Victor Z
% UW-Madison, 2020
% PCA analysis of gibbs reactor set
% https://www.mathworks.com/help/stats/pca.html

clc; clear all; close all hidden
addpath('InvPow_SparsePCA')  

% create data set
load ('./Data/gibbs_hightemp_class.dat')
datahigh=gibbs_hightemp_class;
load ('./Data/gibbs_lowtemp_class.dat')
datalow=gibbs_lowtemp_class;
data=[datahigh;datalow];
datan=data;
n=length(datan);

% corrupt data with noise to hide pattern 
rng(1); % For reproducibility 
x1 = datan(:,2)+randn(n,1)*0.1; % pressure 
x2 = datan(:,3)+randn(n,1)*0.1; % conversion
 y = datan(:,1)+randn(n,1)*0.1; % temperature
X=[y x1 x2];

% now let's try to get the eigenvectors without using PCA built-in function
% normalize original matrix and check that each column has zero mean
mun=mean(X);
Xn=X-mun;

% form covariance matrix
Sigma=Xn'*Xn;

% get eigenvectors and eigenvalues from covariance matrix
[W,lam]=eigs(Sigma);
lam=diag(lam);
W=W

% get principal components and visualize
T=Xn*W;


% get dense components
card=3; %number of nonzero components in eigenvectors
num_comp=3; %number of principal components
Wsparse = sparsePCA(Xn, card, num_comp, 0, 1)

% get sparse components
card=2; %number of nonzero components in eigenvectors
num_comp=3; %number of principal components
Wsparse = sparsePCA(Xn, card, num_comp, 0, 1)

% get sparser components
card=1; %number of nonzero components in eigenvectors
num_comp=3; %number of principal components
Wsparse = sparsePCA(Xn, card, num_comp, 0, 1)