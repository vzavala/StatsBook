% Victor Z
% UW-Madison, 2020
% images are matrices

clc;  clear all; close all hidden; 
format short 

% specify mean and covariance 
mu = [0 0];
Sigma = [1 0; 0 1]; % nocorrelation

% evaluate probability density function in domain(-3,3 and -3,3)
nmesh = 10;
x1 = linspace(-3,3,nmesh); x2 = linspace(-3,3,nmesh); 
[X1,X2] = meshgrid(x1,x2); % create mesh
F = mvnpdf([X1(:) X2(:)],mu,Sigma); % pdf on mesh
F = 100*reshape(F,length(x2),length(x1));
Fc=uint8(F)

% plot pdf and confidence interval
figure(1)
subplot(2,2,1)
c=linspace(0.99,0.0,64)';
C=[c,c,c];
imagesc(Fc)
colormap(C);
set(gca,'FontSize',12)

% add noise
subplot(2,2,2)
rng(0)
F2=F+normrnd(0,1,10,10);
F2c=uint8(F2)
imagesc(F2c)
colormap(C);
set(gca,'FontSize',12)

print -depsc image_field.eps

% compute rank of matrices
rank(double(Fc))
rank(double(F2c))

% compute SVD of matrices
[U,S,V]=svd(double(Fc));

% compute SVD of matrices
[U2,S2,V2]=svd(double(F2c));

% compute rank-1 approximation of Fc  
D=U(:,1:1)*S(1:1,1:1)*V(:,1:1)'
D=uint8(D)
subplot(2,2,3)
imagesc(D)
colormap(C);
set(gca,'FontSize',12)

% compute rank-1 approximation of Fc2  
D2=U2(:,1:1)*S2(1:1,1:1)*V2(:,1:1)';
D2=uint8(D2);
subplot(2,2,4)
imagesc(D2)
colormap(C);
set(gca,'FontSize',12)
print -depsc svd_matrix_images.eps


input.data = F2c;
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
