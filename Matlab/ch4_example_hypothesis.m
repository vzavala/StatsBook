% Victor Z
% UW-Madison, 2024
% Hypothesis testing
clc; clear all; close all hidden;

% generate observations for normal
rng(0)
S = 100;
mu=2;
sigma=1;
x = normrnd(mu,sigma,S,1);

% conduct z-test (h=1 rejects null, h=fails to reject null)
h1 = ztest(x,1,1)

% conduct KS-test
test_cdf = makedist('Normal','mu',1,'sigma',1);

h2 = kstest(x,'CDF',test_cdf)

% conduct Lilliefors test

h3=lillietest(x)