% Victor Z
% UW-Madison, 2020
% flow cytometer data

clc;  clear all; close all hidden; 

% load('./Data/flow_cytometer.dat');
% data=flow_cytometer;
% n=length(data);

load('./Data/flow_cytometer.mat')
n=length(data);
FSC=data(:,1);
SSC=data(:,2);

minFSC=min(FSC)
maxFSC=max(FSC)

minSSC=min(SSC)
maxSSC=max(SSC)

%% get joint pdf

% bin data in mxm matrix
[freqjoint,SSCedges,FSCedges]=histcounts2(SSC,FSC,'BinWidth',0.05,...
    'XBinLimits',[minSSC,maxSSC],'YBinLimits',[minFSC,maxFSC]);
mSSC=length(SSCedges)
mFSC=length(FSCedges)

 figure(1)
 subplot(2,2,1)
 plot(FSC,SSC,'blacko','MarkerFaceColor','w','MarkerSize',1)
 xlabel('$\log \textrm{FSC}$','Interpreter','latex','FontSize',14)
 ylabel('$\log \textrm{SSC}$','Interpreter','latex','FontSize',14)
 grid on
 xticks(FSCedges)
 yticks(SSCedges)
 xticklabels('')
 yticklabels('')
 axis([minFSC maxFSC minSSC maxSSC])

figure(1)
subplot(2,2,2)
c=linspace(0.99,0,64)';
C=[c,c,c];
imagesc(FSCedges,SSCedges, freqjoint)
set(gca,'YDir','normal')
 xlabel('$\log \textrm{FSC}$','Interpreter','latex','FontSize',14)
 ylabel('$\log \textrm{SSC}$','Interpreter','latex','FontSize',14)
axis([minFSC maxFSC minSSC maxSSC])
 xticks(FSCedges)
 yticks(SSCedges)
 xticklabels('')
 yticklabels('')
colormap(C)
grid on

figure(1)
subplot(2,2,[3 4])
h=histogram2(FSC,SSC,FSCedges,SSCedges,'FaceColor','flat','Normalization','count');
set(gca,'YDir','normal')
colormap(C)
xlabel('$\log \textrm{FSC}$','Interpreter','latex','FontSize',14)
ylabel('$\log \textrm{SSC}$','Interpreter','latex','FontSize',14)
zlabel('$\textrm{Frequency}$','Interpreter','latex','FontSize',14)
axis([minFSC maxFSC minSSC maxSSC 0 100])
 xticks(FSCedges)
 yticks(SSCedges)
 xticklabels('')
 yticklabels('')
print -depsc flow_cytometer_joint.eps


%% get marginal pds

[freqSSC,SSCedges]=histcounts(SSC,'BinWidth',0.05,'BinLimits',[minSSC,maxSSC]);
[freqFSC,FSCedges]=histcounts(FSC,'BinWidth',0.05,'BinLimits',[minFSC,maxFSC]);

figure(2)
subplot(2,2,1)
histogram(FSC,FSCedges,'Normalization','count','EdgeColor','black','FaceColor','none','LineWidth',1)
xlabel('$\log \textrm{FSC}$','Interpreter','latex','FontSize',14)
ylabel('\textrm{Frequency}','Interpreter','latex','FontSize',14)
grid on
axis([4 6 0 1200])

subplot(2,2,2)
histogram(SSC,SSCedges,'Normalization','count','EdgeColor','black','FaceColor','none','LineWidth',1)
ylabel('\textrm{Frequency}','Interpreter','latex','FontSize',14)
xlabel('$\log \textrm{SSC}$','Interpreter','latex','FontSize',14)
grid on
axis([3.5 6 0 1000])
print -depsc flow_cytometer_marginals.eps
