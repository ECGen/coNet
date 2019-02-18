#' Calculates the percolation threshold.
#' 
#' Calculates the percolation threshold to determine the minimal network using
#' the methods of Araujo et al. 2011.
#' 
#' This function is a dependency for the co.net and CoNetwork functions.
#' 
#' @param x A network in matrix form.
#' @param step.size The increment to use in determining the threshold.
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
#' ## The function is currently defined as
#' function (x = "network matrix", step.size = 0.01) 
#' {
#'     no.c <- no.clusters(graph.adjacency(x, weighted = TRUE))
#'     step <- 1
#'     while (no.c == 1) {
#'         x[x <= (step * step.size)] <- 0
#'         no.c <- no.clusters(graph.adjacency(x, weighted = TRUE))
#'         step <- step + 1
#'     }
#'     out <- list(threshold = ((step - 1) * step.size), isolated.nodes = colnames(x)[clusters(graph.adjacency(x, 
#'         weighted = TRUE))$membership == 2])
#'     return(out)
#'   }
#' 
percThreshold <-
function(x = 'network matrix',step.size = 0.01){
  no.c <- no.clusters(graph.adjacency(x,weighted = TRUE))
  step <- 1
  while (no.c == 1){
    x[x <= (step*step.size)] <- 0
    no.c <- no.clusters(graph.adjacency(x,weighted = TRUE))
    step <- step + 1
  }
  out <- list(threshold = ((step - 1) * step.size), 
              isolated.nodes = colnames(x)[clusters(
                  graph.adjacency(x, weighted = TRUE))$membership == 2])
  return(out)
}
