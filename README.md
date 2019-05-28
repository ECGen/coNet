<!-- README.md is generated from README.Rmd. Please edit that file -->
coNet
=====

<!-- # ijtiff  <img src="man/figures/logo.png" height="140" align="right"> -->
<!-- Code status -->
[![Build
Status](https://travis-ci.org/ECGen/conetto.svg?branch=master)](https://travis-ci.org/ECGen/conetto)
[![Build
Status](https://travis-ci.org/ECGen/conetto.svg?branch=dev)](https://travis-ci.org/ECGen/conetto)

<!-- R status -->
<!-- [![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/conetto)](https://cran.r-project.org/package=conetto) -->
<!-- ![RStudio CRAN downloads](http://cranlogs.r-pkg.org/badges/grand-total/conetto) -->
<!-- ![RStudio CRAN monthly downloads](http://cranlogs.r-pkg.org/badges/conetto) -->
<!-- [![Rdocumentation](http://www.rdocumentation.org/badges/version/conetto)](http://www.rdocumentation.org/packages/conetto) -->
<!-- Dev status -->
[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip)
[![lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)

<!-- <\!-- Package Review -\-> -->
<!-- [![](https://badges.ropensci.org/300_status.svg)](https://github.com/ropensci/onboarding/issues/300) -->
<!-- [![status](http://joss.theoj.org/papers/334d80d5508056dc6e7e17c6fd3ed5a6/status.svg)](http://joss.theoj.org/papers/334d80d5508056dc6e7e17c6fd3ed5a6) -->
<!-- <\!-- Archiving -\-> -->
<!-- [![DOI](https://zenodo.org/badge/102645585.svg)](https://zenodo.org/badge/latestdoi/102645585) -->
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

The basic usage of the *conetto* package is to generate network models.
To do this, we need a matrix of co-occurrence values, which will be
passed into the `coNet` function:

    A <- c(1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1)
    B <- c(1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1)
    C <- c(1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1)
    D <- c(0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0)
    M <- data.frame(A, B, C, D)
    coNet(M)
    #>           A         B          C          D
    #> A 0.0000000 0.4090909  0.0000000  0.0000000
    #> B 0.2922078 0.0000000  0.0000000  0.0000000
    #> C 0.0000000 0.0000000  0.0000000 -0.3181818
    #> D 0.0000000 0.0000000 -0.4370629  0.0000000

The `coNet` function returns of square matrix with the same number of
rows and columns equal to the number of columns in the co-occurrence
matrix. There are a couple of features that are useful to note here:

-   First, the matrix is not symmetric, that is, the top and bottom
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
    "relative" value will be negative, while the opposite results in a
    positive value for the network. The "raw", un-relativized, values
    can be returned via the *raw* argument.

Network comparisons
-------------------

The `coNet` function was developed for the analysis of replicated
datasets, where multiple networks have been observed. Two other
functions were written to provide a way to analyze these network sets.

One function, `meanNet`, will calculate the "mean" or average of a set
of networks. The result is the cell-wise summation of all matrices
divided by the total number of matrices. This function requires that the
set of networks all have the same dimensionality and that they are
organized into a list.

    net.l <- lapply(1:10, function(x) matrix(runif(100), nrow = 10))
    meanNet(net.l)
    #>              [,1]        [,2]        [,3]        [,4]        [,5]
    #>  [1,] 0.011925199 0.012059462 0.007362976 0.013136428 0.008531698
    #>  [2,] 0.012269537 0.007459328 0.009484167 0.008180385 0.012027616
    #>  [3,] 0.009357091 0.013099752 0.010679847 0.007776129 0.007899959
    #>  [4,] 0.010976843 0.007764211 0.012033344 0.009928008 0.010547505
    #>  [5,] 0.009755056 0.010850444 0.005195883 0.009631920 0.011152215
    #>  [6,] 0.010801694 0.009714833 0.008592533 0.009003186 0.011373885
    #>  [7,] 0.011072457 0.008319544 0.012819159 0.009028809 0.010579306
    #>  [8,] 0.007567914 0.007575848 0.011085289 0.009738816 0.010148237
    #>  [9,] 0.008426937 0.009538864 0.014105669 0.008378551 0.008653160
    #> [10,] 0.010860360 0.009176083 0.007745048 0.010026654 0.013252262
    #>              [,6]        [,7]        [,8]        [,9]       [,10]
    #>  [1,] 0.008999049 0.011437284 0.008400142 0.007213329 0.012995198
    #>  [2,] 0.008910517 0.013517969 0.009791315 0.009546631 0.010356244
    #>  [3,] 0.009365705 0.011976372 0.010949289 0.006962665 0.008038372
    #>  [4,] 0.012039764 0.007805574 0.012756370 0.010291163 0.010497061
    #>  [5,] 0.008757137 0.013133132 0.010290494 0.007164220 0.009048236
    #>  [6,] 0.011242745 0.008139384 0.010521274 0.011028260 0.008674345
    #>  [7,] 0.009723805 0.009444477 0.009774805 0.011505433 0.008420383
    #>  [8,] 0.010709598 0.010586706 0.012387549 0.009767367 0.008239512
    #>  [9,] 0.010003455 0.009750125 0.010661707 0.011550489 0.009282591
    #> [10,] 0.010046290 0.013341274 0.007444317 0.011448963 0.009391811

Another function, `distNet`, facilitates the calculation of a distance
matrix for a set of networks. Two metrics are provided, Euclidean and
Bray-Curtis. The resulting matrix is the distance among all networks in
the set. Similar to `meanNet`, `distNet` requires that all matrices have
the same dimensionality. The result is a distance, or dissimilarity in
the case of Bray-Curtis, matrix that can now be used for multivariate
analyses, such as ordination.

    net.d <- distNet(net.l)
    net.d
    #>           1        2        3        4        5        6        7        8
    #> 2  5.489187                                                               
    #> 3  4.352817 4.596120                                                      
    #> 4  4.437816 3.671405 4.318075                                             
    #> 5  3.862560 4.074565 4.602765 3.905432                                    
    #> 6  4.023902 3.934514 3.839549 3.403853 3.047458                           
    #> 7  4.631788 4.405867 4.676913 4.232775 2.704668 3.632409                  
    #> 8  3.559593 5.603289 4.354567 4.794376 3.598639 3.860003 4.333955         
    #> 9  4.580029 4.761849 4.211596 4.213373 3.647344 3.749577 4.322715 4.259276
    #> 10 4.906895 4.239938 4.619852 4.227949 3.387280 3.292346 4.194670 4.527126
    #>           9
    #> 2          
    #> 3          
    #> 4          
    #> 5          
    #> 6          
    #> 7          
    #> 8          
    #> 9          
    #> 10 4.348531

References
==========

Araújo, Miguel B., Alejandro Rozenfeld, Carsten Rahbek, and Pablo A.
Marquet. 2011. “Using species co-occurrence networks to assess the
impacts of climate change.” *Ecography* 34: 897–908.

Woodward, Guy, Jonathan P Benstead, Oliver S Beveridge, Julia Blanchard,
Thomas Brey, Lee E Brown, Wyatt F Cross, et al. 2010. “Ecological
Networks in a Changing Climate.”
doi:[10.1016/S0065-2504(10)42002-4](https://doi.org/10.1016/S0065-2504(10)42002-4).
