% Finds the optimal variance for a given sparsity pattern ind	
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% Copyright 2010-15 Thomas Buehler and Matthias Hein
% Machine Learning Group, Saarland University, Germany
% http://www.ml.uni-saarland.de
function [z, var]=optimizeVariance(X,ind)
    tol = 1E-8;

    num_comp=sum(ind);
    if (num_comp==1)
        z=double(ind);
        var = (norm(X(:,ind)))^2;
    else
        X2=X(:,ind);
        z_temp = randn(num_comp,1);
        
        diff = inf;
        while diff > tol
            y = X2 * z_temp;
            z_temp_new = X2'* y;
            z_temp_new= z_temp_new / norm(z_temp_new);
            
            diff = norm(z_temp-z_temp_new);
            z_temp=z_temp_new;
        end 
        var = (norm(X2 * z_temp))^2;
        
        z=zeros(size(X,2),1);
        z(ind)=z_temp;
    end
end