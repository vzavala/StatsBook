% Victor Z
% UW-Madison, 2020
% illustrate 2D Gauss filter
clc;  clear all; close all hidden; 
format short 

% specify mean and covariance 
mu = [0 0];
Sigma = [2 0; 0 2]; % nocorrelation

% evaluate probability density function in domain(-3,3 and -3,3)
nmesh = 10;
x1 = linspace(-3,3,nmesh); x2 = linspace(-3,3,nmesh); 
[X1,X2] = meshgrid(x1,x2); % create mesh
F = mvnpdf([X1(:) X2(:)],mu,Sigma); % pdf on mesh
F = reshape(F,length(x2),length(x1));

Fc=round(100*F)

figure(1)
c=linspace(0.99,0.0,64)';
C=[c,c,c];
imagesc(100*F)
colormap(C);
set(gca,'FontSize',14)
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
print -depsc 2DGaussianfield.eps

input.data = Fc;
input.dataFormat = {'%.0f'};
input.makeCompleteLatexDocument = 1;
latex = latexTable(input);

% save LaTex code as file
fid=fopen('MyMatrix.tex','w');
[nrows,ncols] = size(latex);
for row = 1:nrows
    fprintf(fid,'%s\n',latex{row,:});
end
fclose(fid);


