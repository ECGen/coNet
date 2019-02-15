#' Calculate the mean of a set of networks.
#' 
#' Given a set of networks in matrix format, this function will
#' calculate the cell-wise (Hadimard) mean.
#' 
#' This function computes the Euclidean (i.e. straight line) distance using all
#' edges for all pairs of networks in a list of networks. The mathematics of
#' using Euclidean distance to summarize the difference between two networks
#' has not been explored fully, so use with caution.
#' 
#' @param x A list of networks to be used for calculating distances.
#' @param zero.na LOGICAL: Should NA values be treated as zeros?
#' @param method Distance/dissimilarity method to use: "euclidean" or
#' "bray" for Bray-Curtis.
#' @return Returns a distance objects of pairwise distance or
#' dissimilarities for all networks.
#' @note %% ~~further notes~~
#' @author Matthew K. Lau
#' @seealso %% ~~objects to See Also as \code{\link{help}}, ~~~
#' @keywords ~kwd1 ~kwd2
#' @examples
#' 
#' ##---- Should be DIRECTLY executable !! ----
#' ##-- ==>  Define data, use random,
#' ##--	or do  help(data=index)  for the standard data sets.
#' 
netMean <-
function(x, zero.na = TRUE){
    x <- Reduce("+", x) / sum(unlist(x))
    if (zero.na){x[is.na(x)] <- 0}
    x
}
