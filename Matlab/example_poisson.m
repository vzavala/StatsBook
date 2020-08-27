% Victor Z
% UW-Madison, 2020
% example Poisson RV

clc; clear all; close all hidden;

rng(0);       % for reproducibility      

% generate random failure sequences

z = 30;       % days
lambda = 10;  % average occurrences per z
t = 0:1:z;    % time vector
n=length(t);  % number of times
N=3;          % number of samples

for k=1:N

m(k) = poissrnd(lambda); % number of occurrences

y = zeros(1,n);
y(1:m(k)) = 1;
y = y(randperm(n));

subplot(2,1,1)
for j=1:length(y)
if y(j)==1 %failure
    scatter(t(j),k,'blacko','MarkerFaceColor','black','MarkerEdgeColor','black') 
    hold on
else %normal
    scatter(t(j),k,'blacko','MarkerFaceColor','w','MarkerEdgeColor','black')
    hold on
end
end
grid on
axis([min(t) max(t) 0 4])
set(gca,'yticklabels',{'','Mar','Feb','Jan',''})
xlabel('$\textrm{Time [days]}$','interpreter','Latex','Fontsize',14)
box on
end

print -depsc poissprocess.eps

% compute pdf for poisson
lambdahat=mean(m);

p=poisspdf(0,lambdahat)

p=poisspdf(30,lambdahat)

p=poisspdf(11,lambdahat)