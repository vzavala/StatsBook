% Victor Z
% UW-Madison, 2020
% data for gibbs reactor set

clc; clear all; close all hidden

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
y=datan(:,1)+randn(n,1)*0.1;    % temperature

% visualize the data in 2d 

figure(1)

subplot(2,2,1)
scatter(x1,x2,'MarkerFaceColor','w','MarkerEdgeColor','black')
grid on
xlabel('$\textrm{Pressure [bar]}$','Interpreter','latex','FontSize',14)
ylabel('$\textrm{Conversion [-]}$','Interpreter','latex','FontSize',14)

subplot(2,2,2)
scatter(y,x2,'MarkerFaceColor','w','MarkerEdgeColor','black')
grid on
xlabel('$\textrm{Temperature [K]}$','Interpreter','latex','FontSize',14)
ylabel('$\textrm{Conversion [-]}$','Interpreter','latex','FontSize',14)

print -depsc gibbs_data.eps



