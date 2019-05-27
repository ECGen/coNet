#' Conditional probability network.
#' 
#' Generates a matrix of conditional probabilities for a set of
#' co-occurrences.
#' 
#' @param x A matrix of species co-occurrences with species in columns
#'     and observations in rows.
#' @return Returns a matrix of conditional probabilities for a set of
#'     species.
#' @note This is primarily a low-level function used by coNet, it may
#'     be of interest to more advanced users who would like to
#'     directly compute the conditional probabilities from a set of
#'     co-occurrences.
#' @author Matthew K. Lau
#' @seealso \code{\link{coNet}}, \code{\link{cond_prob}} %% ~~objects
#'     to See Also as \code{\link{help}}, ~~~
#' @examples
#'
#' A <- c(1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1)
#' B <- c(1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1)
#' C <- c(1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1)
#' D <- c(0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0)
#' M <- data.frame(A, B, C, D)
#' cond_net(M)
#' 
#' @export cond_net
cond_net <- function(x){
    out <- matrix(0, nrow = ncol(x), ncol = ncol(x))
    rownames(out) <- colnames(out) <- colnames(x)
    nc <- 1:ncol(x)
    for (i in seq_along(nc)){
        for (j in i:ncol(x)){
            cp <- cond_prob(sign(x[, i]), sign(x[, j]))
            out[j, i] <- cp[1]
            out[i, j] <- cp[2]
        }
    }
    return(out)
}
