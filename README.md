<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- # ijtiff  <img src="man/figures/logo.png" height="140" align="right"> -->
<!-- Code status -->
[![Travis Build
Status](https://travis-ci.org/ECGen/conetto.svg?branch=master)](https://travis-ci.org/ECGen/conetto)
[![Travis Build
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
conetto
=======

A toolbox for co-occurrence based network modeling

Network models are a useful representation of systems (Woodward et al.
2010). Because it is not always possible to directly observe
relationships (i.e. ecological interactions) spatial or temporal
patterns of co-occurrence can be used to render models of interaction
networks (Araújo et al. 2011). *conetto* adapts a method previously
developed for ecological networks (Araújo et al. 2011) with the
application of Bayesian probability to generate network models and
provides several functions useful for comparative analysis of sets of
co-occurrence based networks.

Installation
============

Currently, the package is still in beta but it can be installed via the
*devtools* package.

    install.packages("devtools")
    devtools::install_github("ECGen/coNet")

How to use the package
======================

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
    co-occurrences: *P*(*A*|*B*)=*P*(*A*, *B*)/*P*(*B*) and
    *P*(*B*|*A*)=*P*(*A*, *B*)/*P*(*A*).
-   Some of the values in the network are zero. This is because `coNet`
    conducts a test that compares the observed co-occurrences to a
    theoretical "null" co-occurrence interval. If the observed
    co-occurrences are within the interval, the conditional probability
    is set equal to the joint probability. Then, when relativized, the
    resulting values are zero (i.e. *P*(*A*, *B*)−*P*(*A*, *B*)=0). The
    threshold for the null interval test can be adjusted using the
    *ci.p* argument (DEFAULT = 95).
-   Also, some values are negative. This is because the network is
    comprised of the difference between the interval adjusted
    conditional probabilities and the observed independent probabilities
    (i.e. *P*(*A*|*B*)−*P*(*A*)). The "raw", un-relativized, values can
    be returned via the *raw* argument.

Network comparisons
-------------------

The `coNet` function was developed for use with replicated datasets,
where multiple networks have been observed. Two other functions were
written to provide a way to analyze these network sets.

One function, `meanNet`, will calculate the "mean" or average of a set
of networks. The result is the cell-wise summation of all matrices
divided by the total number of matrices. This function requires that the
set of networks all have the same dimensionality and that they are
organized into a list.

    net.l <- lapply(1:3, function(x) matrix(runif(9), nrow = 3))
    net.l
    #> [[1]]
    #>           [,1]      [,2]      [,3]
    #> [1,] 0.4833938 0.3077791 0.4431326
    #> [2,] 0.8332947 0.2526010 0.4912769
    #> [3,] 0.3381026 0.5565451 0.7095279
    #> 
    #> [[2]]
    #>           [,1]      [,2]      [,3]
    #> [1,] 0.5514475 0.4504031 0.6112466
    #> [2,] 0.7163279 0.5288370 0.4749974
    #> [3,] 0.2749955 0.4073876 0.7451709
    #> 
    #> [[3]]
    #>            [,1]      [,2]      [,3]
    #> [1,] 0.75544694 0.4456974 0.8790355
    #> [2,] 0.06577470 0.4447598 0.1293251
    #> [3,] 0.06913326 0.2128330 0.6785895
    meanNet(net.l)
    #>            [,1]       [,2]       [,3]
    #> [1,] 0.13924552 0.09363566 0.15037764
    #> [2,] 0.12564280 0.09537154 0.08521381
    #> [3,] 0.05306278 0.09152679 0.16592346

Another function, `distNet`, facilitates the calculation of a distance
matrix for a set of networks. Two metrics are provided, Euclidean and
Bray-Curtis. The resulting matrix is the distance among all networks in
the set. Similar to `meanNet`, `distNet` requires that all matrices have
the same dimensionality. The result is a distance, or dissimilarity in
the case of Bray-Curtis, matrix that can now be used for multivariate
analyses, such as ordination.

    net.d <- distNet(net.l)
    net.d
    #>           1         2
    #> 2 0.6456985          
    #> 3 1.4485661 1.1145369

Method: Co-occurrence based network models
==========================================

The network modeling is based on conditional probability. Ultimately, we
are interested in an estimate of how much one variable (A) affects
another (B), and visa-versa. *conetto* approaches this by calculating
the difference between the conditional and independent probabilities of
species paris using the observed occurrences (*A* and *B*) and
co-occurrences (*A*, *B*) of the variables of interest from a set of
observations (*N*).

-   Independent probabilities (*P*(*A*)=*A*/*N* and *P*(*B*)=*B*/*N*)
-   Joint probabilities *P*(*A*, *B*)=(*A*, *B*)/*N*
-   Conditional probabilities *P*(*A*|*B*)=*P*(*B*|*A*)*P*(*A*)/*P*(*B*)

Since there is uuncertainly in whether or not two species are dependent,
*conetto* uses a interval based test to determine whether or not to use
the observed joint probability *O*\[*P*(*A*, *B*)\] = (*A*, *B*)/*N* or
the expected probability using an analytical null model
*E*\[*P*(*A*, *B*)\] = *P*(*A*)*P*(*B*). Via the Chain Rule of
probabililty *P*(*A*, *B*)=*P*(*B*|*A*)*P*(*A*), such that if
*E*\[*P*(*A*, *B*)\] is used then
*P*(*A*|*B*)=*P*(*A*)*P*(*B*)/*P*(*B*), which reduces to
*P*(*A*|*B*)=*P*(*A*) and A is conditionally independent from B. We can
then subtract the independent probability matrix from the interval test
modified conditional probability matrix, which produces a matrix of the
dependency among the variables of interest.

References
==========

Araújo, Miguel B., Alejandro Rozenfeld, Carsten Rahbek, and Pablo A.
Marquet. 2011. “Using species co-occurrence networks to assess the
impacts of climate change.” *Ecography* 34: 897–908.

Woodward, Guy, Jonathan P Benstead, Oliver S Beveridge, Julia Blanchard,
Thomas Brey, Lee E Brown, Wyatt F Cross, et al. 2010. “Ecological
Networks in a Changing Climate.”
doi:[10.1016/S0065-2504(10)42002-4](https://doi.org/10.1016/S0065-2504(10)42002-4).
