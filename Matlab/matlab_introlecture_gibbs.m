clc
clear all
close all hidden

load cbe562gibbs_hightemp.dat
datahigh=cbe562gibbs_hightemp;
load cbe562gibbs_lowtemp.dat
datalow=cbe562gibbs_lowtemp;

figure(1)
subplot(2,1,1)
histogram(datahigh(:,1))
xlabel('Pressure [bar]')
ylabel('Frequency')

figure(1)
subplot(2,1,2)
histogram(datahigh(:,2))
xlabel('Extent [kmol/hr]')
ylabel('Frequency')

figure(2)
subplot(2,1,1)
histogram(datalow(:,1))
xlabel('Pressure [bar]')
ylabel('Frequency')

figure(2)
subplot(2,1,2)
histogram(datalow(:,2))
xlabel('Extent [kmol/hr]')
ylabel('Frequency')

figure(3)
subplot(2,1,1)
histogram(datalow(:,2))
hold on
histogram(datahigh(:,2))
xlabel('Extent [kmol/hr]')
ylabel('Frequency')
legend('Low Temp', 'High Temp')