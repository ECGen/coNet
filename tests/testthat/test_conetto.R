context("Checking primary functions")
library(conetto)

context("Loading test data")
## A <- c(1, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1)
## B <- c(1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1)
## C <- c(1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1)
## D <- c(0, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0)
## M <- data.frame(A, B, C, D)
## net.l <- lapply(1:10, function(x) matrix(runif(100), nrow = 10))
load("../../data/M.rda")
load("../../data/cnet.rda")
load("../../data/mu_net.rda")
load("../../data/net.l.rda")
load("../../data/net.d.rda")
load("../../data/net.d.bc.rda")
load("../../data/net.rda")
load("../../data/pAB.rda")
load("../../data/pAC.rda")
load("../../data/pAD.rda")
load("../../data/pBC.rda")
load("../../data/pCD.rda")

context("Main functions")
test_that("coNet modeling works", {
    expect_true(all(coNet(M) == net))
})

test_that("meanNet works", {
    expect_true(all(meanNet(net.l) == mu_net))
})

test_that("distNet works", {
    expect_true(all(distNet(net.l) == net.d))
    expect_true(all(distNet(net.l, method = "bray") == net.d.bc))
})

context("Supporting functions")

test_that("cond_prob works", {
    expect_true(all(cond_prob(M[, "A"], M[, "B"]) == pAB))
    expect_true(all(cond_prob(M[, "A"], M[, "C"]) == pAC))
    expect_true(all(cond_prob(M[, "A"], M[, "D"]) == pAD))
    expect_true(all(cond_prob(M[, "B"], M[, "C"]) == pBC))
    expect_true(all(cond_prob(M[, "C"], M[, "D"]) == pCD))
})

test_that("cond_net works", {
    expect_true(all(cond_net(M) == cnet))
})

