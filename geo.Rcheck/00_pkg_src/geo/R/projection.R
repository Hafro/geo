# Auto-generated grouping file: projection.R
# Original function definitions were moved here for maintainability.

# ---- Proj.R ----
#' Performs Mercator or Lambert projection of data.
#'
#' Performs Mercator, Lambert or no projection of data, as a default it will
#' perform the projection used in current plot.
#'
#'
#' @param a,b The input data to be projected, may be given as two vectors or as
#' list attributes, lat and lon (x and y if projection = none).
#' @param scale The scale used for the projection, (m, km or miles). Default is
#' the scale defined in geopar (the scale defined when the plot is
#' initialized).
#' @param b0 if projection = mercator b0 is the center of the mercator
#' projection. If projection = "Lambert" b0 and b1 are lattitudes defining the
#' Lambert projection. Default are the b0 and b1 defined in geopar.
#' @param b1 Second defining latitute for Lambert projection
#' @param l1 The longitude defining the Lambert projection, default is the l1
#' defined in geopar.
#' @param projection The projection of the data, legal projections are
#' "Mercator", "Lambert" and "none".
#' @param col.names This has to be set to the default value of c("lon", "lat"),
#' otherwise projection will be set to "none".
#' @return The function returns a list containing if projection = "none" x and
#' y, if projection is "Mercator" or "Lambert" it includes the projection
#' (projection), the scale (scale), lat and lon and x and y (the
#' distance in scale from point (0,0) in spherical coordinates.
#' @seealso \code{\link{invProj}}, \code{\link{geopar}}, \code{\link{geoplot}}.
#' @examples
#'
#'   # For an example of use for this function see i.e. init() where
#'   # it is called:
#' \dontrun{
#'   xgr <- Proj(lat, lon, scale, b0, b1, l1, projection)
#' }
#'
#' @export Proj
Proj <-
  function(
    a,
    b = 0,
    scale = getOption("geopar")$scale,
    b0 = getOption("geopar")$b0,
    b1 = getOption("geopar")$b1,
    l1 = getOption("geopar")$l1,
    projection = getOption("geopar")$projection,
    col.names = c("lon", "lat")
  ) {
    if (col.names[1] != "lon" || col.names[2] != "lat") {
      projection <- "none"
    }
    if (is.list(a)) {
      if (projection == "none") {
        b <- a$y
        a <- a$x
      } else {
        b <- a$lon
        a <- a$lat
      }
    }
    if (projection == "Lambert") {
      x <- lambert(a, b, b0, l1, b1, scale, old = T)
    } else if (projection == "Mercator") {
      x <- mercator(a, b, scale, b0)
    } else if (projection == "none") {
      x <- list(x = a, y = b)
    }
  }

# ---- invProj.R ----
#' Performs the inverse Mercator or Lambert projection of data.
#'
#' Accepts data in spherical coordinates with center lattitude 0 and longitude
#' 0 and performs an inverse Mercator, Lambert or no tranformation.
#'
#'
#' @param x,y The input data to be inversely projected, may be given as two
#' vectors or as list attributes (x and y).
#' @param scale The scale of the input date (m, km or miles), default is the
#' scale defined in geopar (the scale defined when the plot is initialized).
#' @param b0 if projection = Mercator b0 is the center of the Mercator
#' projection. If projection = Lambert b0, b1 are the latitudes defining the
#' Lambert projection. Default are the b0 and b1 defined in geopar.
#' @param b1 Second defining latitude for Lambert projection.
#' @param l1 The longitude defining the Lambert projection, default is the l1
#' defined in geopar.
#' @param projection The projection to be inversed, legal projections are
#' "mercator", "Lambert" and "none". Default is the projection defined in
#' geopar.
#' @return The function returns a list containing if projection = "none" x
#' and y, if projection is mercator or Lambert it includes the projection
#' (projection), the scale (scale), lat and lon and x and y.
#' @seealso \code{\link{invProj}}, \code{\link{geopar}}, \code{\link{geoplot}}.
#' @export invProj
invProj <-
  function(
    x,
    y = NULL,
    scale = getOption("geopar")$scale,
    b0 = getOption("geopar")$b0,
    b1 = getOption("geopar")$b1,
    l1 = getOption("geopar")$l1,
    projection = getOption("geopar")$projection
  ) {
    if (is.null(y)) {
      y <- x$y
      x <- x$x
    }
    if (projection == "Lambert") {
      x <- invlambert(x, y, b0, l1, b1, scale, old = T)
    } else if (projection == "Mercator") {
      x <- invmerc(x, y, scale, b0)
    } else if (projection == "none") {
      x <- list(x = x, y = y)
    }
  }

# ---- mercator.R ----
#' Mercator projection
#'
#' Mercator projection.
#'
#'
#' @param lat,lon Coordinates as latitude and longitude vectors
#' @param scale Scale of the output, "km" default, all other values imply
#' nautical miles.
#' @param b0 Latitude defining the projection.
#' @return List of components: \item{lat, lon }{Coordinates in latitude and
#' longitude} \item{x, y}{Input coordinates (projected)} \item{scale}{Scale}
#' \item{projection}{Projection (stated redunantly)} \item{b0, L0}{Defining lat
#' and a null value ???} is returned invisibly.
#' @note Needs elaboration, could/should (?) be documented with other
#' projection functions.
#' @seealso Called by \code{\link{geoarea}}, \code{\link{gridaxes}} and
#' \code{\link{Proj}}.
#' @keywords manip
#' @export mercator
mercator <-
  function(lat, lon, scale = "km", b0 = 65) {
    radius <- 6378.388
    m.p.km <- 1.852
    mult <- radius
    if (scale != "km") {
      mult <- mult / m.p.km
    }
    l1 <- (lon * pi) / 180
    b1 <- (lat * pi) / 180
    b0 <- (b0 * pi) / 180
    x <- mult * cos(b0) * l1
    y <- mult * cos(b0) * log((1 + sin(b1)) / cos(b1))
    return(invisible(list(
      lat = lat,
      lon = lon,
      x = x,
      y = y,
      scale = scale,
      projection = "mercator",
      b0 = b0,
      L0 = NULL
    )))
  }

# ---- invmerc.R ----
#' Inverse Mercator Projection
#'
#' Inverse Mercator Projection.
#'
#'
#' @param x,y The input data to be inversely projected as two vectors
#' @param scale Scale of the input data, "km" default, all other values imply
#' nautical miles.
#' @param b0 Latitude defining the projection.
#' @return List of components: \item{lat, lon }{Coordinates in latitude and
#' longitude} \item{x, y}{Input coordinates (projected)} \item{scale}{Scale}
#' \item{projection}{Projection (stated redunantly)} \item{b0, L0}{Defining lat
#' and a null value ???} is returned invisibly.
#' @note Needs elaboration and perhaps documenting with mercator in the same
#' doc-file.
#' @seealso Called by \code{\link{invProj}}.
#' @keywords manip
#' @export invmerc
invmerc <-
  function(x, y, scale = "km", b0 = 65) {
    radius <- 6378.388
    m.p.km <- 1.852
    mult <- radius
    if (scale != "km") {
      mult <- mult / m.p.km
    }
    b0 <- (b0 * pi) / 180
    lon <- (x / (mult * cos(b0)) * 180) / pi
    # Have to find latitude by iteration.
    c1 <- exp(y / (mult * cos(b0)))
    lat1 <- c(1:length(y))
    lat1[1:length(y)] <- b0
    # initial guess
    lat <- c(1:length(y))
    ind <- c(1:length(y))
    #index.
    ind <- ind[!is.na(c1)]
    # NA dont work in sum.
    while (sum(abs(lat1[ind] - lat[ind])) / sum(abs(lat[ind])) > 1e-07) {
      lat <- lat1
      lat1 <- lat -
        ((1 + sin(lat)) / cos(lat) - c1) /
          ((1 + sin(lat)) /
            (cos(lat)^2))
    }
    lat <- lat1
    lat <- (lat * 180) / pi
    return(invisible(list(
      lat = lat,
      lon = lon,
      x = x,
      y = y,
      scale = scale,
      projection = "mercator",
      b0 = b0,
      L0 = NULL
    )))
  }

# ---- lambert.R ----
#' Lambert projection
#'
#' Lambert projection.
#'
#'
#' @param lat,lon Coordinates as latitude and longitude vectors
#' @param lat0 First latitude defining of the projection
#' @param lon0 Longitude defining the projection
#' @param lat1 Second latitude defining the projection
#' @param scale Scale, default "km", redundant ??
#' @param old Old method ?
#' @return List of components: \item{lat, lon }{Coordinates in latitude and
#' longitude} \item{x, y}{Input coordinates (projected)} \item{scale}{Scale}
#' \item{projection}{Projection (stated redunantly)} \item{lat0, lon0,
#' lat1}{Defining lats and lon} is returned invisibly.
#' @note Needs elaboration, might be merged with docs for other proj-functions.
#' @seealso Called by \code{\link{geoarea}}, \code{\link{orthproj}} and
#' \code{\link{Proj}}.
#' @keywords manip
#' @export lambert
lambert <-
  function(lat, lon, lat0, lon0, lat1, scale = "km", old = F) {
    a <- 6378.388
    # radius at equator
    e <- sqrt(2 / 297 - (1 / 297)^2)
    # eccensitret.
    lat11 <- lat1
    # temporary storage
    # 	change to radians
    lat1 <- (lat1 * pi) / 180
    lat0 <- (lat0 * pi) / 180
    lon0 <- (lon0 * pi) / 180
    lat <- (lat * pi) / 180
    lon <- (lon * pi) / 180
    #	one or two touching points.
    if (length(lat1) == 2) {
      lat2 <- lat1[2]
      lat1 <- lat1[1]
      np <- 2
    } else {
      np <- 1
    }
    m1 <- cos(lat1) / sqrt(1 - e * e * (sin(lat1))^2)
    if (old) {
      t1 <- tan(pi / 4 - 1 / 2 * atan((1 - e * e) * tan(lat1)))
      t0 <- tan(pi / 4 - 1 / 2 * atan((1 - e * e) * tan(lat0)))
    } else {
      t1 <- tan(pi / 4 - lat1 / 2) /
        ((1 - e * sin(lat1)) /
          (1 +
            e *
              sin(
                lat1
              )))^(e / 2)
      t0 <- tan(pi / 4 - lat0 / 2) /
        ((1 - e * sin(lat0)) /
          (1 +
            e *
              sin(
                lat0
              )))^(e / 2)
    }
    # one tangent.
    if (np == 1) {
      n <- sin(lat1)
    } else {
      m2 <- cos(lat2) / (1 - e * e * (sin(lat2))^2)
      if (old) {
        t2 <- tan(pi / 4 - 1 / 2 * atan((1 - e * e) * tan(lat2)))
      } else {
        t2 <- tan(pi / 4 - lat2 / 2) /
          ((1 - e * sin(lat2)) /
            (1 +
              e *
                sin(lat2)))^(e / 2)
      }
      n <- (log(m1) - log(m2)) / (log(t1) - log(t2))
    }
    F1 <- m1 / (n * t1^n)
    p0 <- a * F1 * t0^n
    if (old) {
      t <- tan(pi / 4 - 1 / 2 * atan((1 - e * e) * tan(lat)))
    } else {
      t <- tan(pi / 4 - lat / 2) /
        ((1 - e * sin(lat)) / (1 + e * sin(lat)))^(e / 2)
    }
    p <- a * F1 * t^n
    theta <- n * (lon - lon0)
    x <- p * sin(theta)
    y <- p0 - p * cos(theta)
    return(invisible(list(
      lat = (lat * 180) / pi,
      lon = (lon * 180) / pi,
      x = x,
      y = y,
      scale = scale,
      projection = "Lambert",
      lat0 = (lat0 *
        180) /
        pi,
      lon0 = (lon0 * 180) / pi,
      lat1 = lat11
    )))
  }

# ---- invlambert.R ----
#' Inverse Lambert projection
#'
#' Inverse Lambert projection.
#'
#'
#' @param x,y The input data to be inversely projected as two vectors
#' @param lat0 First latitude defining of the projection
#' @param lon0 Longitude defining the projection
#' @param lat1 Second latitude defining the projection
#' @param scale Scale of the input data, "km" default, redundant ??
#' @param old Old method, seldom used???
#' @return List of components: \item{lat, lon }{Coordinates in latitude and
#' longitude} \item{x, y}{Input coordinates (projected)} \item{scale}{Scale}
#' \item{projection}{Projection (stated redunantly)} \item{lat0, lon0,
#' lat1}{Defining lats and lon} is returned invisibly.
#' @note Needs elaboration and perhaps documenting with lambert in the same
#' doc-file.
#' @seealso Called by \code{\link{invProj}}.
#' @keywords manip
#' @export invlambert
invlambert <-
  function(x, y, lat0, lon0, lat1, scale = "km", old = F) {
    a <- 6378.388
    # radius at equator
    e <- sqrt(2 / 297 - (1 / 297)^2)
    # eccensitret.
    lat11 <- lat1
    # temporary storage
    # 	change to radians
    lat1 <- (lat1 * pi) / 180
    lat0 <- (lat0 * pi) / 180
    lon0 <- (lon0 * pi) / 180
    #	one or two touching points.
    if (length(lat1) == 2) {
      lat2 <- lat1[2]
      lat1 <- lat1[1]
      np <- 2
    } else {
      np <- 1
    }
    m1 <- cos(lat1) / sqrt(1 - e * e * (sin(lat1))^2)
    if (old) {
      t1 <- tan(pi / 4 - 1 / 2 * atan((1 - e * e) * tan(lat1)))
      t0 <- tan(pi / 4 - 1 / 2 * atan((1 - e * e) * tan(lat0)))
    } else {
      t1 <- tan(pi / 4 - lat1 / 2) /
        ((1 - e * sin(lat1)) /
          (1 +
            e *
              sin(
                lat1
              )))^(e / 2)
      t0 <- tan(pi / 4 - lat0 / 2) /
        ((1 - e * sin(lat0)) /
          (1 +
            e *
              sin(
                lat0
              )))^(e / 2)
    }
    # one tangent.
    if (np == 1) {
      n <- sin(lat1)
    } else {
      m2 <- cos(lat2) / (1 - e * e * (sin(lat2))^2)
      if (old) {
        t2 <- tan(pi / 4 - 1 / 2 * atan((1 - e * e) * tan(lat2)))
      } else {
        t2 <- tan(pi / 4 - lat2 / 2) /
          ((1 - e * sin(lat2)) /
            (1 +
              e *
                sin(lat2)))^(e / 2)
      }
      n <- (log(m1) - log(m2)) / (log(t1) - log(t2))
    }
    F1 <- m1 / (n * t1^n)
    p0 <- a * F1 * t0^n
    p <- sign(n) * sqrt(x^2 + (p0 - y)^2)
    theta <- atan(x / (p0 - y))
    t <- (p / (a * F1))^(1 / n)
    lon <- theta / n + lon0
    lat <- pi / 2 - 2 * atan(t)
    for (i in 1:2) {
      # very rapid convergence in all cases.
      lat <- pi /
        2 -
        2 *
          atan(
            t *
              ((1 - e * sin(lat)) /
                (1 +
                  e *
                    sin(
                      lat
                    )))^(e / 2)
          )
    }
    return(invisible(list(
      lat = (lat * 180) / pi,
      lon = (lon * 180) / pi,
      x = x,
      y = y,
      scale = scale,
      projection = "lambert",
      lat0 = (lat0 *
        180) /
        pi,
      lon0 = (lon0 * 180) / pi,
      lat1 = lat11
    )))
  }

# ---- orthproj.R ----
#' Performs an orthogonal projection to a curve.
#'
#' Finds curve coordinates of points, given points and a curve it returns the
#' length of the points orhogonal projection and the distance traveled to the
#' projection from a given origin on the curve.
#'
#'
#' @param pts A list containing the points as lat and lon, you may also use
#' geolocator.
#' @param curve The curve to be used for projection.
#' @return Returns a dataframe with vectors pardist (length of orthogonal
#' projection) and perdist (how far traveled alongst the curve).
#' @section Side Effects: None.
#' @seealso \code{\link{geocurve}}, \code{\link{geolocator}}.
#' @examples
#'
#'
#' \dontrun{       geoplot(my.curve)     # Plot curve and initialize plot.
#'        geocurve(geolocator(),my.curve)         # Mark points.
#' }
#' @export orthproj
orthproj <-
  function(pts, curve) {
    pts1 <- lambert(pts$lat, pts$lon, 65, -18, 65)
    curve1 <- lambert(curve$lat, curve$lon, 65, -18, 65)
    pts$x <- pts1$x / 1.852
    pts$y <- pts1$y / 1.852
    curve$x <- curve1$x / 1.852
    curve$y <- curve1$y / 1.852
    pardist <- perdist <- rep(0, length(pts$lat))
    x <- geo_curvedist(curve$x, curve$y, curve$dist, pts$x, pts$y)
    pardist <- x$dp
    perdist <- x$mindist
    # Points inside curve get negative perdist.
    i <- geoinside(pts, reg = curve, option = 0, robust = F)
    perdist[i] <- -perdist[i]
    return(list(pardist = pardist, perdist = perdist))
  }

# ---- spherical.R ----
#' Spherical??
#'
#' 'Spherical' of a variogram?
#'
#'
#' @param rang1,sill,nugget Parameters of a variogram.
#' @param x The data.
#' @return Fitted values?
#' @note Needs elaboration, if this is a necessary function.
#' @seealso Some variogram stuff.
#' @keywords arith
#' @export spherical
"spherical" <-
  function(rang1, sill, nugget, x) {
    x <- x / rang1
    return(
      (((sill - nugget) * (1.5 * x - 0.5 * x^3) + nugget) *
        (1 -
          sign(
            x - 1
          ))) /
        2 +
        (sill * (1 + sign(x - 1))) / 2
    )
  }
