#' Co-occurrence based interaction network modeling.
#' 
#' Generates an interaction network model based on a matrix of
#' co-occurrences. This function is based on the method described in
#' \insertCite{Araujo2011}{Rdpack}.
#' 
#' %% ~~ If necessary, more details than the description above ~~
#' 
#' @param x A co-occurrence matrix with observations in rows and
#' species in columns.
#' @param ci.p Confidence interval probability used for edge removal
#' in percent (e.g. use 95 for a nintey-five percent confidence
#' interval)
#' @param conditional LOGICAL: should conditional probabilities be used?
#' @param signs LOGICAL: should the sign (positive or negative)
#' of the interactions be returned?
#' @return An interaction network model in matrix form.
#' @note %% ~~further notes~~
#' @author Matthew K. Lau
#' @seealso %% ~~objects to See Also as \code{\link{help}}, ~~~
#' @references
#' \insertAllCited{}
#' @keywords ~kwd1 ~kwd2
#' @examples
#'
#' 
#' 
#' ##---- Should be DIRECTLY executable !! ----
#' ##-- ==>  Define data, use random,
#' ##--	or do  help(data=index)  for the standard data sets.
#' @importFrom Rdpack reprompt
#' @export coNet
coNet <- function(x = "co-occurrence matrix",  ci.p = 95, 
                   conditional = TRUE, signs = TRUE){
    Z <- qnorm((1 - ci.p/100)/2, lower.tail = FALSE)
    if (class(x) == "data.frame"){x <- as.matrix(x)}
    x <- sign(x)
    N <- apply(x, 2, sum)
    A <- nrow(x)
    P <- as.matrix(N / A)
    Pab <- P %*% t(P)
    diag(Pab) <- P
    A <- array(nrow(x), dim = dim(Pab))
    Vab <- A * Pab * (1 - Pab)
    ci.u <- A * Pab + Z * Vab^(1/2)
    ci.l <- A * Pab - Z * Vab^(1/2)
    ab <- t(x) %*% x    
    net <- ab
    net[ab <= ci.u & ab >= ci.l] <- 0
    if (signs){
        net[ab > ci.u] <- net[ab > ci.u] * 1
        net[ab < ci.l] <- net[ab < ci.l] * -1
    }
    if (conditional){
        net.null <- matrix(rep(P[, 1], ncol(net)), nrow = nrow(P))
        net.cond <- cond_net(x) * abs(sign(net))
        net.cond[abs(sign(net)) == 0] <- net.null[abs(sign(net)) == 0]
        net <- net.cond - net.null
        diag(net) <- 0
    }
    return(net)
}
