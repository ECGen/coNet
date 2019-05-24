#' Minimize a network using any network generating function and an
#' abundance threshold
#' 
#' Method for reducing the number of edges in a network.
#' 
#' Using a chosen minimization algorithm based on the point at which
#' the graph breaks into two components, a minimzed network is
#' computed. This is based on the percolation threshold algorithm
#' developed in \insertCite{Araujo2011}{conetto}
#' 
#' @param x A network in matrix format.
#' @param FUN Function to use for minimization. DEFAULT is coNet
#' @param alpha Significance level.
#' @return The minimized network is returned in matrix format.
#' @note %% ~~further notes~~
#' @author Matthew K. Lau
#' @seealso %% ~~objects to See Also as \code{\link{help}}, ~~~
#' @references \insertAllCited{}
#' @keywords ~kwd1 ~kwd2
#' @examples
#' 
#' @importFrom igraph graph.adjacency
#' @importFrom igraph no.clusters
#' @export minNet
minNet <- function(x, FUN = 'coNet', alpha = 0.05){
    thresh <- start
    g <- get(FUN)(m, alpha = alpha)
    no.c <- no.clusters(graph.adjacency(g, weighted = TRUE))
    while (no.c == 1){
        thresh <- thresh + 1
        m[m < thresh] <- 0
        g <- get(FUN)(m,alpha=alpha)
        w <- c(w, components(graph.adjacency(g, weighted = TRUE),
                             mode='weak'))
        s <- c(s,components(graph.adjacency(g, weighted = TRUE),
                            mode='strong'))
        no.c <- no.clusters(graph.adjacency(g, weighted = TRUE))
    }
    m <- x
    m[m < (thresh - 1)] <- 0
    get(FUN)(m, alpha=alpha)
}
