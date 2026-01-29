library(geo)

set_geopar_for_tests <- function() {
  geopar <- list(
    scale = "km",
    b0 = 65,
    b1 = 65,
    l1 = 0,
    projection = "Mercator",
    gpar = par(no.readonly = TRUE)
  )
  options(geopar = geopar)
}

test_that("geoconvert round-trips decimal degrees", {
  lat <- c(63.5, -12.25, 0, 78.125)
  dmm <- geoconvert.2(lat)
  back <- geoconvert.1(dmm)
  expect_equal(back, lat, tolerance = 1e-6)
})

test_that("rect code round-trips for standard rectangles", {
  code <- c(519, 712, 999)
  centers <- r2d(code)
  roundtrip <- d2r(centers$lat, centers$lon)
  expect_equal(roundtrip, code)
})

test_that("rect code round-trips for subrectangles", {
  code <- c(7121, 5194)
  centers <- sr2d(code)
  roundtrip <- d2sr(centers$lat, centers$lon)
  expect_equal(roundtrip, code)
})

test_that("rect code round-trips for minute rectangles", {
  lat <- c(63.5, 64.0)
  lon <- c(-20.0, -18.0)
  code <- d2mr(lat, lon, dlat = 5, dlon = 10)
  centers <- mr2d(code, dlat = 5, dlon = 10)
  roundtrip <- d2mr(centers$lat, centers$lon, dlat = 5, dlon = 10)
  expect_equal(roundtrip, code)
})

test_that("Proj and invProj are consistent for Mercator", {
  set_geopar_for_tests()
  lat <- c(63.5, 64.25)
  lon <- c(-20.0, -18.5)
  proj <- Proj(lat, lon, projection = "Mercator", scale = "km", b0 = 65)
  inv <- invProj(proj, projection = "Mercator", scale = "km", b0 = 65)
  expect_equal(inv$lat, lat, tolerance = 1e-6)
  expect_equal(inv$lon, lon, tolerance = 1e-6)
})

test_that("inside works for simple square with projection none", {
  reg <- list(x = c(0, 1, 1, 0, 0), y = c(0, 0, 1, 1, 0))
  pts <- list(x = c(0.2, 1.2), y = c(0.2, 0.2))
  inside_vec <- inside(pts, reg = reg, option = 3, projection = "none")
  expect_true(inside_vec[1] > 0)
  expect_equal(inside_vec[2], 0)
})

test_that("rPeri returns a closed 5-point polygon", {
  peri <- rPeri(519)
  expect_equal(nrow(peri), 5)
  expect_equal(peri$lat[1], peri$lat[5])
  expect_equal(peri$lon[1], peri$lon[5])
})
