close all, clear all, clc, format compact
% number of samples of each class
N = 20;

% define inputs and output data
offset = 5; % offset for second class
x = [randn(2,N) randn(2,N)+offset]; % inputs
y = [zeros(1,N) ones(1,N)]; % outputs

% Plot input samples with PLOTPV (Plot perceptron input/target vectors)
figure(1)
plotpv(x,y);

% build simple network with just one perceptron

net = perceptron;
net = train(net,x,y);
view(net);

% see real outputs
y

% see predicted outputs
yp=net(x)

% plot decision boundary
figure(1)
plotpc(net.IW{1},net.b{1});

