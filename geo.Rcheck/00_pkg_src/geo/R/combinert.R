combinert <- function(
  lat,
  lon,
  z,
  nlat,
  reitur,
  pts_in_reit,
  npts_in_reit,
  indrt,
  jrt,
  maxrt,
  grdlat,
  grdlon,
  n,
  minnumber,
  option = 1,
  fill = 0,
  wsp = NULL,
  nr = NULL,
  order = NULL,
  wlat = NULL,
  rat = NULL,
  wz = NULL
) {
  # Gagnavistarbreytur
  newlat <- numeric()
  newlon <- numeric()
  newz <- numeric()
  newn <- integer()
  fylla <- integer()

  # Uppfæra fjölda punkta í hverjum reit
  for (i in seq_len(nlat)) {
    npts_in_reit[reitur[i]] <- npts_in_reit[reitur[i]] + 1
  }

  # Setja upp vísiaðgang inn í reit
  for (i in seq_len(maxrt)) {
    indrt[i + 1] <- indrt[i] + npts_in_reit[i]
  }

  # Raða punktum í viðeigandi reiti
  for (i in seq_len(nlat)) {
    if (npts_in_reit[reitur[i]] > 0) {
      idx <- indrt[reitur[i]] + jrt[reitur[i]]
      pts_in_reit[idx + 1] <- i
      jrt[reitur[i]] <- jrt[reitur[i]] + 1
    }
  }

  k <- 1 # Index í útgöngugildum

  for (i in 1:maxrt) {
    if (npts_in_reit[i] >= minnumber) {
      idxs <- pts_in_reit[(indrt[i] + 1):(indrt[i] + npts_in_reit[i])]

      if (option == 6) {
        # Allt
        for (j in idxs) {
          newlat[k] <- lat[j]
          newlon[k] <- lon[j]
          newz[k] <- z[j]
          newn[k] <- npts_in_reit[i]
          fylla[k] <- 0
          k <- k + 1
        }
      } else if (option == 1) {
        # Meðaltal með vægi
        tmp1 <- tmp2 <- 0
        lat_sum <- lon_sum <- z_sum <- 0
        for (j in idxs) {
          lat_sum <- lat_sum + lat[j] * wlat[j]
          lon_sum <- lon_sum + lon[j] * wlat[j]
          z_sum <- z_sum + z[j] * wz[j]
          tmp1 <- tmp1 + wlat[j]
          tmp2 <- tmp2 + wz[j]
        }
        if (tmp1 == 0) {
          lat_sum <- sum(lat[idxs])
          lon_sum <- sum(lon[idxs])
          tmp1 <- length(idxs)
        }
        if (tmp2 == 0) {
          z_sum <- sum(z[idxs])
          tmp2 <- length(idxs)
        }
        newlat[k] <- lat_sum / tmp1
        newlon[k] <- lon_sum / tmp1
        newz[k] <- z_sum / tmp2
        newn[k] <- npts_in_reit[i]
        fylla[k] <- 0
        k <- k + 1
      }
    } else if (fill == 1) {
      rnr <- (i - 1) %/% (n - 1)
      cnr <- i - (rnr) * (n - 1)
      newlat[k] <- grdlat[rnr + 1]
      newlon[k] <- grdlon[cnr]
      newz[k] <- 0
      fylla[k] <- 1
      k <- k + 1
    }
  }

  return(list(
    newlat = newlat,
    newlon = newlon,
    newz = newz,
    newn = newn,
    fylla = fylla,
    nnewlat = length(newlat)
  ))
}
