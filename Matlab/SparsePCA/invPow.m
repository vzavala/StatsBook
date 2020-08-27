% Performs one run of the inverse power method for sparse PCA as
% described in the paper
%
% M. Hein and T. Buehler
% An Inverse Power Method for Nonlinear Eigenproblems with Applications in 1-Spectral Clustering and Sparse PCA
% In Advances in Neural Information Processing Systems 23 (NIPS 2010)
% Available online at http://arxiv.org/abs/1012.0774
%
% Usage:
% [z,lambda,var]= invPow(X,gamma,maxit,z)
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% Copyright 2010-15 Thomas Buehler and Matthias Hein
% Machine Learning Group, Saarland University, Germany
% http://www.ml.uni-saarland.de
function [z,lambda,var]= invPow(X,gamma,maxit,z)
    debug=false;
    tol=1E-5;
    [num,dim]=size(X);
    
    Xz=X * z;
    denom=norm(Xz);
    z=z/denom;
    sigmaZ= (X'*Xz)/denom;
    
    diff_lambda=inf;
    
    k=0;
       
    lambda_old=(1-gamma)*norm(z,2)+gamma*sum(abs(z));
    while (k<=maxit  && diff_lambda>tol)
        k=k+1;
        
        mu=sigmaZ*lambda_old;
        
        ix = find(abs(mu)>gamma);
        z_new = zeros(dim,1);
        z_new(ix)= mu(ix)-gamma*sign(mu(ix));
        
        if(debug)
            primalobj= (1-gamma)*norm(z_new) + gamma*norm(z_new,1) - mu'*z_new;
        end
        
        Xz=X*z_new;
        denom = norm(Xz,2);
        z=z_new/denom;
        sigmaZ= (X'*Xz)/denom;
    
        lambda=(1-gamma)*norm(z,2)+gamma*sum(abs(z));
        diff_lambda=(lambda_old-lambda)/lambda_old;
        assert(diff_lambda>=0 || abs(diff_lambda)<1E-15);
        lambda_old=lambda;
    end
    
    var=(norm(X*z)/norm(z))^2;
end  