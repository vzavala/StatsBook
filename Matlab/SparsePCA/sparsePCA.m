function [F,adj_var,cum_var] = sparsePCA(X, card, num_comp, num_runs, verbosity)
% Computes multiple sparse PCA components. Each component is computed 
% using the nonlinear inverse power method described in the below paper,
% then deflation is performed.
%
% M. Hein and T. Buehler
% An Inverse Power Method for Nonlinear Eigenproblems with Applications 
% in 1-Spectral Clustering and Sparse PCA
% In Advances in Neural Information Processing Systems 23 (NIPS 2010)
% Available online at http://arxiv.org/abs/1012.0774
%
% Usage:
% F = sparsePCA(X, card, num_comp, num_runs, verbosity);
%
% X         data matrix (num x dim)
% card      desired number of non-sparse components of output (cardinality)
%           for each principal component; card can be either a vector of
%           length num_comp x 1, or a scalar (all components have same
%           cardinality)
% num_comp  number of principal components
% num_runs  number of additional runs of inverse power method with random 
%           initialization (default: 0)
% verbosity determines how much information is displayed (0-2, default: 1)
%
% F         the loading vectors
% adj_var   the contributions to the adjusted variance of each component
% cum_var   the cumulative adjusted variance
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% Copyright 2010-15 Thomas Buehler and Matthias Hein
% Machine Learning Group, Saarland University, Germany
% http://www.ml.uni-saarland.de

  proj_pc=true;
  if (nargin<5), verbosity=1; end    
  if (nargin<4), num_runs=0; end
	
  for l=1:length(card)
    assert(card(l)>0,'Wrong usage. Cardinality has to positive.');
    assert(card(l)<=size(X,2),'Wrong usage. Cardinality can not be larger than dim.');
  end
  assert(num_runs>=0,'Wrong usage. num_runs cannot be negative.');
    
  if (length(card)==1)
      card = card * ones(num_comp,1);
  else
      assert(size(card,1)==num_comp && size(card,2)==1  ,'Wrong usage. card has wrong dimension.');
  end
  
  X_cur=X;
  dim=size(X_cur,2);
  F=zeros(dim,num_comp);

  %main loop
  for l=1:num_comp
      [all_cards, all_vars, F_temp]= computeTradeOffCurve(X_cur,card(l),card(l),num_runs,verbosity);
      assert(size(F_temp,1) == dim)
      assert(size(F,1) == dim)
      assert(size(F,2) == num_comp)
      
      f=F_temp(:,end);
      F(:,l)=f;

      if verbosity>0
        fprintf('Finished computing principal component number %d. #nonzeros=%d\n',l,card(l));
      end
      
      % perform deflation with respect to principal components
      if(proj_pc)
        z=X_cur*f;
        znorm=z/norm(z);
          
        % perform deflation
        X_cur= X_cur - znorm*(znorm'*X_cur);
      else % perform deflation with respect to loading vectors
        if l>1
            q= f- Q*(Q'*f);
        else
            q=f;
        end
          
        Q(:,l)=q/norm(q); %orthonormal basis for space spanned by previous f
                   
        % perform deflation (orthogonal projection deflation)
        X_cur=X_cur-(X_cur*q)*q';
      end
  end
  [adj_var, cum_var]= adjustedVariance(F,X);

end

