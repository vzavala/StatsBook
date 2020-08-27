% Victor Z
% UW-Madison, 2020
% get conditional covariance to show reduction in uncertainty

clc;  clear all;  close all hidden; 
format bank 

% data order (pressure, extent, flow co, flow h2, flow ch3oh)
load('./Data/gibbs_covariance.dat')
data1=gibbs_covariance;

% perturb data with noise
data=data1+normrnd(0,0.5,250,5);

% get covariance matrix
C=cov(data)
C=C(1:2,1:2)

% get mean and extract first pair
mu=mean(data);
mu=mu(1:2)'

% the variance of conditional density is
sig2c1=(C(2,2)-C(2,1)*inv(C(1,1))*C(1,2))^2
