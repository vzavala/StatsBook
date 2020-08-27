% Victor Z
% UW-Madison, 2019
% npv comparison

clc
clear all
close all hidden

% compare investment strategies
rng(0)
N=1000;
ir=0.05;

% evaluate investment 1
C1=25;
ROI1=normrnd(0.5,0.1,N);
for i=1:N
    NPV1(i) = -C1 + ROI1(i)*C1*(1-(1+ir)^(-10))/ir;
end
NPV1=-NPV1;

% evaluate investment 2
C2=50;
ROI2=normrnd(0.4,0.2,N);
for i=1:N
    NPV2(i)=-C2 + ROI2(i)*C2*(1-(1+ir)^(-10))/ir;
end
NPV2=-NPV2;

% lets compare pdfs of NPV
figure(2)
subplot(2,2,1)
histogram(NPV1,'Normalization','probability')
xlabel('NPV')
ylabel('f(NPV)') 
hold on
histogram(NPV2,'Normalization','probability')
legend('Investment 1', 'Investment 2')

% lets compare cdfs of NPV
subplot(2,2,2)
cdfplot(NPV1)
xlabel('NPV')
ylabel('F(NPV)') 
hold on
cdfplot(NPV2)
xlabel('NPV')
ylabel('F(NPV)')
title('')
print -depsc comparison_NPV.eps

% get worse case
WC1=max(NPV1)
WC2=max(NPV2)

% get expected value
EV1=mean(NPV1)
EV2=mean(NPV2)

%%% assuming deterministic

% evaluate investment 1
C1=25;
ROI1=0.5;
NPV1 = -C1 + ROI1*C1*(1-(1+ir)^(-10))/ir;
NPV1=-NPV1

% evaluate investment 2
C2=50;
ROI2=0.3;
NPV2=-C2 + ROI2*C2*(1-(1+ir)^(-10))/ir;
NPV2=-NPV2


% determine optimal C such that P(NPV<=t) is large 
t=-100;

C=linspace(0,500,100)
ROI=normrnd(0.4,0.2,N);
for k=1:length(C)
for i=1:N
    NPV(i)=-C(k) + ROI(i)*C(k)*(1-(1+ir)^(-10))/ir;
end
NPV(i)=-NPV(i);

ss=0
for i=1:N
    if NPV(i)<=t
        ss=ss+1;
    end
end

Prob(k)=ss/N;
ENPV(k)=mean(NPV);
VNPV(k)=var(NPV)

end



