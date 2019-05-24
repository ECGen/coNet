#' Calculate the mean of a set of networks.
#' 
#' Given a set of networks in matrix format, this function will
#' calculate the cell-wise (Hadimard) mean.
#' 
#' @param x A list of networks to be used for calculating distances.
#' @param zero.na LOGICAL: Should NA values be treated as zeros?
#' @return Returns a matrix of means.
#' @note %% ~~further notes~~
#' @author Matthew K. Lau
#' @seealso %% ~~objects to See Also as \code{\link{help}}, ~~~
#' @keywords ~kwd1 ~kwd2
#' @examples
#' 
#' 
#' @export meanNet
meanNet <-function(x, zero.na = TRUE){
    x <- Reduce("+", x) / sum(unlist(x))
    if (zero.na){x[is.na(x)] <- 0}
    return(x)
}
