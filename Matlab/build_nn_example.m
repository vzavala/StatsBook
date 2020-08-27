close all, clear all, clc, format compact

inputs = [1:6]' % input vector (6-dimensional pattern)
outputs = [1 2]' % corresponding target output vector

% create network
net = network( ...
1, ... % numInputs, number of inputs,
2, ... % numLayers, number of layers
[1; 0], ... % biasConnect, numLayers-by-1 Boolean vector,
[1; 0], ... % inputConnect, numLayers-by-numInputs Boolean matrix,
[0 0; 1 0], ... % layerConnect, numLayers-by-numLayers Boolean matrix
[0 1] ... % outputConnect, 1-by-numLayers Boolean vector
);

% View network structure
view(net);

% number of hidden layer neurons
net.layers{1}.size = 5;
% hidden layer transfer (activation) function
net.layers{1}.transferFcn = 'logsig';
view(net);

% configure network with input/output data
net = configure(net,inputs,outputs);
view(net);

% initial network response without training
initial_output = net(inputs)

% network training
net.trainFcn = 'trainlm';
net.performFcn = 'mse';
net = train(net,inputs,outputs);

% network response after training
final_output = net(inputs)