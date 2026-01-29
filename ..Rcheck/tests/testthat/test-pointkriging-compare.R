
test_that("pointkriging matches legacy C within tolerance", {
  library(geo)
  if(Sys.getenv("GEO_COMPARE_OLD_C") != "1") {
    skip("Set GEO_COMPARE_OLD_C=1 to run legacy C comparison")
  }

  set.seed(123)
  lat <- rnorm(80, 64.5, 0.6)
  lon <- rnorm(80, -20, 1.2)
  z <- sin(lat) + cos(lon)

  lon_seq <- seq(min(lon), max(lon), by = 0.4)
  lat_seq <- seq(min(lat), max(lat), by = 0.4)
  xgr <- list(lon = lon_seq, lat = lat_seq)

  vgram <- variogram(lat, lon, z, nbins = 15)
  vfit <- variofit(vgram, option = 1)
  if(is.null(vfit)) {
    vfit <- list(rang1 = 1, sill = 1, nugget = 0)
  }

  new_res <- pointkriging(lat, lon, z, xgr, vfit, maxnumber = 12)
  old_res <- geo_oldc_pointkriging(lat, lon, z, xgr, vfit, maxnumber = 12)
  if(is.null(old_res)) {
    skip("Legacy C comparison unavailable (compile failed)")
  }

  new_z <- new_res
  if(is.list(new_res)) new_z <- new_res$zgr
  old_z <- old_res$zgr

  expect_equal(length(new_z), length(old_z))
  diff <- abs(new_z - old_z)
  diff <- diff[!is.na(diff)]
  expect_true(length(diff) > 0)
  expect_true(mean(diff) < 1e-2)
  expect_true(max(diff) < 3e-2)
})
