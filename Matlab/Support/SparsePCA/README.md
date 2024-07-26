# Sparse PCA via Nonlinear IPM


This archive contains a Matlab implementation of Sparse PCA
using the *inverse power method for nonlinear eigenproblems (NIPM)*,
introduced in the paper [1]. To compute multiple principal components, 
the deflation scheme described in [2] is used.





## Usage

#### Computing a set of sparse loading vectors:

    F = sparsePCA(X, card, num_comp, num_runs, verbosity);

#### Input variables

    X           data matrix (num x dim)
    card        desired number of non-sparse components (cardinality) of output    
                for each principal component; card can be either a vector of size 
                num_comp x 1, or a scalar (in this case all components will have 
                the same cardinality)
    num_comp    number of principal components
    num_runs    number of additional runs of inverse power method with random 
                initialization (default: 0)
    verbosity   determines how much information is displayed (0-2, default: 1)

#### Output variables

    F           the sparse loading vectors
    adj_var     the contributions to the adjusted variance of each component
    cum_var     the cumulative adjusted variance


#### Computing all loading vectors with cardinalities in a given range:

    [cards, vars, F] = computeTradeOffCurve(X, card_min, card_max, num_runs, verbosity);

#### Input variables

    X           data matrix (num x dim)
    card_min    desired number of non-sparse components of output (cardinality)
    card_max    if specified, all vectors with cardinality values in intervall 
                [card_min,card_max] are computed (default: card_max=card_min)
    num_runs    number of runs of IPM with random initialization (default: 0)
    verbosity   determines frequency of console output (values 0-2, default: 1)

#### Output variables

    cards       the cardinalities (number of nonzeros) of the returned vectors 
    vars        the corresponding variances
    F           the sparse loading vectors


## References

[1] M. Hein and T. Bühler. 
*An Inverse Power Method for Nonlinear Eigenproblems with Applications 
in 1-Spectral Clustering and Sparse PCA*. 
Advances in Neural Information Processing Systems 23 (NIPS 2010).
Extended version available at http://arxiv.org/abs/1012.0774.

[2] T. Bühler. 
*A flexible framework for solving constrained ratio problems
in machine learning*. Ph.D. Thesis, Saarland University, 2015. 
Available at http://scidok.sulb.uni-saarland.de/volltexte/2015/6159/.	

	
## License 

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

If you use this code for your publication, please include a reference 
to the paper "An inverse power method for nonlinear eigenproblems with 
applications in 1-spectral clustering and sparse PCA".

 
## Contact

Copyright 2010-2015 Thomas Bühler and Matthias Hein (tb/hein@cs.uni-saarland.de).
Machine Learning Group, Saarland University, Germany (http://www.ml.uni-saarland.de)
