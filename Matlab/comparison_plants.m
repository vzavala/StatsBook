% matlab example #1
% illustration histograms, density function, and comparison of random
% variables

clc
clear all
close all hidden

% simulate data plant 1
rng(0)
mu1=100; % mean
sigma1=5; % std deviation
N=100; % number of samples
data1=normrnd(mu1,sigma1,N,1)

% simulate data plant 2
rng(0)
mu2=75; % mean
sigma2=20; % std deviation
N=100; % number of samples
data2=normrnd(mu2,sigma2,N,1)


% find parameters for normal fit of data
param1 = fitdist(data1,'normal')
param2 = fitdist(data2,'normal')

% plot data 1 as histogram & cdf
figure(1)
subplot(1,2,1)
hist(data1)
grid on
xlabel('Outcome x')
ylabel('100 x f(x)=P(X=x)')

subplot(1,2,2)
cdfplot(data1)
title("")
grid on
xlabel('Outcome x')
ylabel('P(X \leq x)')

% plot data 2 as histogram & cdf
figure(2)
subplot(1,2,1)
hist(data2)
grid on
xlabel('Outcome x')
ylabel('100 x f(x)=P(X=x)')

subplot(1,2,2)
cdfplot(data2)
title("")
grid on
xlabel('Outcome x')
ylabel('P(X \leq x)')

% compare plants
figure(3)
subplot(1,2,1)
histogram(data1,10)
hold on
histogram(data2,10)
grid on
xlabel('Outcome x')
ylabel('100 x f(x)=P(X=x)')
legend("Plant 1", "Plant 2")

subplot(1,2,2)
cdfplot(data1)
hold on
cdfplot(data2)
title("")
grid on
xlabel('Outcome x')
ylabel('P(X \leq x)')
legend("Plant 1", "Plant 2",'Location','northwest')

% summarizing statistics for both plants based on data (mean, stddev)

mean1=mean(data1)
mean2=mean(data2)

std1=std(data1)
std2=std(data2)

% summarizing statistics for both plants based on data (quantile at 95% prob)
quantile1=quantile(data1,0.5)
quantile2=quantile(data2,0.5)

% get quantile based on Gaussian fit of data
quant1=norminv(0.5,mu1,sigma1)
quant2=norminv(0.5,mu2,sigma2)
