%==========================================================================
% This script is a tutorial for understanding feature extraction from the
% VGG16 deep convolutional neural network, and how to utilize these
% features for classification
%==========================================================================
% Alex Smith and Victor Z
% UW-Madison, 2019

clc; clear all; close all hidden;

%Create Image Data Store for DMMP and Water
dir=[pwd,'/Data/Micrographs']
imds = imageDatastore(dir,'FileExtensions','.jpg','IncludeSubfolders',true,'LabelSource','foldernames');

% shuffle images to randomize
rng(0)
imds = shuffle(imds);

% select only a subset to accelerate
indices = 1:80;
imds = subset(imds,indices);

%Develop Train and Test Sets

[imdsTrain,imdsTest] = splitEachLabel(imds,0.5,'randomized');

%Lets look at what the images look like
numTrainImages = numel(imdsTrain.Labels);
idx = randperm(numTrainImages,36);
figure(1)
for i = 1:36
    subplot(6,6,i)
    I = readimage(imdsTrain,idx(i));
    imshow(I)
    if imdsTrain.Labels(i)=="DMMP"
        title("DMMP")
    else
        title("Water")
    end
end
print -depsc images_contaminants.eps

%Load in the VGG16 Network

net = vgg16;

%Run this code to visualize structure of network

%deepNetworkDesigner

%NOTE: Need to import "net" with import button, go to analze to look at
%details of each block (Should be no warnings or errors). 

%From network, you should be able to see that we need an input size of
%224x224, so we are going to augment our images so they are all this size:

inputSize = net.Layers(1).InputSize;

%Select Layer you want to obtain Features From net.Layers:

layer = 'conv1_1';
LayerNumber = 2;

%Now we extract the features from the VGG16 Network:

%Create Training Set Features

waitbar(i/length(imdsTrain.Files),'Training Extraction')

for i = 1:length(imdsTrain.Files)
   
    J = imresize(readimage(imdsTrain,i),inputSize(1:2));
    
    Act = activations(net,J,layer);
    
    %Extract Features from Conv Filters and Average Over Image
    
    for k=1:net.Layers(LayerNumber).NumFilters
        
        FeaturesTrain(i,k) = mean(mean(Act(:,:,k)));
    
    end
    
    % Update waitbar and message
    waitbar(i/length(imds.Files))
    
end

%Creating Test Set Features

waitbar(i/length(imdsTest.Files),'Testing Extraction')

for i = 1:length(imdsTest.Files)
   
    J = imresize(readimage(imdsTest,i),inputSize(1:2));
    
    Act = activations(net,J,layer);
    
    %Extract Features from Conv Filters and Average Over Image
    
    for k=1:net.Layers(LayerNumber).NumFilters
        
        FeaturesTest(i,k) = mean(mean(Act(:,:,k)));
    
    end
    
    % Update waitbar and message
    waitbar(i/length(imdsTest.Files))
    
end

%Look At Some of The Feature Activations
figure(2)
idx=length(imdsTrain.Labels) % pick last entry
J = imresize(readimage(imdsTrain,idx),inputSize(1:2));
act1 = activations(net,J,'conv1_1');
I = imtile(mat2gray(act1),'GridSize',[7 9]);
imshow(I)
 if imdsTrain.Labels(idx)=="DMMP"
        title("DMMP")
    else
        title("Water")
 end
 print -depsc images_contaminants_activations_water.eps

 
figure(3)
idx=length(imdsTrain.Labels)-1 % pick last entry minus one
J = imresize(readimage(imdsTrain,idx),inputSize(1:2));
act1 = activations(net,J,'conv1_1');
I = imtile(mat2gray(act1),'GridSize',[7 9]);
imshow(I)
 if imdsTrain.Labels(idx)=="DMMP"
        title("DMMP")
    else
        title("Water")
 end
  print -depsc images_contaminants_activations_dmmp.eps
 

%Now we want to do some classification with SVM:

[mdl,FitInfo] = fitclinear(FeaturesTrain,imdsTrain.Labels);

%Now we want to see the performance of our classifier:

[predlab] = predict(mdl,FeaturesTest);

%table(imdsTest.Label(1:10),label(1:10),score(1:10,2),'VariableNames',...
%    {'TrueLabel','PredictedLabel','Score'})

for i = 1:length(predlab)
    if predlab(i) == imdsTest.Labels(i)
        set(i) = 0;
    else 
        set(i) = 1;
        
    end
end

%Calculate Accuracy on Test Set

Accuracy = (1 - sum(set)/length(predlab))*100

figure(4)
ConfusionTrain = confusionchart(imdsTest.Labels,predlab);
xlabel('Predicted')
ylabel('True')
print -depsc images_contaminants_confusion.eps

% Lets do PCA on features to see if we can spot differences

[coeff,score,latent,~,explained,mu] = pca(FeaturesTrain);

figure(5)
x1=score(:,1);
x2=score(:,2);
label=imdsTrain.Labels;
h1 = scatter(x1(label=="DMMP"),x2(label=="DMMP"),50,'k','filled'); 
hold on
h2 = scatter(x1(label=="Water"),x2(label=="Water"),50,'r','filled'); 
     