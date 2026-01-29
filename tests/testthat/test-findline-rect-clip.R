test_that("findline fast rectangle clip matches polygon clip", {
  border <- list(
    x = c(0, 10, 10, 0, 0),
    y = c(0, 0, 10, 10, 0)
  )
  x <- list(
    x = c(-5, 5, 15, NA, 5, 5),
    y = c(5, 5, 5, NA, -5, 15)
  )

  res_fast <- findline(x, border, plot = TRUE)
  res_poly <- geo_clip_polyline_to_polygon(x$x, x$y, border$x, border$y)

  expect_equal(res_fast$x, res_poly$x)
  expect_equal(res_fast$y, res_poly$y)
})
