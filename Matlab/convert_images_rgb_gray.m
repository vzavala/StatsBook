clc; clear all; close all hidden;

dirsource = [pwd,'/Endotoxins/RGB'];

imds = imageDatastore(dirsource, ...
    'IncludeSubfolders',true,'LabelSource','foldernames');

n=length(imds.Labels);

dirdestination = ['/Users/vzavala/Desktop/Endotoxins/Gray'];

for i=1:n
    
    fullSourceFileName = imds.Files{i};
    img = readimage(imds,i);
    label=imds.Labels(i);
    
    % Strip off extenstion from input file
     [sourceFolder, baseFileNameNoExtenstion, ext] = fileparts(fullSourceFileName);
     
    % Convert image and save
     img = rgb2gray(img);
     outputBaseName = [baseFileNameNoExtenstion, '.png'];
     fullDestinationFileName = fullfile(dirdestination,string(label),outputBaseName);
     imwrite(img,fullDestinationFileName);
    
end