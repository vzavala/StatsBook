% Victor Z
% UW-Madison, 2020
% example binomial
clc;
clear all;
close all hidden

rng(0) 

% probability of outcome
p=0.5;

% sequence length
n=10; 

% find 2 failures
x=2; 
P = binopdf(x,n,p)

% find 10 failures
x=10; 
P = binopdf(x,n,p)

% find average
x=n*p 
P = binopdf(x,n,p)


% find 0 failures
x=0; 
P = binopdf(x,n,p)

