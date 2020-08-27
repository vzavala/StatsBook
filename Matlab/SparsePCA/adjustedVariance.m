% Computes the (cumulative) adjusted variance via QR decomposition
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% Copyright 2010-15 Thomas Buehler and Matthias Hein
% Machine Learning Group, Saarland University, Germany
% http://www.ml.uni-saarland.de
function [adj_var, cum_var]= adjustedVariance(Z,X)
    
    if (size(Z,2)==1)
        adj_var = (norm(X * Z))^2;
        cum_var=adj_var;
    else
        U = X*Z;
    
        [Q,R]=qr(U);
    
        adj_var=diag(R).^2;
        cum_var=cumsum(adj_var);
    end
    
end
    
    
