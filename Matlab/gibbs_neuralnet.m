% Victor Z
% UW-Madison, 2020
% NN prediction for gibbs data
% https://www.mathworks.com/help/deeplearning/gs/fit-data-with-a-neural-network.html#f9-33554

clc; clear all; close all hidden

% create data set
load ('./Data/gibbs_hightemp_class.dat')
datahigh=gibbs_hightemp_class;
load ('./Data/gibbs_lowtemp_class.dat')
datalow=gibbs_lowtemp_class;
data=[datahigh;datalow];
n=length(data);

rng(0)
inputs=data(:,1:2)'+rand(2,n)*0.1; % temperature and pressure
targets=data(:,3)'+rand(1,n)*0.1;   % yield

% construct simple NN
% The default network for function fitting (or regression) problems, fitnet
% is a feedforward network with the default tan-sigmoid transfer function 
% in the hidden layer and linear transfer function in the output layer. 
% The network has one output neuron, because there is only one target value 
% associated with each input vector.

hiddenLayerSize = 2;
net = fitnet(hiddenLayerSize);
net.divideParam.trainRatio = 1.0;
net.divideParam.valRatio = 0;
net.divideParam.testRatio = 0;

[net, tr] = train(net, inputs, targets);
outputs = net(inputs);
errors = gsubtract(targets, outputs);
performance = perform(net, targets, outputs);
eps2=errors;

% compare against gpr
gprMdl = fitrgp(inputs',targets','KernelFunction','squaredexponential')
[outputsgpr,outputsd,outputsci] = predict(gprMdl,inputs');
eps=targets'-outputsgpr;

% plot fit
figure(1)
subplot(2,2,1)
xx=linspace(0,1.1)
plot(targets,outputsgpr,'blacko','MarkerFaceColor','w')
grid on
hold on
plot(xx,xx,'black-')
xlabel('$y_\omega$','Interpreter','latex','FontSize',14)
ylabel('$\hat{y}_\omega$','Interpreter','latex','FontSize',14)
axis([0,1.1,0,1.1])

subplot(2,2,2)
plot(targets,outputs,'blacko','MarkerFaceColor','w')
hold on
grid on
plot(xx,xx,'black-')
xlabel('$y_\omega$','Interpreter','latex','FontSize',14)
ylabel('$\hat{y}_\omega$','Interpreter','latex','FontSize',14)
axis([0,1.1,0,1.1])
print -depsc benchmark_gibbs_kriging_NN.eps

% % compare benchmark using cdfs of residuals
% figure(1)
% subplot(3,3,3)
% [F1,X1]=ecdf(abs(eps));
% [F2,X2]=ecdf(abs(eps2));
% stairs(X1,F1,'-','LineWidth',1.5)
% hold on
% stairs(X2,F2,'-','LineWidth',1.5)
% grid on
% axis([0,0.1,0,1.01])
% xlabel('$t$','Interpreter','latex')
% ylabel('$P(\epsilon\leq t)$','Interpreter','latex')
% legend('Kriging','Neural Net','Location','southeast')
% print -depsc benchmark_gibbs_kriging_NN.eps
% 
% % compare benchmark using cdfs of residuals
% figure(4)
% subplot(2,2,1)
% hist(abs(eps))
% legend('Kriging','Location','northeast')
% grid on
% xlabel('$t$','Interpreter','latex')
% ylabel('$S\times P(\epsilon=t)$','Interpreter','latex')
% axis([0 0.1 0 120])
% subplot(2,2,2)
% hist(abs(eps2))
% legend('Neural Net','Location','northeast')
% grid on
% xlabel('$t$','Interpreter','latex')
% ylabel('$S\times P(\epsilon=t)$','Interpreter','latex')
% axis([0 0.1 0 120])
% print -depsc benchmark_gibbs_kriging_NN_pdf.eps




