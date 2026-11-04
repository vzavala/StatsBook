% Computes the sparse PCA components using the nonlinear inverse power
% method (NIPM), as described in the paper
%
% M. Hein and T. Buehler
% An Inverse Power Method for Nonlinear Eigenproblems with Applications 
% in 1-Spectral Clustering and Sparse PCA
% In Advances in Neural Information Processing Systems 23 (NIPS 2010)
% Available online at http://arxiv.org/abs/1012.0774
%
% Usage:
% [cards, vars, Z] = computeTradeOffCurve(X, card_min, card_max, num_runs, verbosity);
%
% X         data matrix (num x dim)
% card_min  desired number of non-sparse components of output (cardinality)
% card_max  if specified, all vectors with cardinality values in intervall 
%           [card_min,card_max] are computed (default: card_max=card_min)
% num_runs  number of runs of inverse power method with random 
%           initialization (default: 0)
% verbosity determines frequency of console output (values 0-2, default: 1)
%
% cards     the cardinalities (number of nonzero components) of the 
%           returned vectors 
% vars      the corresponding variances
% Z         the sparse principal components
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% Copyright 2010-15 Thomas Buehler and Matthias Hein
% Machine Learning Group, Saarland University, Germany
% http://www.ml.uni-saarland.de
function [cards, vars, Z]= computeTradeOffCurve(X, card_min, card_max, num_runs, verbosity)

    if (nargin<5), verbosity=1; end
    if (nargin<4), num_runs=0; end
    if (nargin<3), card_max=card_min; end

    assert(card_min>0,'Wrong usage. Cardinality has to positive.');
    assert(card_max>=card_min,'Wrong usage. card_max cannot be smaller than card_min.');
    assert(num_runs>=0,'Wrong usage. num_runs cannot be negative.');
    assert(card_max<=size(X,2),'Wrong usage. Cardinality can not be larger than dim.');

    [num,dim]=size(X);
    gam_left=0;
    gam_right=1;

    % compute startvector
    norm_a_i=zeros(dim,1);
    for i=1:dim, norm_a_i(i)=norm(X(:,i)); end
    [rho_max,i_max]=max(norm_a_i);
    start1=zeros(dim,1);
    start1(i_max)=1;

    % output
    results.cards=zeros(card_max-card_min+1,1);
    results.gammas=zeros(card_max-card_min+1,1);
    results.vars=zeros(card_max-card_min+1,1);
    results.Z=zeros(dim,card_max-card_min+1);
    results.lambdas=zeros(card_max-card_min+1,1);
    results.found_cards=zeros(card_max-card_min+1,1);
    
    card0=round((card_max+card_min)/2);

    % searches for a vector with cardinality card0 via binary search (and
    % stores the solutions for other cardinalities it finds along the way)
    results = binSearch(results, X, card0, gam_left, gam_right, ... 
        num_runs, start1, card_min, card_max, verbosity);
   
    % repeat this until all gaps are filled
    ix1=find(results.found_cards==0,1);
    while(~isempty(ix1))
        card_min_temp=card_min-1+ix1;
        if(card_min_temp>card_min)
            gam_right=results.gammas(card_min_temp-card_min);
        else 
            gam_right= 1;
        end

        ix2=find(results.found_cards(ix1:end)>0,1);
        if(~isempty(ix2))
            if results.found_cards(ix2)<inf
                card_max_temp=card_min-1+ix1-1+ix2-1;
                gam_left=results.gammas(card_max_temp-card_min+2);
            else
                card_max_temp=card_min-1+ix1-1+ix2-1;
                gam_left=0;
            end
        else
            card_max_temp=card_max;
            gam_left=0;
        end
        
        card0=round((card_max_temp+card_min_temp)/2);

        if (verbosity>1)
            fprintf('card_min_temp= %d card_max_temp= %d gam_left=%.5g gam_right=%.5g\n',card_min_temp,card_max_temp,gam_left,gam_right);
        end

        results = binSearch(results, X, card0, gam_left, gam_right, num_runs, ... 
            start1, card_min, card_max, verbosity);
     
        ix1=find(results.found_cards==0,1);
    end

    results = postProcess(results,X,card_min,card_max,num_runs,verbosity);
    
    cards=results.cards;
    vars=results.vars;
    Z=results.Z;
    
end


% perform sparse PCA with current value of gamma
function [z, var_new, card_new, lambda_new] = performOneRun(X, gam, maxit, start)
    [z,lambda_new] = invPow(X,gam,maxit,start);
    ind_z=abs(z)>0;
    card_new = sum(ind_z);
    [z,var_new] = optimizeVariance(X,ind_z);
end


% perform sparse PCA with current value of gamma - one run initialized with
% start1 and num_runs random initalizations
function [Z, vars, cards, lambdas, best_card] = performMultipleRuns(X, gam, maxit, start1, num_runs)
    [num,dim]=size(X);
    [Z, vars, cards, lambdas] = performOneRun(X,gam,maxit,start1);

    % keep track of the cardinality corresponding to smallest lambda
    best_lambda = lambdas;
    best_card = cards;

    for l=1:num_runs
        start = randn(dim,1);
        [z, var_new, card_new, lambda_new] = performOneRun(X,gam,maxit,start);

        %find the best variance
        already_seen = false;
        for i = 1:length(cards)
            if cards(i) == card_new
                already_seen = true;
                if var_new > vars(i)
                    vars(i) = var_new;
                    Z(:,i) = z;
                    lambdas(i) = lambda_new;
                end
            end
        end

        % append if cardinality has not been seen before
        if ~already_seen
            Z = [Z z];
            vars = [vars var_new];
            cards = [cards card_new];
            lambdas = [lambdas lambda_new];
        end

        % keep track of the cardinality corresponding to smallest lambda
        if lambda_new < best_lambda
            best_lambda = lambda_new;
            best_card = card_new;
        end
    end
end


% searches for a vector with cardinality card0 via binary search (and
% stores the solutions for other cardinalities it finds along the way)
function results = binSearch(results, X, card0, gam_left, gam_right, num_runs, ... 
    start1, card_min_global, card_max_global, verbosity)

    maxit=100;
    epsilon=1E-6;
    isFound=false;
    splitpoint=0.5;
    gam=splitpoint*gam_left+(1-splitpoint)*gam_right;

    while (~isFound && gam_right-gam_left>epsilon)
        [Z_tmp, vars_tmp, cards_tmp, lambdas_tmp, best_card] = performMultipleRuns(X,gam, maxit,start1,num_runs);

        % consider the cardinality corresponding to smallest lambda
        if card0 == best_card
            isFound = true;
        else
            % update gamma boundaries
            if (best_card > card0)
                gam_left = gam;
            elseif (best_card < card0)
                gam_right = gam;
            end
        end

        % discard all values which are outside the cardinality range
        ind = find(cards_tmp >= card_min_global & cards_tmp <= card_max_global);

        if(verbosity>1)
            ind2 =find(cards_tmp < card_min_global | cards_tmp > card_max_global);
            if(~isempty(ind2))
                for l=1:length(ind2)
                    fprintf('Skipping solution with cardinality %d\n',cards_tmp(ind2(l)));
                end
            end
        end

        cards_tmp = cards_tmp(ind);
        vars_tmp = vars_tmp(ind);
        Z_tmp = Z_tmp(:,ind);
        lambdas_tmp = lambdas_tmp(ind);

        % store best results
        for l=1:length(cards_tmp)
            cur_card = cards_tmp(l);
            cur_var = vars_tmp(l);

            if cur_card == best_card
                results.found_cards(best_card-card_min_global+1) = best_card;
            end

            if results.vars(cur_card-card_min_global+1) < cur_var

                if verbosity>1
                    if (results.cards(cur_card-card_min_global+1)==0)
                        fprintf('Found solution with cardinality %d\n',cur_card);
                    else
                        fprintf('Improved solution with cardinality %d\n',cur_card);
                    end
                end
                results.cards(cur_card-card_min_global+1) = cur_card;
                results.vars(cur_card-card_min_global+1) = cur_var;
                results.Z(:,cur_card-card_min_global+1) = Z_tmp(:,l);
                results.gammas(cur_card-card_min_global+1,:) = gam;
                results.lambdas(cur_card-card_min_global+1) = lambdas_tmp(l);
            end
        end
        gam=splitpoint*gam_left+(1-splitpoint)*gam_right;

        if(verbosity>1)
            fprintf('gam_left= %.3g gam=%.3g gam_right= %.3g gam_right-gam_left =%.3g best_card=%d card0=%d\n', ...
            gam_left,gam,gam_right,gam_right-gam_left,best_card,card0);
        end
    end

    % if no vector with cardinality card0 could be found, set entry to inf
    if(~isFound)
        % (might have been found as suboptimal solution)
        if results.cards(card0-card_min_global+1)==0
            results.cards(card0-card_min_global+1)=Inf;
            results.vars(card0-card_min_global+1)=Inf;
        end
        if verbosity>1
            fprintf('Skipping solution with cardinality %d\n',card0);
        end
        results.found_cards(card0-card_min_global+1)=inf;
    end
end

% fill gaps and make sure the variance is monotonically increasing
function results=postProcess(results,X,card_min,card_max,num_runs,verbosity)

    dim=size(X,2);
    isChanging=true;
    vars_old=results.vars;
    while(isChanging)
        % check if variance is monotonically increasing
        cur_var=results.vars(1);
        curz=results.Z(:,1);
        % special treatment of first entry
        if(results.cards(1)==inf)
                % greedily add the components with highest variance
                norm_a_i=zeros(dim,1);
                for i=1:dim, norm_a_i(i)=norm(X(:,i)); end
                [norm_sorted,sort_ind]=sort(norm_a_i,'descend');
                pattern=zeros(dim,1);
                pattern(sort_ind(1:card_min))=1;
                [z, new_var2]=optimizeVariance(X,logical(pattern));

                results.vars(1)=new_var2;
                results.Z(:,1)=z;
                results.cards(1)=sum(pattern);
                assert(results.cards(1)==card_min)

                % check if we find something better via invpow
                gam_left=0;
                gam_right=1;
                
                results = binSearch(results, X, card_min, gam_left, gam_right, ... 
                    num_runs, z, card_min, card_max, verbosity);
        end
        for k=2:length(results.vars)
            new_var=results.vars(k);
            if(new_var<cur_var || results.cards(k)==inf)
                % take sparsity pattern from previous one + add one nonzero
                % component -> increasse in variance guaranteed
                norm_a_i=zeros(dim,1);
                pattern =  abs(curz)>0;
                ind=find(pattern==0);
                temp=X*curz;temp=temp/norm(temp);
                for i=1:length(ind),
                    norm_a_i(ind(i))=(X(:,ind(i))'*temp)^2;
                end
                [rho_max,i_max]=max(norm_a_i);
                pattern(i_max)=1;
                [z, new_var2]=optimizeVariance(X,pattern);

                results.vars(k)=new_var2;
                results.Z(:,k)=z;
                results.cards(k)=sum(pattern);

                % check if we find something better via invpow
                card0=card_min-1+k;
                gam_left=0;
                gam_right=1;
                
                results = binSearch(results, X, card0, gam_left, gam_right, ... 
                    num_runs, z, card_min, card_max, verbosity);
            end
            cur_var=results.vars(k);
            curz=results.Z(:,k);
        end
        
        for k=1:length(results.vars)
            assert(results.vars(k)<Inf)
            assert(results.cards(k)==card_min-1+k)
        end

        if  norm(results.vars-vars_old,inf)/norm(results.vars(results.vars<inf),inf)< 1E-15
            isChanging=false;
        end
        if verbosity>1
            fprintf('isChanging=%d  normdiff=%.15g\n',isChanging,norm(results.vars-vars_old,inf));
        end
        vars_old=results.vars;
    end

    if verbosity>1
        isDecreasing=false;
        cur_var=results.vars(1);
        for k=2:length(results.vars)
            new_var=results.vars(k);
            if new_var< cur_var 
                isDecreasing=true;
            end
            cur_var=new_var;
        end
        fprintf('isChanging=%d isDecreasing=%d \n',isChanging,isDecreasing);
    end	
end
