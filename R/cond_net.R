#' Conditional probability network.
#' 
#' Generates a matrix of conditional probabilities for a set of
#' species co-occurrences.
#' 
#' @param x A matrix of species co-occurrences with species in columns
#' and observations in rows.
#' @return Returns a matrix of conditional probabilities for a set of species.
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
cond_net <-
function(x){
    out <- matrix(0, nrow = ncol(x), ncol = ncol(x))
    rownames(out) <- colnames(out) <- colnames(x)
    for (i in 1:ncol(x)){
        for (j in i:ncol(x)){
            cp <- cond_prob(sign(x[, i]), sign(x[, j]))
            ##This makes P(row | col)
            out[j, i] <- cp[1]
            out[i, j] <- cp[2]
        }
    }
    return(out)
}
