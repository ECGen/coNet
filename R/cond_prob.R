#' Conditional probability calculator.
#' 
#' Calculates conditional probabilities using co-occurrences of two species.
#' 
#' @param a Occurrences of a species.
#' @param b Occurrences of another species.
#' @return Returns the conditional probabilities for each species
#' based on the other species
#' @note %% ~~further notes~~
#' @author Matthew K. Lau
#' @seealso %% ~~objects to See Also as \code{\link{help}}, ~~~
#' @references %% ~put references to the literature/web site here ~
#' @keywords ~kwd1 ~kwd2
#' @examples
#' 
#' ##---- Should be DIRECTLY executable !! ----
#' ##-- ==>  Define data, use random,
#' ##--	or do  help(data=index)  for the standard data sets.
#' 
#' @export cond_prob
cond_prob <- function(a, b){
    ## P(B) = B / N
    ## P(A) = A / N
    ## P(A,B) = AB / N 
    ## P(B|A) = P(A,B) / P(A)
    ## P(A|B) = P(A,B) / P(B)
    n <- length(a)
    p.a <- sum(a) / n
    p.b <- sum(b) / n
    p.ab <- sum(sign(a + b == 2)) / n
    p.a_b <- p.ab / p.b
    p.b_a <- p.ab / p.a
    return(c(p.a_b, p.b_a))
}
