#' Co-occurrence Null Model test.
#' 
#' Provides high level user access to the null modeling tools in the vegan
#' package.
#' 
#' 
#' @param com Community matrix with species in columns.
#' @param method Permutation method. Options include: r00 = fully random, r0 =
#' maintain site frequencies, r1 = maintain both site and species frequencies.
#' For more options see the oecosimu function in the vegan package.
#' @param nits Number of iterations to conduct.
#' @param burn The number permutations to conduct prior to recording matrices.
#' @param thin The number of discarded matrices between iterations.
#' @param threshold Level of abundance necessary for inclusion in the modeling
#' process. This allows for the removal of some species that are at levels of
#' abundance that are not likely to be ecologically relevant.
#' @param null.out Logical: should the null modeled set of communities be
#' returned.
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
#' @export cnm.test
cnm.test <-
function(com, method = 'r1', 
                     nits = 5000, burn = 500, thin = 10, threshold = 0, 
                     null.out = FALSE){
  ###Co-occurrence Null Modeling test
  com[com <= threshold] <- 0
  com.nul <- nullCom(com,method = method,nits = nits,burn = burn,thin = thin)
  cs.nul <- unlist(pblapply(com.nul,cscore))
  cs.obs <- cscore(com)
  ses <- (cs.obs-mean(cs.nul))/sd(cs.nul)
  if (null.out){
    stats <- c(SES = ses,lower.p = length(cs.nul[cs.nul <= cs.obs])/length(cs.nul),
             upper.p = length(cs.nul[cs.nul >= cs.obs])/length(cs.nul))
    return(list(sim = com.nul,stats = stats))
  }else{
      return(c(SES = ses,lower.p = length(cs.nul[cs.nul <= cs.obs])/length(cs.nul),
             upper.p = length(cs.nul[cs.nul >= cs.obs])/length(cs.nul)))
  }
}
