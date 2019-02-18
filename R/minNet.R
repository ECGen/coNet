#' Minimize a network using any network generating function and an abundance threshold
#' 
#' Method for reducing the number of edges in a network.
#' 
#' Using a chosen minimization algorithm, a minimzed network is computed.
#' 
#' @param x A network in matrix format.
#' @param FUN Function to use for minimization.
#' @param alpha Significance level.
#' @return The minimized network is returned in matrix format.
#' @note %% ~~further notes~~
#' @author Matthew K. Lau
#' @seealso %% ~~objects to See Also as \code{\link{help}}, ~~~
#' @keywords ~kwd1 ~kwd2
#' @examples
#' 
#' ##---- Should be DIRECTLY executable !! ----
#' ##-- ==>  Define data, use random,
#' ##--	or do  help(data=index)  for the standard data sets.
#' @export minNet
minNet <-
function(x, FUN = 'cdNet', alpha = 0.05){
    thresh <- start
    g <- get(FUN)(m, alpha=alpha)
    no.c <- no.clusters(igraph::graph.adjacency(g,weighted=TRUE))
    while (no.c == 1){
        thresh <- thresh + 1
        m[m < thresh] <- 0
        g <- get(FUN)(m,alpha=alpha)
        w <- c(w,igraph::components(igraph::graph.adjacency(g,weighted=TRUE),mode='weak'))
        s <- c(s,igraph::components(igraph::graph.adjacency(g,weighted=TRUE),mode='strong'))
        no.c <- no.clusters(igraph::graph.adjacency(g,weighted=TRUE))
    }
    m <- x
    m[m < (thresh - 1)] <- 0
    get(FUN)(m,alpha=alpha)
}
