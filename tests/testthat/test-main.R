context("Main functions")
test_that("coNet modeling works", {
    load("M.rda")
    load("net.rda")
    load("net.raw.rda")
    expect_true(all(coNet(M) == net))
    expect_true(all(coNet(M, raw = TRUE) == net.raw))
})

test_that("meanNet works", {
    load("net.l.rda")
    load("mu_net.rda")
    expect_true(all(meanNet(net.l) == mu_net))
})

test_that("distNet works", {
    load("net.l.rda")
    load("net.d.rda")
    load("net.d.bc.rda")
    expect_true(all(
        round(distNet(net.l), 5) == 
        net.d))
    expect_true(all(
        round(distNet(net.l, method = "bray"), 5) == 
        net.d.bc))
})

context("Supporting functions")

test_that("cond_prob works", {
    load("M.rda")
    load("pAB.rda")
    load("pAC.rda")
    load("pAD.rda")
    load("pBC.rda")
    load("pCD.rda")
    expect_true(all(cond_prob(M[, "A"], M[, "B"]) == pAB))
    expect_true(all(cond_prob(M[, "A"], M[, "C"]) == pAC))
    expect_true(all(cond_prob(M[, "A"], M[, "D"]) == pAD))
    expect_true(all(cond_prob(M[, "B"], M[, "C"]) == pBC))
    expect_true(all(cond_prob(M[, "C"], M[, "D"]) == pCD))
})

test_that("cond_net works", {
    load("M.rda")
    load("cnet.rda")
    expect_true(all(cond_net(M) == cnet))
})

