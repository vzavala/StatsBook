% Victor Z
% UW-Madison, 2019
% example discrete uniform
clc;
clear all;
close all hidden

rng(0)       
z  = 52;       % weeks
nd = 10;
t = 0:1:z;    % time vector
n=length(t);  % number of times
N=3;          % number of samples

% generate random failure sequences
ny=0;
for k=1:N

y = hygernd(z,nd,); 
y = y-1;

ny=sum(y)+ny

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
set(gca,'yticklabels',{'','Year 1 ','Year 2 ','Year 3 ',''})
xlabel('$\textrm{Time [weeks]}$','interpreter','Latex','Fontsize',14)
end

ny/(N*z)

print -depsc unifprocess.eps

