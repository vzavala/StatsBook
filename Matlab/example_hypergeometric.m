% Victor Z
% UW-Madison, 2020
% example hypergeometric
clc;
clear all;
close all hidden

rng(0)       
N  = 156;     % total number of times in 3 years (population)
Nd =  79;     % total number of failures in 3 years
p=Nd/N

% case with 5 inspection times
 n =  5;     % number of times inspected
 
% probability that 5 out of 5 times it has failed
x=n; 

P = hygepdf(x,N,Nd,n)

% probability that 0 out of 5 times it has failed
x=0; 

P = hygepdf(x,N,Nd,n)


% case with 10 inspection times
 n =  10;     % number of times inspected
 
% probability that 10 out of 10 times it has failed
x=n; 

P = hygepdf(x,N,Nd,n)

% probability that 0 out of 10 times it has failed
x=0; 

P = hygepdf(x,N,Nd,n)