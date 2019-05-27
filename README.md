-   Network models are a useful representation of systems (Woodward et
    al. 2010).
-   Because it is not always possible to directly observe relationships
    (i.e. ecological interactions) spatial or temporal patterns of
    co-occurrence can be used to render models of interaction networks
    (Araújo et al. 2011).
-   The *conetto* implements an adaptation of the method developed by
    (Araújo et al. 2011) expanded with the application of Bayesian
    probability to generate network models and provides several
    functions useful for comparative analysis of sets of co-occurrence
    based networks.

Install
=======

Currently, the package is still in beta but it can be installed via the
*devtools* package.

    install.packages("devtools")
    devtools::install_github("ECGen/coNet")

Example
=======

The basic usage of the *connetto* package is to generate network models.
To do this, we need a matrix of co-occurrence values, which will be
passed into the `coNet` function:

    A <- c(1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1)
    B <- c(1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1)
    C <- c(1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1)
    D <- c(0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0)
    M <- data.frame(A, B, C, D)
    coNet(M)

    ##           A         B          C          D
    ## A 0.0000000 0.4090909  0.0000000  0.0000000
    ## B 0.2922078 0.0000000  0.0000000  0.0000000
    ## C 0.0000000 0.0000000  0.0000000 -0.3181818
    ## D 0.0000000 0.0000000 -0.4370629  0.0000000

The `coNet` function returns of square matrix with the same number of
rows and columns equal to the number of columns in the co-occurrence
matrix. There are a couple of features that are useful to note here:

-   First, the matrix is not symetric, that is, the top and bottom
    halves are not equal. This is because the dependency of two
    variables is based on both their independent occurrences and their
    co-occurrences.
-   Also, some of the values in the network are zero. This is because
    `coNet` conducts a test that compares the observed co-occurrences to
    a theoretical "null" co-occurrence interval. If the observed
    co-occurrences are within the interval, the conditional probability
    is set equal to the joint probability. The threshold for the null
    interval test can be adjusted using the *ci.p* argument (DEFAULT =
    95).
-   Last, some values are negative. This is because the network is
    comprised of the difference between the threshold adjusted
    conditional probabilities minus the observed joint probabilities
    (i.e. *P(A|B) - P(A,B)*). Therefore, if the conditional probability
    is less than the observed joint probability, the resulting
    "relative" value will be negative, while the oposite results in a
    positive value for the network. The "raw", un-relativized, values
    can be returned via the *raw* argument.

Network comparisons
-------------------

The `coNet` function was developed for the analysis of replicated
datasets, where multiple networks have been observed. Two other
functions were written to provide a way to analyze these network sets.

One function, `meanNet`, will calculate the "mean" or average of a set
of networks. The resul is the cell-wise summation of all matrices
divided by the total number of matrices. This function requires that the
set of networks all have the same dinensionaity and that they are
organized into a list.

    net.l <- lapply(1:10, function(x) matrix(runif(100), nrow = 10))
    meanNet(net.l)

    ##              [,1]        [,2]        [,3]        [,4]        [,5]
    ##  [1,] 0.011470203 0.008912662 0.008699060 0.008558717 0.007527885
    ##  [2,] 0.011795746 0.009821578 0.009583793 0.006191786 0.009631281
    ##  [3,] 0.009235267 0.011730530 0.009584768 0.006307902 0.008825257
    ##  [4,] 0.013106830 0.008191280 0.011803261 0.007350079 0.008705289
    ##  [5,] 0.010992779 0.013162659 0.010739828 0.010779388 0.008844658
    ##  [6,] 0.010845213 0.009047543 0.009293344 0.009002645 0.009602016
    ##  [7,] 0.009201801 0.009202980 0.011491353 0.011477969 0.010715238
    ##  [8,] 0.010212721 0.010377775 0.009206959 0.010396569 0.009832462
    ##  [9,] 0.014632893 0.010590662 0.008286780 0.006919968 0.013984547
    ## [10,] 0.008717699 0.009383869 0.011099898 0.009662004 0.011092111
    ##              [,6]        [,7]        [,8]        [,9]       [,10]
    ##  [1,] 0.013337228 0.015487771 0.008948011 0.009307121 0.008178073
    ##  [2,] 0.012584632 0.011484549 0.009860737 0.008966573 0.008450599
    ##  [3,] 0.009003541 0.011525584 0.012614740 0.009372622 0.007874979
    ##  [4,] 0.009161371 0.011253833 0.010705823 0.006109570 0.006438881
    ##  [5,] 0.011587151 0.009237962 0.011455079 0.011545517 0.010176229
    ##  [6,] 0.010335947 0.011244433 0.009997725 0.013744458 0.010822752
    ##  [7,] 0.012166506 0.008423511 0.008778231 0.008535473 0.007406676
    ##  [8,] 0.009526705 0.008394695 0.010632284 0.010416194 0.010686817
    ##  [9,] 0.010794560 0.008683500 0.010696452 0.010203321 0.007848211
    ## [10,] 0.009670585 0.008670731 0.011060216 0.009077528 0.011684811

Another function, `distNet`, facilitates the calculation of a distance
matrix for a set of networks. Two metrics are provided, Euclidean and
Bray-Curtis. The resulting matrix is the distance among all networks in
the set. Similar to `meanNet`, `distNet` requires that all matrices have
the same dimensionality. The result is a distance, or dissimilarity in
the case of Bray-Curtis, matrix that can now be used for multivariate
analyses, such as ordination.

    net.d <- distNet(net.l)
    net.d

    ##           1        2        3        4        5        6        7        8
    ## 2  3.685185                                                               
    ## 3  4.103205 4.910108                                                      
    ## 4  4.059925 5.415959 3.906642                                             
    ## 5  3.811321 4.191372 3.469238 4.073549                                    
    ## 6  4.104992 4.984178 4.144367 3.910250 3.948777                           
    ## 7  4.067339 4.372368 4.201779 4.498542 3.636921 4.073480                  
    ## 8  3.995967 4.986629 3.666242 3.853520 3.671780 3.618621 4.234356         
    ## 9  4.212206 5.327500 4.183762 3.635437 4.098204 3.637159 5.168281 3.789417
    ## 10 4.443790 4.238941 4.026266 4.512098 4.135276 3.711632 3.877616 4.065636
    ##           9
    ## 2          
    ## 3          
    ## 4          
    ## 5          
    ## 6          
    ## 7          
    ## 8          
    ## 9          
    ## 10 4.598224

References
==========

Araújo, Miguel B., Alejandro Rozenfeld, Carsten Rahbek, and Pablo A.
Marquet. 2011. “Using species co-occurrence networks to assess the
impacts of climate change.” *Ecography* 34: 897–908.

Woodward, Guy, Jonathan P Benstead, Oliver S Beveridge, Julia Blanchard,
Thomas Brey, Lee E Brown, Wyatt F Cross, et al. 2010. “Ecological
Networks in a Changing Climate.”
doi:[10.1016/S0065-2504(10)42002-4](https://doi.org/10.1016/S0065-2504(10)42002-4).
