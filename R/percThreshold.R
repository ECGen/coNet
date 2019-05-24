#' Calculates the percolation threshold.
#' 
#' Determine the minimal network using the percolation threshold
#' method from \insertCite{Araujo2011}{conetto}.
#' 
#' @param x A network in matrix form.
#' @param step.size The increment to use in determining the threshold.
#' @note %% ~~further notes~~
#' @author Matthew K. Lau 
#' @seealso %% ~~objects to See Also as \code{\link{help}}, ~~~
#' @references \insertAllCited{}
#' @keywords ~kwd1 ~kwd2
#' @examples
#' 
#' @importFrom igraph no.clusters
#' @importFrom igraph graph.adjacency
#' @importFrom igraph clusters
#' @export percThreshold
percThreshold <-function(x = 'network matrix', step.size = 0.01){
  no.c <- no.clusters(graph.adjacency(x,weighted = TRUE))
  step <- 1
  while (no.c == 1){
    x[x <= (step * step.size)] <- 0
    no.c <- no.clusters(graph.adjacency(x, weighted = TRUE))
    step <- step + 1
  }
  out <- list(threshold = ((step - 1) * step.size), 
              isolated.nodes = colnames(x)[clusters(
                  graph.adjacency(x, weighted = TRUE))$membership == 2])
  return(out)
}
