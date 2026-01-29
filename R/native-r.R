# Pure-R replacements for former C routines.

geo_close_polygon <- function(x, y) {
  if (length(x) < 2) {
    return(list(x = x, y = y))
  }
  if (is.na(x[1]) || is.na(y[1])) {
    return(list(x = x, y = y))
  }
  if (x[1] != x[length(x)] || y[1] != y[length(y)]) {
    x <- c(x, x[1])
    y <- c(y, y[1])
  }
  list(x = x, y = y)
}

geo_split_na <- function(x, y) {
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
      polys[[length(polys) + 1]] <- geo_close_polygon(xs, ys)
    }
  }
  polys
}

geo_is_axis_aligned_rect <- function(x, y) {
  if (length(x) != 5 || length(y) != 5) {
    return(FALSE)
  }
  if (is.na(x[1]) || is.na(y[1]) || is.na(x[5]) || is.na(y[5])) {
    return(FALSE)
  }
  if (x[1] != x[5] || y[1] != y[5]) {
    return(FALSE)
  }
  ux <- unique(x)
  uy <- unique(y)
  if (length(ux) != 2 || length(uy) != 2) {
    return(FALSE)
  }
  TRUE
}

geo_clip_segment_to_rect <- function(x1, y1, x2, y2, xmin, xmax, ymin, ymax) {
  dx <- x2 - x1
  dy <- y2 - y1
  p1 <- -dx
  p2 <- dx
  p3 <- -dy
  p4 <- dy
  q1 <- x1 - xmin
  q2 <- xmax - x1
  q3 <- y1 - ymin
  q4 <- ymax - y1
  u1 <- 0
  u2 <- 1
  if (p1 == 0) {
    if (q1 < 0) return(NULL)
  } else {
    t <- q1 / p1
    if (p1 < 0) u1 <- max(u1, t) else u2 <- min(u2, t)
  }
  if (p2 == 0) {
    if (q2 < 0) return(NULL)
  } else {
    t <- q2 / p2
    if (p2 < 0) u1 <- max(u1, t) else u2 <- min(u2, t)
  }
  if (p3 == 0) {
    if (q3 < 0) return(NULL)
  } else {
    t <- q3 / p3
    if (p3 < 0) u1 <- max(u1, t) else u2 <- min(u2, t)
  }
  if (p4 == 0) {
    if (q4 < 0) return(NULL)
  } else {
    t <- q4 / p4
    if (p4 < 0) u1 <- max(u1, t) else u2 <- min(u2, t)
  }
  if (u1 > u2) {
    return(NULL)
  }
  x <- c(x1 + u1 * dx, x1 + u2 * dx)
  y <- c(y1 + u1 * dy, y1 + u2 * dy)
  list(x = x, y = y)
}

geo_clip_polyline_to_rect <- function(x, y, xmin, xmax, ymin, ymax) {
  if (exists("geo_clip_polyline_to_rect_cpp", mode = "function")) {
    return(geo_clip_polyline_to_rect_cpp(x, y, xmin, xmax, ymin, ymax))
  }
  parts <- geo_split_na(x, y)
  seg_x <- list()
  seg_y <- list()
  for (part in parts) {
    xs <- part$x
    ys <- part$y
    if (length(xs) < 2) {
      next
    }
    for (i in 1:(length(xs) - 1)) {
      x1 <- xs[i]
      y1 <- ys[i]
      x2 <- xs[i + 1]
      y2 <- ys[i + 1]
      if (is.na(x1) || is.na(y1) || is.na(x2) || is.na(y2)) {
        next
      }
      seg <- geo_clip_segment_to_rect(x1, y1, x2, y2, xmin, xmax, ymin, ymax)
      if (!is.null(seg)) {
        seg_x[[length(seg_x) + 1]] <- seg$x
        seg_y[[length(seg_y) + 1]] <- seg$y
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

geo_point_in_polygon_r <- function(x, y, poly_x, poly_y) {
  n <- length(poly_x)
  if (n < 3) {
    return(rep(FALSE, length(x)))
  }
  inside <- rep(FALSE, length(x))
  j <- n
  for (i in seq_len(n)) {
    xi <- poly_x[i]
    yi <- poly_y[i]
    xj <- poly_x[j]
    yj <- poly_y[j]
    intersect <- ((yi > y) != (yj > y)) &
      (x < (xj - xi) * (y - yi) / (yj - yi + 0.0) + xi)
    inside <- xor(inside, intersect)
    j <- i
  }
  inside
}

geo_point_in_multipolygon_r <- function(x, y, border) {
  if (is.null(border$lxv)) {
    poly <- geo_close_polygon(border$lon, border$lat)
    return(geo_point_in_polygon_r(x, y, poly$x, poly$y))
  }
  lxv <- border$lxv
  if (length(lxv) < 2) {
    poly <- geo_close_polygon(border$lon, border$lat)
    return(geo_point_in_polygon_r(x, y, poly$x, poly$y))
  }
  inside <- rep(FALSE, length(x))
  for (i in 1:(length(lxv) - 1)) {
    start <- lxv[i] + 1
    end <- lxv[i + 1]
    if (start <= end) {
      poly <- geo_close_polygon(border$lon[start:end], border$lat[start:end])
      ring_inside <- geo_point_in_polygon_r(x, y, poly$x, poly$y)
      inside <- xor(inside, ring_inside)
    }
  }
  inside
}

geo_point_in_polygon <- function(x, y, poly_x, poly_y) {
  if (exists("geo_point_in_polygon_cpp", mode = "function")) {
    return(geo_point_in_polygon_cpp(x, y, poly_x, poly_y))
  }
  geo_point_in_polygon_r(x, y, poly_x, poly_y)
}

geo_point_in_multipolygon <- function(x, y, border) {
  if (exists("geo_point_in_multipolygon_cpp", mode = "function")) {
    if (!is.null(border$lxv) && length(border$lxv) >= 2) {
      return(geo_point_in_multipolygon_cpp(
        x,
        y,
        border$lon,
        border$lat,
        border$lxv
      ))
    }
    if (!is.null(border$lon) && !is.null(border$lat)) {
      return(geo_point_in_polygon_cpp(x, y, border$lon, border$lat))
    }
  }
  geo_point_in_multipolygon_r(x, y, border)
}

geo_curvedist <- function(curve_x, curve_y, curve_d, pts_x, pts_y) {
  n_pts <- length(pts_x)
  dp <- rep(0, n_pts)
  mindist <- rep(Inf, n_pts)
  for (i in seq_len(n_pts)) {
    for (j in seq_len(length(curve_x) - 1)) {
      x1 <- curve_x[j]
      y1 <- curve_y[j]
      x2 <- curve_x[j + 1]
      y2 <- curve_y[j + 1]
      dx <- x2 - x1
      dy <- y2 - y1
      d <- dx * dx + dy * dy
      if (d == 0) {
        next
      }
      d1 <- (pts_x[i] - x1)^2 + (pts_y[i] - y1)^2
      d2 <- (pts_x[i] - x2)^2 + (pts_y[i] - y2)^2
      t <- (d + d1 - d2) / (2 * d)
      if (t >= -1 && t <= 2) {
        pardist <- t * sqrt(d)
        perdist <- sqrt(max(d1 - pardist * pardist, 0))
        if (perdist < mindist[i]) {
          mindist[i] <- perdist
          dp[i] <- curve_d[j] + pardist
        }
      }
    }
    if (!is.finite(mindist[i])) mindist[i] <- 99999
  }
  list(dp = dp, mindist = mindist)
}

geo_distance_latlon_rad <- function(lat, lon, lat1, lon1) {
  rad <- 6367
  tiny <- 1e-8
  if (abs(lat - lat1) + abs(lon - lon1) < tiny) {
    return(0)
  }
  val <- sin(lat) * sin(lat1) + cos(lat) * cos(lat1) * cos(lon - lon1)
  val <- min(1, max(-1, val))
  rad * acos(val)
}

geo_distance_xy <- function(x, y, x1, y1) {
  sqrt((x - x1)^2 + (y - y1)^2)
}

geo_distance_latlon_rad_vec <- function(lat, lon, lat1, lon1) {
  rad <- 6367
  val <- sin(lat) * sin(lat1) + cos(lat) * cos(lat1) * cos(lon - lon1)
  val <- pmin(1, pmax(-1, val))
  rad * acos(val)
}

geo_distance_xy_vec <- function(x, y, x1, y1) {
  sqrt((x - x1)^2 + (y - y1)^2)
}

geo_spherical_cov <- function(dist, range, sill, nugget) {
  if (range <= 0 || sill == 0) {
    return(0)
  }
  x <- dist / range
  cs <- ifelse(
    x > 1,
    0,
    (sill - (sill - nugget) * (1.5 * x - 0.5 * x^3) - nugget) / sill
  )
  cs
}

geo_variogram_impl <- function(
  lat,
  lon,
  z,
  ddist,
  nbins,
  Hawk,
  evennumber,
  zzp,
  xy
) {
  tiny <- 1e-5
  if (zzp == 1) {
    tiny <- -99999999
  }
  number <- integer(nbins)
  dist <- double(nbins)
  vario <- double(nbins)
  v1 <- 0.25
  v2 <- 4.0
  n <- length(z)
  for (i in 2:n) {
    for (j in 1:(i - 1)) {
      d <- if (xy == 1) {
        geo_distance_xy(lat[i], lon[i], lat[j], lon[j])
      } else {
        geo_distance_latlon_rad(lat[i], lon[i], lat[j], lon[j])
      }
      ind <- floor(d / ddist) + 1
      if (ind <= nbins && ((abs(z[i]) > tiny) || (abs(z[j]) > tiny))) {
        number[ind] <- number[ind] + 1
        dist[ind] <- dist[ind] + d
        diff <- (z[i] - z[j])^2
        if (Hawk == 1) {
          vario[ind] <- vario[ind] + diff^v1
        } else {
          vario[ind] <- vario[ind] + diff
        }
      }
    }
  }
  if (evennumber == 1) {
    total <- sum(number)
    target <- floor(total * 10 / nbins)
    varioa <- double(nbins)
    dista <- double(nbins)
    numbera <- integer(nbins)
    k <- 1
    for (i in seq_len(nbins)) {
      varioa[k] <- varioa[k] + vario[i]
      numbera[k] <- numbera[k] + number[i]
      dista[k] <- dista[k] + dist[i]
      if (numbera[k] > target) k <- k + 1
    }
    nbins <- max(k - 1, 1)
    number <- numbera[1:nbins]
    dist <- dista[1:nbins]
    vario <- varioa[1:nbins]
  }
  for (i in seq_len(nbins)) {
    if (number[i] != 0) {
      if (Hawk == 1) {
        vario[i] <- (vario[i] / number[i])^v2 / (0.457 + 0.494 / number[i])
      } else {
        vario[i] <- vario[i] / number[i]
      }
      dist[i] <- dist[i] / number[i]
    }
  }
  list(dist = dist, vario = vario, number = number, nbins = nbins)
}

geo_combinert_impl <- function(
  lat,
  lon,
  z,
  reitur,
  grdlat,
  grdlon,
  n,
  minnumber,
  option,
  fill,
  wlat,
  wz,
  rat
) {
  maxrt <- max(reitur)
  idx_by_cell <- split(seq_along(reitur), reitur)
  newlat <- numeric(0)
  newlon <- numeric(0)
  newz <- numeric(0)
  newn <- integer(0)
  fylla <- integer(0)
  for (i in 1:maxrt) {
    idx <- idx_by_cell[[as.character(i)]]
    if (!is.null(idx) && length(idx) >= minnumber) {
      if (option == 6) {
        for (j in idx) {
          newlat <- c(newlat, lat[j])
          newlon <- c(newlon, lon[j])
          newz <- c(newz, z[j])
          newn <- c(newn, length(idx))
          fylla <- c(fylla, 0)
        }
      } else if (option == 1) {
        wlat_sum <- sum(wlat[idx])
        wz_sum <- sum(wz[idx])
        if (wlat_sum == 0) {
          lat_mean <- mean(lat[idx])
          lon_mean <- mean(lon[idx])
        } else {
          lat_mean <- sum(lat[idx] * wlat[idx]) / wlat_sum
          lon_mean <- sum(lon[idx] * wlat[idx]) / wlat_sum
        }
        if (wz_sum == 0) {
          z_mean <- mean(z[idx])
        } else {
          z_mean <- sum(z[idx] * wz[idx]) / wz_sum
        }
        newlat <- c(newlat, lat_mean)
        newlon <- c(newlon, lon_mean)
        newz <- c(newz, z_mean)
        newn <- c(newn, length(idx))
        fylla <- c(fylla, 0)
      } else if (option == 2) {
        wlat_sum <- sum(wlat[idx])
        if (wlat_sum == 0) {
          lat_mean <- mean(lat[idx])
          lon_mean <- mean(lon[idx])
        } else {
          lat_mean <- sum(lat[idx] * wlat[idx]) / wlat_sum
          lon_mean <- sum(lon[idx] * wlat[idx]) / wlat_sum
        }
        newlat <- c(newlat, lat_mean)
        newlon <- c(newlon, lon_mean)
        newz <- c(newz, sum(z[idx]))
        newn <- c(newn, length(idx))
        fylla <- c(fylla, 0)
      } else if (option == 3) {
        ord <- order(z[idx])
        mid <- ceiling(length(ord) / 2)
        j <- idx[ord[mid]]
        newlat <- c(newlat, lat[j])
        newlon <- c(newlon, lon[j])
        newz <- c(newz, z[j])
        newn <- c(newn, length(idx))
        fylla <- c(fylla, 0)
      } else if (option == 4) {
        wlat_sum <- sum(wlat[idx])
        wz_sum <- sum(wz[idx])
        if (wlat_sum == 0) {
          lat_mean <- mean(lat[idx])
          lon_mean <- mean(lon[idx])
        } else {
          lat_mean <- sum(lat[idx] * wlat[idx]) / wlat_sum
          lon_mean <- sum(lon[idx] * wlat[idx]) / wlat_sum
        }
        tmp <- sum(z[idx] * wz[idx])
        tmp2 <- wz_sum
        if (tmp2 == 0) {
          tmp2 <- length(idx)
        }
        zvar <- (sum((z[idx]^2) * wz[idx]) - tmp * tmp * tmp2) / tmp2
        newlat <- c(newlat, lat_mean)
        newlon <- c(newlon, lon_mean)
        newz <- c(newz, zvar)
        newn <- c(newn, length(idx))
        fylla <- c(fylla, 0)
      } else if (option == 5) {
        if (length(idx) < 3) {
          for (j in idx) {
            newlat <- c(newlat, lat[j])
            newlon <- c(newlon, lon[j])
            newz <- c(newz, z[j])
            newn <- c(newn, length(idx))
            fylla <- c(fylla, 0)
          }
        } else {
          nr_out <- floor(rat * length(idx))
          if (nr_out < 1) {
            nr_out <- 1
          }
          nr1_out <- length(idx) - nr_out
          if (nr1_out > nr_out) {
            ord <- order(z[idx])
            keep <- ord[(nr_out + 1):nr1_out]
            for (j in idx[keep]) {
              newlat <- c(newlat, lat[j])
              newlon <- c(newlon, lon[j])
              newz <- c(newz, z[j])
              newn <- c(newn, i)
              fylla <- c(fylla, 0)
            }
          }
        }
      }
    } else if (fill == 1) {
      rnr <- (i - 1) %/% (n - 1)
      cnr <- i - rnr * (n - 1)
      newlat <- c(newlat, grdlat[rnr + 1])
      newlon <- c(newlon, grdlon[cnr])
      newz <- c(newz, 0)
      newn <- c(newn, 0)
      fylla <- c(fylla, 1)
    }
  }
  list(lat = newlat, lon = newlon, z = newz, n = newn, fill = fylla)
}

geo_pointkriging_impl_r <- function(
  lat,
  lon,
  z,
  latgr,
  longr,
  vgr,
  maxnumber,
  maxdist,
  option,
  minnumber,
  mz,
  zeroset,
  varcalc,
  sill,
  reitur,
  n,
  m,
  stdcrt,
  stdrrt,
  dir,
  i1,
  rat,
  treitur,
  isub = NULL,
  isubgr = NULL,
  subareas = 0,
  xy = 0,
  suboption = 1
) {
  ngrid <- length(latgr)
  zgr <- rep(mz, ngrid)
  variance <- rep(0, ngrid)
  lagrange <- rep(0, ngrid)
  range <- vgr[1]
  v_sill <- vgr[2]
  nugget <- vgr[3]

  maxrt <- max(reitur)
  points_by_reit <- vector("list", maxrt + 1)
  for (i in seq_along(reitur)) {
    rt <- reitur[i]
    if (is.na(rt)) {
      next
    }
    points_by_reit[[rt]] <- c(points_by_reit[[rt]], i)
  }

  geo_neighbour <- function(nr) {
    rownr <- floor((nr - 1) / n) + 1
    colnr <- nr - n * (rownr - 1)
    rt <- (rownr - 1) * (n + 1) + colnr
    qua <- integer(4)
    list_idx <- integer(500)
    ldir <- integer(500)
    k <- 0
    nrt <- 0
    sub <- (subareas == 1) && !is.null(isubgr) && isubgr[nr] > 0
    for (j1 in 1:(length(i1) - 1)) {
      start <- i1[j1] + 1
      end <- i1[j1 + 1]
      if (start > end) {
        next
      }
      for (i in start:end) {
        crt <- stdcrt[i] + colnr
        rrt <- stdrrt[i] + rownr
        if (rrt > 0 && crt > 0 && rrt <= (m + 1) && crt <= (n + 1)) {
          rt <- (rrt - 1) * (n + 1) + crt
          if (rt > maxrt) {
            next
          }
          pts <- points_by_reit[[rt]]
          if (length(pts) > 0) {
            nrt <- nrt + 1
            for (m1 in pts) {
              if (
                !sub ||
                  isubgr[nr] == isub[m1] ||
                  isubgr[nr] == 0 ||
                  isub[m1] == 0
              ) {
                if (qua[dir[i]] < rat / 2 * maxnumber) {
                  k <- k + 1
                  if (k > length(list_idx)) {
                    break
                  }
                  list_idx[k] <- m1
                  ldir[k] <- dir[i]
                  qua[dir[i]] <- qua[dir[i]] + 1
                }
              }
              if (k >= (rat * maxnumber)) break
            }
          }
        }
      }
      if (nrt >= maxnumber || k >= (rat * maxnumber)) break
    }
    if (k == 0) {
      return(list(list = integer(0), ldir = integer(0)))
    }
    list(list = list_idx[1:k], ldir = ldir[1:k])
  }

  geo_select_pts <- function(
    latgr_i,
    longr_i,
    list_idx,
    ldir_idx,
    maxnr,
    option_local
  ) {
    nlist <- length(list_idx)
    if (nlist == 0) {
      return(list(finallist = integer(0), maxnr = 0))
    }
    if (xy == 1) {
      dist <- geo_distance_xy_vec(
        lat[list_idx],
        lon[list_idx],
        latgr_i,
        longr_i
      )
    } else {
      dist <- geo_distance_latlon_rad_vec(
        lat[list_idx],
        lon[list_idx],
        latgr_i,
        longr_i
      )
    }
    order_idx <- order(dist)
    if (option_local == 1) {
      if (maxdist > 0 && dist[order_idx[1]] > maxdist) {
        return(list(finallist = integer(0), maxnr = 0))
      }
      keep <- list_idx[order_idx[1:min(maxnr, length(order_idx))]]
      return(list(finallist = keep, maxnr = length(keep)))
    }
    if (option_local == 2) {
      if (maxdist > 0 && dist[order_idx[1]] > maxdist) {
        return(list(finallist = integer(0), maxnr = 0))
      }
      keep <- integer(0)
      for (q in 1:4) {
        q_idx <- order_idx[ldir_idx[order_idx] == q]
        q_keep <- list_idx[q_idx[1:min(floor(maxnr / 4), length(q_idx))]]
        keep <- c(keep, q_keep)
      }
      return(list(finallist = keep, maxnr = length(keep)))
    }
    if (option_local == 3) {
      if (maxdist > 0 && dist[order_idx[1]] > maxdist) {
        return(list(finallist = integer(0), maxnr = 0))
      }
      use <- order_idx[1:min(maxnr, length(order_idx))]
      dist[use] <- dist[use] * treitur[list_idx[use]]
      treitur[list_idx[use]] <<- treitur[list_idx[use]] + 1
      order_idx <- order(dist)
      keep <- list_idx[order_idx[1:min(maxnr, length(order_idx))]]
      return(list(finallist = keep, maxnr = length(keep)))
    }
    if (option_local == 4) {
      if (maxdist <= 0) {
        return(list(finallist = integer(0), maxnr = 0))
      }
      keep <- list_idx[dist <= maxdist]
      return(list(finallist = keep, maxnr = length(keep)))
    }
    list(finallist = integer(0), maxnr = 0)
  }

  for (i in seq_len(ngrid)) {
    nb <- geo_neighbour(i)
    nlist <- length(nb$list)
    maxnr <- min(maxnumber, nlist)
    if (maxnr < minnumber) {
      zgr[i] <- mz
      next
    }
    sel <- geo_select_pts(latgr[i], longr[i], nb$list, nb$ldir, maxnr, option)
    if (sel$maxnr > maxnumber) {
      sel <- geo_select_pts(
        latgr[i],
        longr[i],
        nb$list,
        nb$ldir,
        maxnumber,
        suboption
      )
    }
    if (sel$maxnr < minnumber) {
      zgr[i] <- mz
      next
    }
    finallist <- sel$finallist
    nsel <- length(finallist)
    if (nsel < minnumber) {
      zgr[i] <- mz
      next
    }
    cov <- matrix(0, nsel + 1, nsel + 1)
    rhs <- numeric(nsel + 1)
    lat_sel <- lat[finallist]
    lon_sel <- lon[finallist]
    if (xy == 1) {
      dist_mat <- sqrt((lat_sel - t(lat_sel))^2 + (lon_sel - t(lon_sel))^2)
      dist_to_grid <- geo_distance_xy_vec(lat_sel, lon_sel, latgr[i], longr[i])
    } else {
      sin_lat <- sin(lat_sel)
      cos_lat <- cos(lat_sel)
      dist_mat <- outer(sin_lat, sin_lat, "*") +
        outer(cos_lat, cos_lat, "*") * cos(outer(lon_sel, lon_sel, "-"))
      dist_mat[dist_mat > 1] <- 1
      dist_mat[dist_mat < -1] <- -1
      dist_mat <- acos(dist_mat) * 6367
      dist_to_grid <- geo_distance_latlon_rad_vec(
        lat_sel,
        lon_sel,
        latgr[i],
        longr[i]
      )
    }
    for (a in seq_len(nsel)) {
      for (b in seq_len(nsel)) {
        d_ab <- dist_mat[a, b]
        if (
          subareas == 1 &&
            !is.null(isub) &&
            isub[finallist[a]] != isub[finallist[b]] &&
            isub[finallist[a]] != 0 &&
            isub[finallist[b]] != 0
        ) {
          cov[a, b] <- 0
        } else {
          cov[a, b] <- geo_spherical_cov(d_ab, range, v_sill, nugget)
        }
      }
      rhs[a] <- geo_spherical_cov(dist_to_grid[a], range, v_sill, nugget)
      cov[a, nsel + 1] <- 1
      cov[nsel + 1, a] <- 1
    }
    cov[nsel + 1, nsel + 1] <- 0
    rhs[nsel + 1] <- 1
    weights <- tryCatch(solve(cov, rhs), error = function(e) NULL)
    if (is.null(weights)) {
      zgr[i] <- mean(z[finallist])
      next
    }
    zgr[i] <- sum(weights[1:nsel] * z[finallist])
    if (zeroset == 1 && length(finallist) >= 2) {
      if (sum(z[finallist[1:2]]) == 0) zgr[i] <- 0
    }
    if (varcalc == 1) {
      variance[i] <- sill * (1 - sum(weights * rhs))
      lagrange[i] <- weights[nsel + 1]
    }
  }
  list(zgr = zgr, variance = variance, lagrange = lagrange)
}

geo_pointkriging_impl <- function(
  lat,
  lon,
  z,
  latgr,
  longr,
  vgr,
  maxnumber,
  maxdist,
  option,
  minnumber,
  mz,
  zeroset,
  varcalc,
  sill,
  reitur,
  n,
  m,
  stdcrt,
  stdrrt,
  dir,
  i1,
  rat,
  treitur,
  isub = NULL,
  isubgr = NULL,
  subareas = 0,
  xy = 0,
  suboption = 1
) {
  if (exists("geo_pointkriging_impl_cpp", mode = "function")) {
    return(geo_pointkriging_impl_cpp(
      lat,
      lon,
      z,
      latgr,
      longr,
      vgr,
      maxnumber,
      maxdist,
      option,
      minnumber,
      mz,
      zeroset,
      varcalc,
      sill,
      reitur,
      n,
      m,
      stdcrt,
      stdrrt,
      dir,
      i1,
      rat,
      treitur,
      isub,
      isubgr,
      subareas,
      xy,
      suboption
    ))
  }
  geo_pointkriging_impl_r(
    lat,
    lon,
    z,
    latgr,
    longr,
    vgr,
    maxnumber,
    maxdist,
    option,
    minnumber,
    mz,
    zeroset,
    varcalc,
    sill,
    reitur,
    n,
    m,
    stdcrt,
    stdrrt,
    dir,
    i1,
    rat,
    treitur,
    isub,
    isubgr,
    subareas,
    xy,
    suboption
  )
}

geo_segment_intersections <- function(p1, p2, poly_x, poly_y) {
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

geo_clip_segment_to_polygon <- function(p1, p2, poly_x, poly_y) {
  inter <- geo_segment_intersections(p1, p2, poly_x, poly_y)
  if (nrow(inter) == 0) {
    if (geo_point_in_polygon(p1[1], p1[2], poly_x, poly_y)) {
      return(list(rbind(p1, p2)))
    }
    return(list())
  }
  ts <- sort(unique(c(0, inter$t, 1)))
  out <- list()
  for (i in 1:(length(ts) - 1)) {
    t_mid <- (ts[i] + ts[i + 1]) / 2
    mid <- p1 + t_mid * (p2 - p1)
    if (geo_point_in_polygon(mid[1], mid[2], poly_x, poly_y)) {
      a <- p1 + ts[i] * (p2 - p1)
      b <- p1 + ts[i + 1] * (p2 - p1)
      out[[length(out) + 1]] <- rbind(a, b)
    }
  }
  out
}

geo_clip_polyline_to_polygon <- function(x, y, poly_x, poly_y) {
  if (exists("geo_clip_polyline_to_polygon_cpp", mode = "function")) {
    return(geo_clip_polyline_to_polygon_cpp(x, y, poly_x, poly_y))
  }
  parts <- geo_split_na(x, y)
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
      segs <- geo_clip_segment_to_polygon(p1, p2, poly_x, poly_y)
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

geo_findcut_polyclip <- function(x, xb, in_or_out) {
  if (!requireNamespace("polyclip", quietly = TRUE)) {
    stop("polyclip is required for polygon clipping")
  }
  x_polys <- geo_split_na(x$x, x$y)
  xb_polys <- geo_split_na(xb$x, xb$y)
  op <- if (in_or_out == 1) "minus" else "intersection"
  if (in_or_out == 1) {
    res <- polyclip::polyclip(xb_polys, x_polys, op = op)
  } else {
    res <- polyclip::polyclip(x_polys, xb_polys, op = op)
  }
  if (length(res) == 0) {
    return(invisible())
  }
  out_x <- numeric(0)
  out_y <- numeric(0)
  for (poly in res) {
    out_x <- c(out_x, poly$x, NA)
    out_y <- c(out_y, poly$y, NA)
  }
  if (length(out_x) > 0) {
    out_x <- out_x[-length(out_x)]
    out_y <- out_y[-length(out_y)]
  }
  list(x = out_x, y = out_y)
}
