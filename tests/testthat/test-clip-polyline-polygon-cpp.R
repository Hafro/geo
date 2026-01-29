test_that("cpp polygon clip matches R implementation", {
  border <- list(
    x = c(0, 5, 10, 8, 2, 0),
    y = c(0, 2, 0, 8, 10, 0)
  )
  line <- list(
    x = c(-2, 3, 7, 12, NA, 1, 9),
    y = c(1, 3, 7, 1, NA, 9, 3)
  )

  res_cpp <- geo_clip_polyline_to_polygon_cpp(
    line$x,
    line$y,
    border$x,
    border$y
  )

  # Use a local copy of the R algorithm to avoid falling back to the C++ path.
  geo_split_na_local <- function(x, y) {
    if (length(x) == 0) {
      return(list())
    }
    na_idx <- which(is.na(x) | is.na(y))
    starts <- c(1, na_idx + 1)
    ends <- c(na_idx - 1, length(x))
    polys <- list()
    for (i in seq_along(starts)) {
      if (starts[i] <= ends[i]) {
        xs <- x[starts[i]:ends[i]]
        ys <- y[starts[i]:ends[i]]
        if (length(xs) >= 2 && (!is.na(xs[1]) && !is.na(ys[1]))) {
          if (xs[1] != xs[length(xs)] || ys[1] != ys[length(ys)]) {
            xs <- c(xs, xs[1])
            ys <- c(ys, ys[1])
          }
        }
        polys[[length(polys) + 1]] <- list(x = xs, y = ys)
      }
    }
    polys
  }

  geo_segment_intersections_local <- function(p1, p2, poly_x, poly_y) {
    n <- length(poly_x)
    if (n < 2) {
      return(data.frame(t = numeric(0), x = numeric(0), y = numeric(0)))
    }
    x1 <- p1[1]
    y1 <- p1[2]
    x2 <- p2[1]
    y2 <- p2[2]
    t_list <- list()
    x_list <- list()
    y_list <- list()
    for (i in 1:(n - 1)) {
      x3 <- poly_x[i]
      y3 <- poly_y[i]
      x4 <- poly_x[i + 1]
      y4 <- poly_y[i + 1]
      den <- (x2 - x1) * (y3 - y4) - (y2 - y1) * (x3 - x4)
      if (abs(den) < 1e-12) {
        next
      }
      s <- ((x2 - x1) * (y3 - y1) - (y2 - y1) * (x3 - x1)) / den
      t <- ((x3 - x1) * (y3 - y4) - (y3 - y1) * (x3 - x4)) / den
      if (t >= 0 && t <= 1 && s >= 0 && s <= 1) {
        xi <- x1 + t * (x2 - x1)
        yi <- y1 + t * (y2 - y1)
        t_list[[length(t_list) + 1]] <- t
        x_list[[length(x_list) + 1]] <- xi
        y_list[[length(y_list) + 1]] <- yi
      }
    }
    if (length(t_list) == 0) {
      return(data.frame(t = numeric(0), x = numeric(0), y = numeric(0)))
    }
    data.frame(t = unlist(t_list), x = unlist(x_list), y = unlist(y_list))
  }

  geo_point_in_polygon_local <- function(x, y, poly_x, poly_y) {
    n <- length(poly_x)
    if (n < 3) {
      return(FALSE)
    }
    inside <- FALSE
    j <- n
    for (i in seq_len(n)) {
      xi <- poly_x[i]
      yi <- poly_y[i]
      xj <- poly_x[j]
      yj <- poly_y[j]
      intersect <- ((yi > y) != (yj > y)) &
        (x < (xj - xi) * (y - yi) / (yj - yi + 0.0) + xi)
      if (intersect) {
        inside <- !inside
      }
      j <- i
    }
    inside
  }

  geo_clip_segment_to_polygon_local <- function(p1, p2, poly_x, poly_y) {
    inter <- geo_segment_intersections_local(p1, p2, poly_x, poly_y)
    if (nrow(inter) == 0) {
      if (
        geo_point_in_polygon_local(
          (p1[1] + p2[1]) / 2,
          (p1[2] + p2[2]) / 2,
          poly_x,
          poly_y
        )
      ) {
        return(list(rbind(p1, p2)))
      }
      return(list())
    }
    ts <- sort(unique(c(0, inter$t, 1)))
    out <- list()
    for (i in 1:(length(ts) - 1)) {
      t_mid <- (ts[i] + ts[i + 1]) / 2
      mid <- p1 + t_mid * (p2 - p1)
      if (geo_point_in_polygon_local(mid[1], mid[2], poly_x, poly_y)) {
        a <- p1 + ts[i] * (p2 - p1)
        b <- p1 + ts[i + 1] * (p2 - p1)
        out[[length(out) + 1]] <- rbind(a, b)
      }
    }
    out
  }

  geo_clip_polyline_to_polygon_local <- function(x, y, poly_x, poly_y) {
    parts <- geo_split_na_local(x, y)
    poly_xmin <- min(poly_x, na.rm = TRUE)
    poly_xmax <- max(poly_x, na.rm = TRUE)
    poly_ymin <- min(poly_y, na.rm = TRUE)
    poly_ymax <- max(poly_y, na.rm = TRUE)
    seg_x <- list()
    seg_y <- list()
    for (part in parts) {
      xs <- part$x
      ys <- part$y
      if (length(xs) < 2) {
        next
      }
      for (i in 1:(length(xs) - 1)) {
        p1 <- c(xs[i], ys[i])
        p2 <- c(xs[i + 1], ys[i + 1])
        if (
          (min(p1[1], p2[1]) > poly_xmax) ||
            (max(p1[1], p2[1]) < poly_xmin) ||
            (min(p1[2], p2[2]) > poly_ymax) ||
            (max(p1[2], p2[2]) < poly_ymin)
        ) {
          next
        }
        segs <- geo_clip_segment_to_polygon_local(p1, p2, poly_x, poly_y)
        for (seg in segs) {
          seg_x[[length(seg_x) + 1]] <- seg[, 1]
          seg_y[[length(seg_y) + 1]] <- seg[, 2]
        }
      }
    }
    nseg <- length(seg_x)
    if (nseg == 0) {
      return(list(x = numeric(0), y = numeric(0)))
    }
    total <- nseg * 3 - 1
    out_x <- numeric(total)
    out_y <- numeric(total)
    pos <- 1
    for (i in seq_len(nseg)) {
      sx <- seg_x[[i]]
      sy <- seg_y[[i]]
      out_x[pos] <- sx[1]
      out_x[pos + 1] <- sx[2]
      out_y[pos] <- sy[1]
      out_y[pos + 1] <- sy[2]
      pos <- pos + 2
      if (i < nseg) {
        out_x[pos] <- NA_real_
        out_y[pos] <- NA_real_
        pos <- pos + 1
      }
    }
    list(x = out_x, y = out_y)
  }

  res_r <- geo_clip_polyline_to_polygon_local(
    line$x,
    line$y,
    border$x,
    border$y
  )

  expect_equal(res_cpp$x, res_r$x, tolerance = 1e-10)
  expect_equal(res_cpp$y, res_r$y, tolerance = 1e-10)
})
