% Victor Z
% UW-Madison, 2019
% show how to fill-up space

clc;  clear all; close all hidden; 
format short 

% specify mean and covariance 
n=50;

figure(1)
subplot(2,2,1)
rng(0)
R = unifrnd(-1,1,n,2)
scatter(R(:,1),R(:,2),'blacko','MarkerFacecolor','w')
xticks([])
yticks([])
box off

subplot(2,2,2)
rng(0)
R = unifrnd(-1,1,n,3)
scatter3(R(:,1),R(:,2),R(:,3),'blacko','MarkerFacecolor','w')
xticks([])
yticks([])
zticks([])
box off

print -dpdf domains_clouds.pdf
