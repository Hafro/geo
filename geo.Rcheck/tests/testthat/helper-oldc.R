# Helper to compile and call legacy C routines for comparison.

geo_oldc_so <- function() {
  file.path(tempdir(), "geo_old.so")
}

geo_oldc_compile <- function() {
  so <- geo_oldc_so()
  if (file.exists(so)) {
    return(so)
  }
  c_dir <- if (requireNamespace("testthat", quietly = TRUE)) {
    testthat::test_path("..", "fixtures", "geo_old")
  } else {
    file.path("tests", "fixtures", "geo_old")
  }
  geo_c <- file.path(c_dir, "geo.c")
  init_c <- file.path(c_dir, "init.c")
  if (!file.exists(geo_c) || !file.exists(init_c)) {
    return(NULL)
  }
  build_dir <- tempfile("geo-oldc-")
  dir.create(build_dir, recursive = TRUE, showWarnings = FALSE)
  geo_tmp <- file.path(build_dir, "geo.c")
  init_tmp <- file.path(build_dir, "init.c")
  file.copy(geo_c, geo_tmp, overwrite = TRUE)
  file.copy(init_c, init_tmp, overwrite = TRUE)
  cmd <- file.path(R.home("bin"), "R")
  args <- c("CMD", "SHLIB", geo_tmp, init_tmp, "-o", so)
  # Force legacy C mode for K&R-era source (R 4.4+ defaults to -std=gnu2x).
  makevars <- tempfile("Makevars-geo-old-")
  writeLines(
    c(
      "CC=clang -std=gnu89",
      "CFLAGS=-std=gnu89",
      "SHLIB_CFLAGS=-std=gnu89",
      "C_STD=gnu89"
    ),
    makevars
  )
  env <- c(paste0("R_MAKEVARS_USER=", makevars))
  on.exit(
    {
      unlink(makevars)
      unlink(build_dir, recursive = TRUE)
    },
    add = TRUE
  )
  system2(cmd, args = args, stdout = TRUE, stderr = TRUE, env = env)
  if (!file.exists(so)) {
    return(NULL)
  }
  so
}

geo_oldc_pointkriging <- function(
  lat,
  lon,
  z,
  xgr,
  vfit,
  maxnumber = 12,
  scale = "km",
  option = 1,
  maxdist = 0,
  rat = 3,
  nb = 8,
  set = 0,
  areas = 0,
  varcalc = FALSE,
  sill = 0,
  minnumber = 2,
  suboption = 1,
  outside = TRUE,
  degree = 0,
  lognormal = FALSE,
  zeroset = FALSE
) {
  so <- geo_oldc_compile()
  if (is.null(so)) {
    return(NULL)
  }
  dyn.load(so)
  on.exit(dyn.unload(so), add = TRUE)

  if (is.null(vfit$rang1)) {
    vfit$rang1 <- vfit$range
  }
  vgr <- c(vfit$rang1, vfit$sill, vfit$nugget)
  ndata <- length(lat)
  d <- c(1, 3, 6)
  if (degree > 2) {
    degree <- 2
  }

  xxx <- bua(nb)
  stdrrt <- xxx$rrt
  stdcrt <- xxx$crt
  dir <- xxx$dir
  i1 <- xxx$i1

  if (length(xgr$grpt) == 0) {
    gr <- xgr
  } else {
    gr <- xgr$grpt
  }
  if (outside) {
    m <- length(gr$lat)
    n <- length(gr$lon)
    minlat <- gr$lat[1] - nb * (gr$lat[2] - gr$lat[1])
    maxlat <- gr$lat[m] + nb * (gr$lat[m] - gr$lat[m - 1])
    minlon <- gr$lon[1] - nb * (gr$lon[2] - gr$lon[1])
    maxlon <- gr$lon[n] + nb * (gr$lon[n] - gr$lon[n - 1])
    ind <- which(lat > minlat & lat < maxlat & lon > minlon & lon < maxlon)
    lat <- lat[ind]
    lon <- lon[ind]
    z <- z[ind]
    ndata <- length(lat)
  }

  if (length(xgr$grpt) == 0) {
    lat1 <- c(t(matrix(xgr$lat, length(xgr$lat), length(xgr$lon))))
    lon1 <- c(matrix(xgr$lon, length(xgr$lon), length(xgr$lat)))
    n <- length(xgr$lon)
    m <- length(xgr$lat)
    row <- cut(lat, c(-999, xgr$lat, 999), labels = FALSE)
    col <- cut(lon, c(-999, xgr$lon, 999), labels = FALSE)
    inni <- rep(1, length(lat1))
  }

  if (set == 0) {
    mz <- 0
  }
  if (set > 0) {
    mz <- mean(z)
  }
  if (set < 0) {
    mz <- -99999
  }

  reitur <- (n + 1) * (row - 1) + col
  treitur <- rep(1, ndata)
  pts.in.reit <- c(matrix(0, ndata * 1.2, 1))
  maxrt <- max(reitur)
  npts.in.reit <- rep(0, round((maxrt + 1) * 1.2))

  if (length(areas) > 1) {
    ind <- which(is.na(areas$lat))
    nareas <- length(ind) + 1
    ind <- c(0, ind, (length(areas$lat) + 1))
    isub <- rep(0, length(lat))
    isub1 <- rep(0, length(lat1))
    subareas <- 1
    for (i in seq_len(nareas)) {
      reg <- list(
        lat = areas$lat[(ind[i] + 1):(ind[i + 1] - 1)],
        lon = areas$lon[(ind[i] + 1):(ind[i + 1] - 1)]
      )
      border <- adapt(reg$lat, reg$lon)
      inn <- rep(0, length(lat))
      inn1 <- rep(0, length(lat1))
      a <- a1 <- rep(0, length(lat))
      inn <- .C(
        "marghc",
        as.double(lon),
        as.double(lat),
        as.integer(length(lat)),
        as.double(border$lon),
        as.double(border$lat),
        as.integer(length(border$lat)),
        as.integer(border$lxv),
        as.integer(length(border$lxv)),
        as.integer(inn),
        as.double(a),
        as.double(a1)
      )
      isub <- inn[[9]] * i + isub
      inn1 <- .C(
        "marghc",
        as.double(lon1),
        as.double(lat1),
        as.integer(length(lat1)),
        as.double(border$lon),
        as.double(border$lat),
        as.integer(length(border$lat)),
        as.integer(border$lxv),
        as.integer(length(border$lxv)),
        as.integer(inn1),
        as.double(a),
        as.double(a1)
      )
      isub1 <- inn1[[9]] * i + isub1
    }
  } else {
    subareas <- 0
    isub <- rep(0, length(lat))
    isub1 <- rep(0, length(lat1))
  }

  gr$lon <- (gr$lon * pi) / 180
  gr$lat <- (gr$lat * pi) / 180
  lat1 <- (lat1 * pi) / 180
  lon1 <- (lon1 * pi) / 180
  lat <- (lat * pi) / 180
  lon <- (lon * pi) / 180

  if (option == 4) {
    if (maxdist == 0) {
      maxdist <- vfit$rang1
    }
    d1 <- pdist(gr$lat[1], gr$lon[1], gr$lat[2], gr$lon[2])
    d2 <- pdist(gr$lat[1], gr$lon[1], gr$lat[1], gr$lon[2])
    nm <- max(c(floor(maxdist / d1 + 1), floor(maxdist / d2 + 1)))
    if (nm > nb) {
      nm <- nb
    }
    i1 <- c(0, i1[nm + 1])
  }

  cov <- c(matrix(0, maxnumber + d[degree + 1], maxnumber + d[degree + 1]))
  rhgtside <- x <- rhgtsbck <- rep(0, maxnumber + d[degree + 1])
  zgr <- variance <- lagrange <- rep(0, length(lat1))
  indrt <- jrt <- npts.in.reit
  if (varcalc && sill == 0) {
    sill <- vfit$sill
  }
  xy <- 0

  out <- .C(
    "c_pointkriging",
    as.double(lat),
    as.double(lon),
    as.double(z),
    as.integer(ndata),
    as.double(lat1),
    as.double(lon1),
    as.double(zgr),
    as.integer(length(lat1)),
    as.integer(reitur),
    as.integer(n),
    as.integer(m),
    as.integer(pts.in.reit),
    as.integer(npts.in.reit),
    as.integer(maxnumber),
    as.double(vgr),
    as.integer(stdcrt),
    as.integer(stdrrt),
    as.integer(dir),
    as.integer(i1),
    as.integer(length(i1)),
    as.integer(option),
    as.integer(inni),
    as.double(cov),
    as.double(rhgtside),
    as.double(x),
    as.integer(indrt),
    as.integer(jrt),
    as.integer(maxrt),
    as.integer(treitur),
    as.double(rat),
    as.double(maxdist),
    as.double(mz),
    as.integer(isub),
    as.integer(isub1),
    as.integer(subareas),
    as.double(variance),
    as.integer(varcalc),
    as.double(rhgtsbck),
    as.double(sill),
    as.integer(minnumber),
    as.integer(suboption),
    as.integer(xy),
    as.integer(d),
    as.double(lagrange),
    as.integer(zeroset)
  )

  zgr <- out[[7]]
  zgr[zgr == -99999] <- NA
  list(zgr = zgr, variance = out[[36]], lagrange = out[[44]])
}
