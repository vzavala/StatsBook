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

 figure(1)
 plot(FSC,SSC,'blacko','MarkerFaceColor','w','MarkerSize',1)
 xlabel('$\log \textrm{FSC}$','Interpreter','latex','FontSize',16)
 ylabel('$\log \textrm{SSC}$','Interpreter','latex','FontSize',16)
 set(gca,'FontSize',16)
 hold on

% bin data in mxm matrix
m=3;
[freq,SSCedges,FSCedges]=histcounts2(SSC,FSC,m)

jointpdf=freq/n;

for i=1:m+1
    xx=linspace(min(FSCedges),max(FSCedges),100);
    plot(xx,SSCedges(i)*ones(100,1),'black--')
    hold on
end
for j=1:m+1
    yy=linspace(min(SSCedges),max(SSCedges),100);
    plot(FSCedges(j)*ones(100,1),yy,'black--')
end
 xticks(FSCedges)
 yticks(SSCedges)
 axis([min(FSCedges) max(FSCedges) min(SSCedges) max(SSCedges)])

print -depsc flow_cytometer_data.eps

%% get marginal pdfs
[freqmargFSC,FSCedgesmarg]=histcounts(FSC,m);

marFSC=freqmargFSC/n

[freqmargSSC,SSCedgesmarg]=histcounts(SSC,m);

marSSC=freqmargSSC/n

figure(2)
subplot(2,2,2)
plot(FSC,SSC,'blacko','MarkerFaceColor','w','MarkerSize',1)
xlabel('$\log \textrm{FSC}$','Interpreter','latex','FontSize',16)
ylabel('$\log \textrm{SSC}$','Interpreter','latex','FontSize',16)
set(gca,'FontSize',14)
hold on
for i=1:m+1
    xx=linspace(min(FSCedges),max(FSCedges),100);
    plot(xx,SSCedges(i)*ones(100,1),'black--')
    hold on
end
 xticks(FSCedges)
 yticks(SSCedges)
 axis([min(FSCedges) max(FSCedges) min(SSCedges) max(SSCedges)])

subplot(2,2,1)
plot(FSC,SSC,'blacko','MarkerFaceColor','w','MarkerSize',1)
xlabel('$\log \textrm{FSC}$','Interpreter','latex','FontSize',16)
ylabel('$\log \textrm{SSC}$','Interpreter','latex','FontSize',16)
set(gca,'FontSize',14)
hold on
for j=1:m+1
    yy=linspace(min(SSCedges),max(SSCedges),100);
    plot(FSCedges(j)*ones(100,1),yy,'black--')
end
 xticks(FSCedges)
 yticks(SSCedges)
 axis([min(FSCedges) max(FSCedges) min(SSCedges) max(SSCedges)])

print -depsc flow_cytometer_data_marg.eps

%% get conditional pdf for FSC 

for i=1:m % span SSC
    
    for j=1:m % span FSC
        
condFSC(i,j)=jointpdf(i,j)/marSSC(i);

    end
    
end

%% get conditional pdf for SSC 

for i=1:m % span SSC
    
    for j=1:m % span FSC
        
condSSC(i,j)=jointpdf(i,j)/marFSC(j);

    end
    
end