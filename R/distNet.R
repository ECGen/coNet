#' Network distance for a set of networks.
#' 
#' Takes a list of networks and returns a distance matrix using
#' Euclidean distance.
#' 
#' This function computes the Euclidean (i.e. straight line) distance
#' using all edges for all pairs of networks in a list of
#' networks. The mathematics of using Euclidean distance to summarize
#' the difference between two networks has not been explored fully, so
#' use with caution.
#' 
#' @param x A list of networks to be used for calculating distances.
#' @param zero.na LOGICAL: Should NA values be treated as zeros?
#' @param method Distance/dissimilarity method to use: "euclidean" or
#' "bray" for Bray-Curtis.
#' @return Returns a distance objects of pairwise distance or
#' dissimilarities for all networks.
#' @note %% ~~further notes~~
#' @author Matthew K. Lau
#' @seealso \code{\link{coNet}} %% ~~objects to See Also as \code{\link{help}}, ~~~
#' @keywords %% ~kwd1 ~kwd2
#' @examples 
#'
#' net.l <- lapply(1:10, function(x) matrix(runif(100), nrow = 10))
#' distNet(net.l)
#' 
#' @importFrom ecodist bcdist
#' @importFrom stats dist
#' @export distNet
distNet <-  function(x, zero.na = TRUE, method = "euclidean"){
    out <- array(0, dim = rep(length(x), 2))
    if (!is.null(names(x))){
        rownames(out) <- colnames(out) <- names(x)
    }
    if (grepl("bray", tolower(method)) | tolower(method) == "bc"){
        for (i in seq_along(x)){
            for (j in seq_along(x)){
                y <- data.frame(
                    c(x[[i]][lower.tri(x[[i]])], 
                      x[[i]][upper.tri(x[[i]])]), 
                    c(x[[j]][lower.tri(x[[j]])], 
                      x[[i]][upper.tri(x[[i]])]))
                if (all(y == 0)){y[y == 0] <- 1}
                out[i, j] <- bcdist(t(y))
            }
        }
    }else{
        for (i in seq_along(x)){
            for (j in seq_along(x)){
                out[i, j] <- sum(
                    c((x[[i]][lower.tri(x[[i]])] - 
                       x[[j]][lower.tri(x[[j]])]), 
                    (x[[i]][upper.tri(x[[i]])] - 
                     x[[j]][upper.tri(x[[j]])])^2))^(1/2)
            }
        }
    }
    if (zero.na){out[is.na(out)] <- 0}
    dist(out)
}
