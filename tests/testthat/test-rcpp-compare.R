test_that("geo_point_in_polygon C++ matches R", {
  ns <- asNamespace("geo")
  geo_point_in_polygon_r <- get("geo_point_in_polygon_r", ns)
  geo_point_in_polygon_cpp <- get("geo_point_in_polygon_cpp", ns)
  poly_x <- c(0, 1, 1, 0, 0)
  poly_y <- c(0, 0, 1, 1, 0)
  x <- c(-0.1, 0.2, 0.8, 1.1)
  y <- c(0.5, 0.2, 0.8, 0.5)

  r_res <- geo_point_in_polygon_r(x, y, poly_x, poly_y)
  cpp_res <- geo_point_in_polygon_cpp(x, y, poly_x, poly_y)
  expect_equal(as.logical(cpp_res), as.logical(r_res))
})

test_that("geo_point_in_multipolygon C++ matches R", {
  ns <- asNamespace("geo")
  geo_point_in_multipolygon_r <- get("geo_point_in_multipolygon_r", ns)
  geo_point_in_multipolygon_cpp <- get("geo_point_in_multipolygon_cpp", ns)
  # Two squares: [0,1]x[0,1] and [2,3]x[2,3]
  poly_x <- c(0, 1, 1, 0, 0, 2, 3, 3, 2, 2)
  poly_y <- c(0, 0, 1, 1, 0, 2, 2, 3, 3, 2)
  lxv <- c(0, 5, 10)
  border <- list(lon = poly_x, lat = poly_y, lxv = lxv)

  x <- c(0.5, 2.5, 1.5)
  y <- c(0.5, 2.5, 1.5)

  r_res <- geo_point_in_multipolygon_r(x, y, border)
  cpp_res <- geo_point_in_multipolygon_cpp(x, y, poly_x, poly_y, lxv)
  expect_equal(as.logical(cpp_res), as.logical(r_res))
})

test_that("pointkriging C++ matches R within tolerance", {
  ns <- asNamespace("geo")
  geo_pointkriging_impl_r <- get("geo_pointkriging_impl_r", ns)
  geo_pointkriging_impl_cpp <- get("geo_pointkriging_impl_cpp", ns)
  set.seed(123)
  lat <- rnorm(50, 64.5, 0.6)
  lon <- rnorm(50, -20, 1.2)
  z <- sin(lat) + cos(lon)

  lon_seq <- seq(min(lon), max(lon), by = 0.4)
  lat_seq <- seq(min(lat), max(lat), by = 0.4)
  xgr <- list(lon = lon_seq, lat = lat_seq)

  vgram <- variogram(lat, lon, z, nbins = 10)
  vfit <- variofit(vgram, option = 1)
  if (is.null(vfit) || any(!c("rang1", "sill", "nugget") %in% names(vfit))) {
    vfit <- list(rang1 = 1, sill = 1, nugget = 0)
  }

  # Build grid in radians like pointkriging does
  gr <- xgr
  lat1 <- c(t(matrix(gr$lat, length(gr$lat), length(gr$lon))))
  lon1 <- c(matrix(gr$lon, length(gr$lon), length(gr$lat)))
  n <- length(gr$lon)
  m <- length(gr$lat)
  row <- cut(lat, c(-999, gr$lat, 999), labels = FALSE)
  col <- cut(lon, c(-999, gr$lon, 999), labels = FALSE)
  reitur <- (n + 1) * (row - 1) + col
  treitur <- rep(1L, length(lat))
  xxx <- bua(8)

  lat_r <- lat * pi / 180
  lon_r <- lon * pi / 180
  lat1_r <- lat1 * pi / 180
  lon1_r <- lon1 * pi / 180
  vgr <- c(vfit$rang1, vfit$sill, vfit$nugget)

  r_out <- geo_pointkriging_impl_r(
    lat_r,
    lon_r,
    z,
    lat1_r,
    lon1_r,
    vgr,
    maxnumber = 12,
    maxdist = 0,
    option = 1,
    minnumber = 2,
    mz = 0,
    zeroset = FALSE,
    varcalc = FALSE,
    sill = 0,
    reitur = reitur,
    n = n,
    m = m,
    stdcrt = xxx$crt,
    stdrrt = xxx$rrt,
    dir = xxx$dir,
    i1 = xxx$i1,
    rat = 3,
    treitur = treitur
  )

  cpp_out <- geo_pointkriging_impl_cpp(
    lat_r,
    lon_r,
    z,
    lat1_r,
    lon1_r,
    vgr,
    maxnumber = 12,
    maxdist = 0,
    option = 1,
    minnumber = 2,
    mz = 0,
    zeroset = FALSE,
    varcalc = FALSE,
    sill = 0,
    reitur = reitur,
    n = n,
    m = m,
    stdcrt = xxx$crt,
    stdrrt = xxx$rrt,
    dir = xxx$dir,
    i1 = xxx$i1,
    rat = 3,
    treitur = treitur
  )

  diff <- abs(r_out$zgr - cpp_out$zgr)
  diff <- diff[!is.na(diff)]
  expect_true(mean(diff) < 1e-3)
  expect_true(max(diff) < 1e-2)
})
