#' Co-occurrence based interaction network modeling.
#' 
#' Generates an interaction network model based on a matrix of
#' co-occurrences (i.e. repeated observations in space). This function
#' is based on the method described in
#' \insertCite{Araujo2011}{conetto} updated to use conditional
#' probabilities. 
#' 
#' %% ~~ If necessary, more details than the description above ~~
#' 
#' @param x A co-occurrence matrix with observations in rows and
#'     species in columns.
#' @param ci.p Interval used for edge removal in percent (e.g. use 95
#'     for a nintey-five percent confidence interval).
#' @param raw LOGICAL: should the original matrix of conditional
#'     probabilities, prior to removel of conditional probabilities
#'     that are within the removal interval.
#' @details Given a set of repeated observations of a set of variables
#'     (e.g. biological species), a network of model of
#'     interactions/interdependencies estimated using the conditional
#'     probabilties (\eqn{P(S_i|S_j))}). This is calculated using
#'     Bayes' Theorem, as \eqn{P(S_i|S_j)) =
#'     \frac{P(S_i,S_j)}{P(S_j)}. \eqn{P(S_i,S_j)} is the marginal
#'     probability, the probability of observing species (\eqn{S_i}
#'     and \eqn{S_j}), which is calculated from the individual
#'     probabilities of each species (\eqn{P(S)}). The total abundance
#'     of each species is used to quantify the individual
#'     probabilities of each species, such the \eqn{P(S_i) =
#'     \frac{S_i}{N}}, where \eqn{N} is the total number of
#'     observational units. The marginal probabilities similarly
#'     calculated as total number of co-occurrences divided by the
#'     total number of observational units, \eqn{P(S_i,S_j) =
#'     \frac{(S_i,S_j)}{N}}.
#' @return An interaction network model in matrix form.
#' @note %% ~~further notes~~
#' @author Matthew K. Lau
#' @seealso %% ~~objects to See Also as \code{\link{help}}, ~~~
#' @references \insertAllCited{}
#' @keywords ~kwd1 ~kwd2
#' @examples
#' 
#' @importFrom Rdpack reprompt
#' @export coNet
coNet <- function(x = "co-occurrence matrix",  ci.p = 95, raw = FALSE){
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
    net[ab > ci.u] <- net[ab > ci.u] * 1
    net[ab < ci.l] <- net[ab < ci.l] * -1
    net.null <- matrix(rep(P[, 1], ncol(net)), nrow = nrow(P))
    net.cond <- cond_net(x) * abs(sign(net))
    net.cond[abs(sign(net)) == 0] <- net.null[abs(sign(net)) == 0]
    if (!(raw)){net <- net.cond - net.null}else{net <- net.cond}
    diag(net) <- 0
    return(net)
}
