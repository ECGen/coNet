#' Conditional probability calculator.
#' 
#' Calculates conditional probabilities using co-occurrences using
#' Bayes' Theorem, such that \eqn{P(A|B) = \frac{P(A,B)}{P(B)}}, where
#' \eqn{P(A,B) = \frac{(A,B)}{N}}, \eqn{P(B) = \frac{(B)}{N}} and
#' \eqn{N} is the total number of observational units.
#'
#' @param a A set of repeated observations of occurrences.
#' @param b Another set of repeated observations of occurrences.
#' @return Returns the conditional probabilities.
#' @note This is primarily a low-level function used by coNet, it may
#'     be of interest to more advanced users.
#' @author Matthew K. Lau
#' @examples
#'
#' A <- c(1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1)
#' B <- c(1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1)
#' cond_prob(A, B)
#'
#' C <- c(1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1)
#' D <- c(0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0)
#'
#' cond_prob(C, D)
#' 
#' @export cond_prob
cond_prob <- function(a, b){
    n <- length(a)
    p.a <- sum(a) / n
    p.b <- sum(b) / n
    p.ab <- sum(sign(a + b == 2)) / n
    p.a_b <- p.ab / p.b
    p.b_a <- p.ab / p.a
    return(c(p.a_b, p.b_a))
}
