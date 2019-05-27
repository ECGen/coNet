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
    ##  [1,] 0.006207444 0.006358360 0.008527335 0.009266809 0.010851130
    ##  [2,] 0.013115179 0.010720094 0.007643395 0.010298368 0.010957788
    ##  [3,] 0.010815386 0.008809325 0.009804948 0.009093921 0.008166896
    ##  [4,] 0.006757493 0.014844397 0.009992198 0.007229854 0.011199825
    ##  [5,] 0.012705391 0.015356454 0.010627658 0.009233442 0.012872926
    ##  [6,] 0.012820648 0.011298764 0.013551508 0.010148811 0.009692556
    ##  [7,] 0.009273218 0.011700752 0.011658681 0.008713131 0.010572119
    ##  [8,] 0.008130556 0.007285183 0.009201083 0.010739098 0.009245628
    ##  [9,] 0.009340374 0.011563501 0.010266972 0.009975382 0.009282360
    ## [10,] 0.010480560 0.012383954 0.010990919 0.012303593 0.009542966
    ##              [,6]        [,7]        [,8]       [,9]       [,10]
    ##  [1,] 0.008320561 0.010783551 0.008300789 0.01094902 0.008795954
    ##  [2,] 0.010218310 0.009766005 0.010146441 0.01304327 0.007620428
    ##  [3,] 0.007337237 0.011429606 0.010035967 0.01161336 0.007099058
    ##  [4,] 0.010673230 0.009583193 0.011333830 0.01132145 0.009217230
    ##  [5,] 0.008114306 0.009767551 0.013602353 0.01005031 0.009954467
    ##  [6,] 0.009276221 0.010909503 0.010911959 0.01022659 0.008268292
    ##  [7,] 0.009828541 0.010337654 0.009015594 0.01139320 0.010258203
    ##  [8,] 0.006452945 0.006918187 0.007773087 0.01202697 0.009794375
    ##  [9,] 0.007387500 0.010448868 0.007534779 0.01197210 0.007763208
    ## [10,] 0.009793058 0.008004904 0.009828649 0.01324614 0.009933659

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
    ## 2  5.382211                                                               
    ## 3  4.097148 4.337795                                                      
    ## 4  4.671064 4.160934 4.642081                                             
    ## 5  4.648439 4.327424 4.126040 4.299928                                    
    ## 6  5.316647 4.177403 4.460486 4.262808 3.813093                           
    ## 7  4.209149 4.543637 4.728376 4.180486 4.825633 5.236036                  
    ## 8  4.704984 4.256306 4.414905 4.048058 4.443792 4.497813 4.411508         
    ## 9  5.059388 3.368683 4.614104 4.757306 4.462172 4.835247 4.303141 5.154509
    ## 10 4.253119 4.318477 3.704430 4.224687 4.011162 4.248922 4.175072 4.397576
    ##           9
    ## 2          
    ## 3          
    ## 4          
    ## 5          
    ## 6          
    ## 7          
    ## 8          
    ## 9          
    ## 10 4.122104

References
==========

Araújo, Miguel B., Alejandro Rozenfeld, Carsten Rahbek, and Pablo A.
Marquet. 2011. “Using species co-occurrence networks to assess the
impacts of climate change.” *Ecography* 34: 897–908.

Woodward, Guy, Jonathan P Benstead, Oliver S Beveridge, Julia Blanchard,
Thomas Brey, Lee E Brown, Wyatt F Cross, et al. 2010. “Ecological
Networks in a Changing Climate.”
doi:[10.1016/S0065-2504(10)42002-4](https://doi.org/10.1016/S0065-2504(10)42002-4).
