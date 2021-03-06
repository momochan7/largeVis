context("specific issue tests")

test_that("dim064 issue is resolved", {
#  testthat::skip_if_not(R.Version()$arch != "i386", "certain tests disabled on i386")
	load(system.file("extdata/badmat.Rda", package = "largeVis"))
	badmat <- badmat
	expect_silent(neighbors <- randomProjectionTreeSearch(x = badmat, K = 50, threads = 2))
	expect_silent(edges <- buildEdgeMatrix(data = badmat, neighbors = neighbors, threads = 2))
	expect_silent(vis <- largeVis(badmat, K = 50, threads = 2, sgd_batches = 1000))
})

test_that("dim512 issue (excessive distances in the edge matrix)", {
#  testthat::skip_if_not(R.Version()$arch != "i386", "certain tests disabled on i386")
  load(system.file("extdata/dim512.Rda", package = "largeVis"))
	dim512 <- dim512
	dat <- t(scale(as.matrix(dim512)))
	expect_warning(vis <- largeVis(dat, K = 100, threads = 2, sgd_batches = 1000))
})

test_that("neighbors does not fail with 0 max iters when the neighborhood is complete", {
	set.seed(1974)
	data(iris)
	dat <- as.matrix(iris[, 1:4])
	dupes <- which(duplicated(dat))
	dat <- dat[-dupes, ]
	dat <- t(dat)
	K <- 148
	distances <- as.matrix(dist(t(dat)))
	expect_silent(neighbors <- randomProjectionTreeSearch(dat, K = K, tree_threshold = 40,
																												n_trees = 10,  threads = 2, max_iter = 0, verbose = FALSE))
})