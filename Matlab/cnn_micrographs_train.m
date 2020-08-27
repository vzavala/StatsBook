% Victor Z
% UW-Madison, 2020
% use CNN for classifying micrographs (train CNN)

clc; clear all; close all hidden;

digitDatasetPath = [pwd,'/Data/Micrographs'];

imds = imageDatastore(digitDatasetPath, ...
    'IncludeSubfolders',true,'LabelSource','foldernames');

n=length(imds.Labels);

% shuffle images to randomize
rng(0)
imds = shuffle(imds);

% select only a subset to accelerate
indices = 1:100;
imds = subset(imds,indices);

% Display some of the images in the datastore.

figure;
for i = 1:25
    subplot(5,5,i);
    imshow(imds.Files{i});
    title(imds.Labels(i))
end
print -depsc micrographs_samples.eps

% count number of points with each label

labelCount = countEachLabel(imds)

% create training and validation sets
rng(0);
[imdsTrain,imdsValidation] = splitEachLabel(imds,0.5,'randomized');

% resize images
imdsTraina = augmentedImageDatastore([60 60],imdsTrain,'ColorPreprocessing','gray2rgb')
imdsValidationa = augmentedImageDatastore([60 60],imdsValidation,'ColorPreprocessing','gray2rgb')

% define CNN architecture

layers = [
    imageInputLayer([60 60 3]) % height, width, and channel size
    
    convolution2dLayer(3,4,'Padding','same')
    batchNormalizationLayer
    reluLayer   
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,4,'Padding','same')
    batchNormalizationLayer
    reluLayer   
    
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer];

% train CNN

opts = trainingOptions('sgdm', ...
    'MaxEpochs',15, ...
    'Shuffle','every-epoch', ...
    'Plots','training-progress', ...
    'Verbose',false, ...
    'ValidationData',imdsValidationa);

%net = trainNetwork(imdsTraina,layers,opts);

load micrograph_net;
net=micrograph_net;

%micrograph_net=net;
%save micrograph_net;

% obtain validation accuracy
YPred = classify(net,imdsValidationa);
YValidation = imdsValidation.Labels;
accuracy = sum(YPred == YValidation)/numel(YValidation)

%Look At Some of The Feature Activations
figure(2)
subplot(2,2,1)
idx=1 % pick entry (water)
J = imresize(readimage(imdsTrain,idx),[60,60]);
act1 = activations(net,J,'conv_1');
I = imtile(mat2gray(act1),'GridSize',[2 2]);
imshow(I)
title(imdsTrain.Labels(idx))

subplot(2,2,2)
act2 = activations(net,J,'conv_2');
I = imtile(mat2gray(act2),'GridSize',[2 2]);
imshow(I)
title(imdsTrain.Labels(idx))

subplot(2,2,3)
idx=9 % pick entry (dmmp)
J = imresize(readimage(imdsTrain,idx),[60,60]);
act1 = activations(net,J,'conv_1');
I = imtile(mat2gray(act1),'GridSize',[2 2]);
imshow(I)
title(imdsTrain.Labels(idx))

subplot(2,2,4)
act2 = activations(net,J,'conv_2');
I = imtile(mat2gray(act2),'GridSize',[2 2]);
imshow(I)
title(imdsTrain.Labels(idx))
print -depsc micrographs_activations.eps
