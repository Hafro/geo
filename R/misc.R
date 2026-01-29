# Auto-generated grouping file: misc.R
# Original function definitions were moved here for maintainability.

# ---- geoidentify.R ----
#' Identifies points on plots using lat and lon coordinates.
#'
#' Works the same way as identify except that it also accepts coordinates as
#' lat and lon.  Identifies points on a plot identified by the user.
#'
#' Observations that have missing values in either lat or lon are treated as if
#' they were not given.  When using the X11 driver under the X Window System, a
#' point is identified by positioning the cursor over the point and pressing
#' the left button.  To exit identify press the middle button (both buttons on
#' a two button mouse) while the cursor is in the graphics window.  The same
#' procedure is used under the suntools driver.  This function may also be used
#' with the "tek" drivers.
#'
#' Some devices that do not allow interaction prompt you for an x,y pair. The
#' nearest point to the locator position is identified, but must be at most 0.5
#' inches away.  In case of ties, the earliest point is identified.
#'
#' @param lat,lon Coordinates of points.  The coordinates can be given by two
#' vectors or a data.frame containin vectors \code{lat} and \code{lon}.
#' @param labels Vector giving labels for each of the points.  If supplied,
#' this must have the same length as lat and lon.  As a default the vector
#' indece number of the points will be used.
#' @param n Maximum number of points to be identified.
#' @param plot If true, geoidentify plots the labels if the points identified.
#' @param atpen If true, plotted identification is relative to locator position
#' when the point is identified; otherwise, plotting is relative to the
#' identified lat,lon value. This can be useful when points are crowded.
#' Default is true.
#' @param offset Identification is plotted as a text string, moved offset
#' charecter from the point.  If the locator was left (right) of the nearest
#' point, the label will be offset to the left (right) of the point.
#' @param col The color of the labels.
#' @param cex Character size expansion of label characters.
#' @return Indeces (in lat and lon) corresponding to the identified points.
#' @section Side Effects: Labels are placed on the current plot if plot is
#' true.
#' @seealso \code{\link{identify}}, \code{\link{geolocator}},
#' \code{\link{geotext}}.
#' @examples
#'
#' \dontrun{       geoidentify(stations, labels = stations$temp)
#'        # plots the temperature in the closest measuring point.
#'
#'        geoidentify(stations, atpen = FALSE)
#'        # plots the indece number of the station closest to
#'        # where pointed at the stations position.
#' }
#' @export geoidentify
geoidentify <-
  function(
    lat,
    lon = NULL,
    labels = 1,
    n = 0,
    plot = TRUE,
    atpen = TRUE,
    offset = 0.5,
    col = 1,
    cex = 1
  ) {
    geopar <- getOption("geopar")
    oldpar <- selectedpar()
    par(geopar$gpar)
    par(cex = cex)
    par(col = col)
    on.exit(par(oldpar))
    if (is.null(lon)) {
      if (geopar$projection == "none") {
        lon <- lat$y
        lat <- lat$x
      } else {
        lon <- lat$lon
        lat <- lat$lat
      }
    }
    if (geopar$projection != "none") {
      # degrees and minutes
      if (mean(lat, na.rm = TRUE) > 1000) {
        lat <- geoconvert(lat)
        lon <- -geoconvert(lon)
      }
    }
    if (length(labels) == 1 && length(lat) > 1) {
      labels <- seq(along = lat)
    }
    if (n == 0) {
      n <- length(lat)
    }
    xx <- Proj(
      lat,
      lon,
      geopar$scale,
      geopar$b0,
      geopar$b1,
      geopar$l1,
      geopar$projection
    )
    z <- identify(
      xx$x,
      xx$y,
      labels = labels,
      n = n,
      plot = plot,
      atpen = atpen,
      offset = offset
    )
    return(z)
  }

# ---- geolocator.R ----
#' Locates points on a plot initialized by geoplot.
#'
#' The function locates points on a plot initialized by geoplot returning their
#' latitude and longitude.
#'
#'
#' @param type Same parameter as in the locator function.  Type = "l" draws
#' line between points.
#' @param n Number of points. Default value is zero, then the point coordinates
#' are located till the mouse' middle button is clicked.
#' @return A list with components \code{$lat} and \code{$lon}.  or (\code{$x,
#' $y} if \code{geopar$projection = "none"})
#' @seealso \code{\link{geoplot}}, \code{\link{locator}},
#' \code{\link{geodefine}}.
#' @export geolocator
geolocator <-
  function(type = "p", n = 0) {
    geopar <- getOption("geopar")
    oldpar <- selectedpar()
    par(geopar$gpar)
    on.exit(par(oldpar))
    if (n == 0) {
      x <- locator(type = type)
    } else {
      x <- locator(type = type, n = n)
    }
    if (!is.null(x$x)) {
      lat <- invProj(
        x$x,
        x$y,
        geopar$scale,
        geopar$b0,
        geopar$b1,
        geopar$l1,
        projection = geopar$projection
      )
      if (geopar$projection == "none") {
        return(x <- data.frame(x = lat$x, y = lat$y))
      } else {
        return(lat <- data.frame(lat = lat$lat, lon = lat$lon))
      }
    } else {
      return(list())
    }
  }

# ---- geotows.R ----
#' Plot tows as line segments
#'
#' The function gets 4 arguments i.e position of begininning and end of
#' segments.  If the first argument is given col.names gives the column names
#' in the data frame describing the position.
#'
#'
#' @param lat Vector of start position latitudes, dataframe of start positions
#'  given in columns \code{lat} and \code{lon} or dataframe with start and end
#'  positions given as columns \code{col.names}.
#' @param lon When given, vector of start position longitudes.
#' @param lat1 When given, vector of end position latitudes or a data frame
#'  of end positions given in columns \code{lat} and \code{lon}.
#' @param lon1 When given, vector of end position longitudes.
#' @param col Color of line segments.
#' @param col.names  Column names of start lat and lon and end lat and lon
#'  when  \code{tows} are given in a single dataframe. Defaults to column
#'  names in the Hafro/MRI database table \code{fiskar.stodvar}.
#' @param \dots Additional arguments to \code{geolines}.
#' @seealso \code{\link{geolines}}
#' @keywords aplot
#' @export geotows
geotows <-
  function(
    lat,
    lon,
    lat1,
    lon1,
    col = 1,
    col.names = c(
      "kastad.n.breidd",
      "kastad.v.lengd",
      "hift.n.breidd",
      "hift.v.lengd"
    ),
    ...
  ) {
    if (is.data.frame(lat) && missing(lat1)) {
      lat1 <- lat[, col.names[3]]
      lon1 <- lat[, col.names[4]]
      lon <- lat[, col.names[2]]
      lat <- lat[, col.names[1]]
    }
    if (is.data.frame(lat) && !missing(lat1)) {
      lon <- lat$lon
      lat <- lat$lat
      lon1 <- lat1$lon
      lat1 <- lat1$lat
    }
    lat <- matrix(lat, length(lat), 3)
    lat[, 2] <- lat1
    lat[, 3] <- NA
    lat <- c(t(lat))
    lon <- matrix(lon, length(lon), 3)
    lon[, 2] <- lon1
    lon[, 3] <- NA
    lon <- c(t(lon))
    geolines(lat, lon, col = col, ...)
    return(invisible())
  }

# ---- gbplot.R ----
#' GEBCO plot. Plots equidepth lines.
#'
#' Plots lines of equal depths using a database from GEBCO.
#'
#'
#' @param depth A vector of the depths which we want equidept lines plotted.
#' @param col The colour of the lines, if the col vector is shorter than the
#' depth vector it is repeated.  Default is all lines black.
#' @param lty Linetype, if the lty vector is shorter than the depth vector it
#' is repeated.  Default is all lines have linetype 1.
#' @param lwd Linewidth, if the lwd vector is shorter than the depth vector it
#' is repeated. Default is all lines have linewidth 1.
#' @param depthlab A boolean variable determening whether labels should be
#' printed on equidepth lines, default is false.
#' @param depthlabcex The size of depthlabels.
#' @return None
#' @section Side Effects: Plots equidepth lines on current plot.
#' @seealso \code{\link{geoplot}}, \code{\link{geolines}}.
#' @examples
#'
#'    geoplot()   # Set up plot.
#'
#'    gbplot(c(100,500,1000),depthlab=T,depthlabcex=0.2)
#'    # Plot depthlines for 100,500,1000,1500 m, showing the
#'    # depth on the line.
#'
#' @export gbplot
gbplot <-
  function(depth, col, lty, lwd, depthlab, depthlabcex) {
    if (missing(depthlabcex)) {
      depthlabcex <- 0.7
    }
    if (missing(lwd)) {
      lwd <- rep(1, length(depth))
    }
    if (missing(lty)) {
      lty <- rep(1, length(depth))
    }
    if (missing(col)) {
      col <- rep(1, length(depth))
    }
    if (length(col) < length(depth)) {
      col[(length(col) + 1):length(depth)] <- col[length(col)]
    }
    if (length(lwd) < length(depth)) {
      lwd[(length(lwd) + 1):length(depth)] <- lwd[length(lwd)]
    }
    if (length(lty) < length(depth)) {
      lty[(length(lty) + 1):length(depth)] <- lty[length(lty)]
    }
    for (i in 1:length(depth)) {
      dypi <- depth[i]
      if (dypi %% 100 != 0 || dypi == 300 || dypi == 700) {
        print(paste(dypi, "m does not exist in GEBCO data"))
        return(invisible())
      }
      if (dypi <= 1000 || dypi == 1200 || dypi == 1500 || dypi == 2000) {
        txt <- paste(
          "geolines(gbdypi.",
          dypi,
          ",col=col[i],lwd=lwd[i],lty=lty[i])",
          sep = ""
        )
      } else {
        j <- match(dypi, names(geo::gbdypi))
        txt <- paste(
          "geolines(gbdypi[[",
          j,
          "]],col=col[i],lwd=lwd[i],lty=lty[i])",
          sep = ""
        )
      }
      eval(parse(text = txt))
      if (!missing(depthlab)) {
        k <- !is.na(match(geo::depthloc$z, dypi))
        if (any(k)) {
          geotext(
            geo::depthloc[k, ],
            z = geo::depthloc[k, "z"],
            cex = depthlabcex
          )
        }
      }
    }
    return(invisible())
  }

# ---- arcdist.R ----
#' Geographical distance computations
#'
#' Computes distances between lat/lon data points.
#'
#'
#' @param lat Latitude of first coordinate or list with lat, lon of first
#' coordinate.
#' @param lon Longitude of first coordinate or list with lat, lon of second
#' coordinate.
#' @param lat1,lon1 If lat and lon are vectors of lat,lon positions, then lat1
#' and lon1 must be given as the second set of positions.
#' @param scale \code{nmi} returns value in nautical miles, any other value in
#' kilometers
#' @return A single vector of distances between pairs of points is returned
#' @seealso \code{\link{geoplot}}, \code{\link{geotext}}, \code{\link{selpos}},
#' @examples
#'
#'   pos1 <- list(lat = c(65, 66), lon = c(-19, -20))
#'   pos2 <- list(lat = c(64, 65), lon = c(-19, -20))
#'   dists <- arcdist(pos1, pos2)         # pos1 and pos2 are lists of coordinates.
#'   lat <- c(65, 66)
#'   lon <- c(-19, -20)
#'   lat1 <- c(64, 65)
#'   lon1 <- c(-19, -20)
#'   dists <- arcdist(lat, lon, lat1, lon1) # Input in vector format.
#'
#' @export arcdist
arcdist <-
  function(lat, lon, lat1 = NULL, lon1 = NULL, scale = "nmi") {
    if (is.null(lat1)) {
      lat1 <- lon$lat
      lon1 <- lon$lon
      lon <- lat$lon
      lat <- lat$lat
    }
    if (scale == "nmi") {
      miles <- 1.852
    } else {
      miles <- 1
    }
    rad <- 6367
    #radius of earth in km
    mult1 <- (rad / miles)
    mult2 <- pi / 180
    return(
      mult1 *
        acos(
          sin(mult2 * lat) *
            sin(mult2 * lat1) +
            cos(
              mult2 *
                lat
            ) *
              cos(mult2 * lat1) *
              cos(mult2 * lon - mult2 * lon1)
        )
    )
  }

# ---- pdist.R ----
#' Spherical (?) distance
#'
#' Spherical (?) distance.
#'
#'
#' @param lat,lon Coordinate vectors of starting positions in lat/lon
#' @param lat1,lon1 Coordinate vectors of end positions in lat/lon
#' @return Distance in kilometers.
#' @note Why not use \code{arcdist}? Distance functins could be documented in
#' one file.
#' @seealso Called by \code{\link{pointkriging}} and \code{\link{variogram}}.
#' @keywords manip
#' @export pdist
pdist <-
  function(lat, lon, lat1, lon1) {
    rad <- 6367
    #radius of earth in km
    return(
      rad *
        acos(
          sin(lat) *
            sin(lat1) +
            cos(lat) *
              cos(lat1) *
              cos(
                lon - lon1
              )
        )
    )
  }

# ---- pdistx.R ----
#' Euclidian distance
#'
#' Euclidian distance.
#'
#'
#' @param y,x Coordinate vectors of starting positions
#' @param y1,x1 Coordinate vectors of end positions
#' @return Euclidian distance
#' @note Check order of coordinates (?), document distance functions together?
#' @seealso Called by \code{\link{variogram}}.
#' @keywords manip
#' @export pdistx
pdistx <-
  function(y, x, y1, x1) {
    return(sqrt((x - x1)^2. + (y - y1)^2.))
  }

# ---- locdist.R ----
#' Distance between two locations
#'
#' Distance between two locations set out by clicking on a geo--plot.
#'
#'
#' @param scale Unit of returned distance, default "nmi" for nautical miles,
#' all other values return kilometers
#' @param type Display points "p" or lines "l" between clicks, "n" for nothing
#' @return Returns distance between two point clicks on a geoplot.
#' @note Rather limited functionality, could be built further?
#' @seealso Calls \code{\link{arcdist}} and \code{\link{geolocator}}.
#' @keywords iplot
#' @export locdist
locdist <-
  function(scale = "nmi", type = "p") {
    lat <- geolocator(n = 2, type = type)
    x <- arcdist(lat$lat[1], lat$lon[1], lat$lat[2], lat$lon[2])
    if (scale == "km") {
      x <- x * 1.852
    }
    return(x)
  }

# ---- intra.point.dist.R ----
#' Intra point/position distance
#'
#' For a data frame of positions return the vector of intra point distances
#'
#'
#' @param x List of positions with components \code{lat} and \code{lon}.
#' @return Vector of distances between the points in \code{x}.
#' @seealso \code{\link{arcdist}}
#' @keywords arith
#' @examples
#'
#' # distances along the perimeter of a statistical rectangle
#' pos <- rPeri(323)
#' intra.point.dist(pos)
#' sum(intra.point.dist(pos))
#'
#' @export intra.point.dist
intra.point.dist <-
  function(x) {
    n <- length(x$lat)
    arcdist(x$lat[-n], x$lon[-n], x$lat[-1], x$lon[-1])
  }

# ---- apply.shrink.R ----
#' Apply a function to a vector for a combination of categories.
#'
#' Apply a function to a vector for a combination of categories.
#'
#'
#' @param X Input data to \code{FUN}
#' @param INDICES list of categories to be combined
#' @param FUN Function to be applied
#' @param names Column names for the resulting dataframe
#' @param \dots Additional arguments to \code{FUN}
#' @return Dataframe of outcomes applying \code{FUN} to \code{X} for the
#' combination of categories in \code{INDICES}
#' @note Needs elaboration, or could be dropped/hidden, use merge instead.
#' @seealso \code{\link{apply.shrink.dataframe}}, \code{\link{merge}}
#' @keywords manip
#' @examples
#'
#' ## stupid example, showing naming of results
#' names(apply.shrink(depthloc$z,
#'   list(a=round(depthloc$lat), b=round(depthloc$lon)), mean))
#' names(apply.shrink(depthloc$z, list(round(depthloc$lat),
#'   round(depthloc$lon)), mean, names = c("a", "b", "z")))
#'
#' @export apply.shrink
apply.shrink <-
  function(X, INDICES, FUN = NULL, names, ...) {
    # GJ 9/94.
    # 'apply.shrink' is identical to 'tapply' (see tapply).
    # But it returns a data.frame were each 'index' represent a column
    # and an extra column for the result of evaluating FUN for the partation
    # on X given by the INDICES.
    if (missing(FUN)) {
      stop(
        "No function to apply to data given (missing argument FUN)"
      )
    }
    if (!is.list(INDICES)) {
      INDICES <- list(INDICES)
    }
    len.data <- length(X)
    all.indices <- rep(0., len.data)
    for (i in rev(INDICES)) {
      # combine all indices to one
      if (length(i) != len.data) {
        stop(
          "Data and all indices must have same length"
        )
      }
      i <- as.factor(i)
      #		i <- as.category(i)
      all.indices <- all.indices *
        length(levels(i)) +
        (as.vector(
          unclass(i)
        ) -
          1.)
    }
    # one-origin
    all.indices <- all.indices + 1.
    INDICES <- as.data.frame(INDICES)
    INDICES <- INDICES[
      match(sort(unique(all.indices)), all.indices, nomatch = 0.),
    ]
    if (is.character(FUN)) {
      FUN <- getFunction(FUN)
    } else if (mode(FUN) != "function") {
      farg <- substitute(FUN)
      if (mode(farg) == "name") {
        FUN <- getFunction(farg)
      } else {
        stop(paste("\"", farg, "\" is not a function", sep = ""))
      }
    }
    X <- split(X, all.indices)
    X.apply <- lapply(X, FUN, ...)
    numb.FUN.value <- length(X.apply[[1.]])
    if (numb.FUN.value == 1.) {
      X.apply <- data.frame(X = unlist(X.apply))
    } else {
      X.apply <- data.frame(matrix(
        unlist(X.apply),
        ncol = numb.FUN.value,
        byrow = T,
        dimnames = list(
          NULL,
          names(
            X.apply[[1.]]
          )
        )
      ))
    }
    X.apply <- cbind(INDICES, X.apply)
    if (!missing(names)) {
      names(X.apply) <- names
    }
    return(X.apply)
  }

# ---- apply.shrink.dataframe.R ----
#' Apply functions to columns in a dataframe
#'
#' \code{apply.shrink} for a dataframe, different functions can be applied to
#' different columns, one for each column (?).
#'
#'
#' @param data Input dataframe
#' @param name.x Input value columns
#' @param name.ind Category columns
#' @param FUNS Functions to apply
#' @param NA.rm na-action, default FALSE
#' @param resp.name ???
#' @param full.data.frame ???
#' @param Set ?
#' @param name.res User selected values for the results columns
#' @param \dots Additional arguments (to what???
#' @return Dataframe of variouse outcomes.
#' @note Needs elaboration, although \dots{} are included in the arguments list
#' they don't seem to be used anywhere.
#' @seealso \code{\link{apply.shrink}}, \code{\link{merge}}
#' @keywords manip
#' @export apply.shrink.dataframe
apply.shrink.dataframe <-
  function(
    data,
    name.x,
    name.ind,
    FUNS = NULL,
    NA.rm = FALSE,
    resp.name = NULL,
    full.data.frame = FALSE,
    Set = NA,
    name.res,
    ...
  ) {
    COUNT <- function(x) {
      return(length(x))
    }
    FUNS <- as.character(substitute(FUNS))
    if (!is.na(match(FUNS[1], "c"))) {
      FUNS <- FUNS[2:length(FUNS)]
    }
    i <- match(name.ind, names(data))
    if (any(is.na(i))) {
      i1 <- c(1.:length(i))
      i1 <- i1[is.na(i)]
      stop(paste("Column", name.ind[i1], "does not exist"))
    }
    i <- match(name.x, c(names(data), "NR"))
    if (any(is.na(i))) {
      i1 <- c(1.:length(i))
      i1 <- i1[is.na(i)]
      stop(paste("Column", name.x[i1], "does not exist"))
    }
    data$NR <- rep(1., nrow(data))
    i <- match("", name.x)
    # Remove NA values
    if (!is.na(i)) {
      name.x[i] <- "NR"
    }
    i <- rep(1., nrow(data))
    if (NA.rm) {
      k <- match(name.x, names(data))
      for (j in 1.:length(name.x)) {
        if (is.numeric(data[, k[j]])) {
          i <- i & !is.na(data[, k[j]])
        }
      }
      data <- data[i, ]
    }
    if (length(name.x) > 1 && length(FUNS) == 1) {
      FUNS <- rep(FUNS, length(name.x))
    }
    if (length(name.x) == 1 & length(FUNS) > 1) {
      name.x <- rep(name.x, length(FUNS))
    }
    if (missing(name.res)) {
      name.res <- paste(name.x, FUNS, sep = ".")
    }
    name.res <- c(name.ind, name.res)
    indices <- list()
    for (i in 1:length(name.ind)) {
      indices[[i]] <- data[, name.ind[i]]
    }
    if (full.data.frame) {
      x <- tapply(rep(1, nrow(data)), indices, sum)
      result <- expand.grid(dimnames(x))
      x <- c(x)
      j <- is.na(x)
      for (i in 1:length(FUNS)) {
        x <- c(tapply(data[, name.x[i]], indices, FUNS[i]))
        if (any(j)) {
          x[j] <- Set
        }
        result <- cbind(result, x)
      }
    } else {
      for (i in 1:length(FUNS)) {
        x <- apply.shrink(
          data[, name.x[i]],
          indices,
          FUNS[
            i
          ]
        )
        if (i == 1) {
          result <- x
        } else {
          result <- cbind(result, x[, ncol(x)])
        }
      }
    }
    names(result) <- name.res
    return(result)
  }

# ---- adapt.R ----
#' Adapts geographical positions
#'
#' Adapts geographical positions for further geo-use.
#'
#'
#' @param reg.lat Latitude or y-coordinate
#' @param reg.lon Longitude or x-coordinate
#' @param projection Projection, default "Mercator", "none" denotes x/y
#' coordinates
#' @return Returns a list of either: \item{x, y}{x- and y-positions} or:
#' \item{lat, lon}{Latitude and longitude} and: \item{lxv}{index of
#' uninterupted/contiguous positions}
#' @note Needs further elaboration, this function is called by
#' \code{geoarea.old}, \code{geoinside}, \code{inside} and \code{pointkriging}.
#' @keywords manip
#' @export adapt
adapt <-
  function(reg.lat, reg.lon, projection = "Mercator") {
    ind <- c(1:length(reg.lat))
    nholes <- length(reg.lat[is.na(reg.lat)])
    lxv <- c(0:(nholes + 1))
    if (nholes != 0) {
      #               remove NA,s and points given twice
      ind1 <- ind[is.na(reg.lat)]
      ind2 <- c(ind1 - 1, ind1, length(reg.lat))
      lon <- reg.lon[-ind2]
      lat <- reg.lat[-ind2]
      for (i in 2:(nholes + 1)) {
        lxv[i] <- ind1[i - 1] - 2 * (i - 1)
      }
    } else {
      ind <- (1:length(reg.lon) - 1)
      lon <- reg.lon[ind]
      lat <- reg.lat[ind]
    }
    lxv[nholes + 2] <- length(lon)
    #x,y coordinates.
    if (projection == "none") {
      return(list(x = lon, y = lat, lxv = lxv))
    } else {
      return(list(lat = lat, lon = lon, lxv = lxv))
    }
  }

# ---- extract.R ----
#' Extract a grid (?)
#'
#' Extract a grid (?).
#'
#'
#' @param grd Grid
#' @param z Value
#' @param maxn Max number
#' @param limits Limits
#' @param col.names Defaults to \code{lat, lon}
#' @return Returns a list with components: \item{grd1}{A grid} \item{z}{Values
#' over the grid}
#' @note Internal to the geo-contour-functions, needs elaboration.
#' @seealso Called by \code{\link{geocontour}} and
#' \code{\link{geocontour.fill}}.
#' @export extract
extract <-
  function(grd, z, maxn = 10000, limits = NULL, col.names = c("lon", "lat")) {
    geopar <- getOption("geopar")
    if (is.null(limits)) {
      if (col.names[1] == "lon" && col.names[2] == "lat") {
        if (geopar$projection == "Lambert") {
          # complicated borders in lat,lon
          p1 <- list(
            x = c(
              geopar$limx[1],
              mean(geopar$limx),
              geopar$limx[1],
              geopar$limx[
                2
              ]
            ),
            y = c(
              geopar$limy[1],
              geopar$limy[2],
              geopar$limy[2],
              geopar$limy[
                2
              ]
            )
          )
          limits <- invProj(
            p1$x,
            p1$y,
            geopar$scale,
            geopar$b0,
            geopar$b1,
            geopar$l1,
            geopar$projection
          )
          xlim <- c(limits$lon[3], limits$lon[4])
          ylim <- c(limits$lat[1], limits$lat[2])
          limits <- list(lon = xlim, lat = ylim)
        } else {
          limits <- invProj(
            geopar$limx,
            geopar$limy,
            geopar$scale,
            geopar$b0,
            geopar$b1,
            geopar$l1,
            geopar$projection
          )
          xlim <- c(limits$lon[1], limits$lon[2])
          ylim <- c(limits$lat[1], limits$lat[2])
          limits <- list(lon = xlim, lat = ylim)
        }
      } else {
        limits <- list(x = par()$usr[1:2], y = par()$usr[3:4])
        names(limits) <- col.names
      }
    }
    ind10 <- c(1:length(grd[[col.names[1]]]))
    ind1 <- ind10[
      grd[[col.names[1]]] >= limits[[col.names[1]]][1] &
        grd[[
          col.names[1]
        ]] <=
          limits[[col.names[1]]][2]
    ]
    ind20 <- c(1:length(grd[[col.names[2]]]))
    ind2 <- ind20[
      grd[[col.names[2]]] >= limits[[col.names[2]]][1] &
        grd[[
          col.names[2]
        ]] <=
          limits[[col.names[2]]][2]
    ]
    ind10 <- matrix(ind10, length(ind10), length(ind20))
    ind20 <- t(matrix(ind20, length(ind20), nrow(ind10)))
    ind <- c(1:length(ind10))
    if (length(ind1) * length(ind2) > maxn) {
      if (col.names[1] == "lon" && col.names[2] == "lat") {
        rat <- cos((mean(limits[[col.names[2]]]) * pi) / 180)
        nlat <- (limits[[col.names[2]]][2] -
          limits[[col.names[
            2
          ]]][1])
        nlon <- (limits[[col.names[1]]][2] -
          limits[[col.names[
            1
          ]]][1]) *
          rat
        rat <- nlat / nlon
        nlat <- sqrt(maxn * rat)
        nlon <- sqrt(maxn / rat)
        ind1 <- seq(
          min(ind1),
          max(ind1),
          by = round(
            length(
              ind1
            ) /
              nlon
          )
        )
        ind2 <- seq(
          min(ind2),
          max(ind2),
          by = round(
            length(
              ind2
            ) /
              nlat
          )
        )
      } else {
        rat <- maxn / (length(ind1) * length(ind2))
        nlat <- length(ind2) * sqrt(rat)
        nlon <- length(ind1) * sqrt(rat)
        ind1 <- seq(
          min(ind1),
          max(ind1),
          by = round(
            length(
              ind1
            ) /
              nlon
          )
        )
        ind2 <- seq(
          min(ind2),
          max(ind2),
          by = round(
            length(
              ind2
            ) /
              nlat
          )
        )
      }
    }
    grd1 <- list(grd[[col.names[1]]][ind1], grd[[col.names[2]]][ind2])
    names(grd1) <- col.names
    ind <- ind[!is.na(match(ind10, ind1)) & !is.na(match(ind20, ind2))]
    z <- z[ind]
    return(list(grd1 = grd1, z = z))
  }

# ---- findline.R ----
#' Finds a line (?)
#'
#' Finds a line (?).
#'
#'
#' @param x Coordinates 1 (?)
#' @param xb Coordinates 2 (?)
#' @param plot Plot or not, default TRUE
#' @return If plot is TRUE, returns coordinates for plotting, if FALSE returns
#' data.frame of with latitude and longitude.
#' @note Needs further elaboration.
#' @seealso Called by \code{\link{adjust.grd}}, \code{\link{geolines}},
#' \code{\link{geolines.with.arrows}}, \code{\link{init}} and
#' \code{link{reitaplott}}, calls \code{\link{invProj}},
#' \code{\link{prepare.line}} and \code{\link{Proj}}.
#' @keywords manip
#' @export findline
findline <-
  function(x, xb, plot = T) {
    if (!plot) {
      x <- Proj(x)
      xb <- Proj(xb)
    }
    if (geo_is_axis_aligned_rect(xb$x, xb$y)) {
      xmin <- min(xb$x)
      xmax <- max(xb$x)
      ymin <- min(xb$y)
      ymax <- max(xb$y)
      clipped <- geo_clip_polyline_to_rect(x$x, x$y, xmin, xmax, ymin, ymax)
    } else {
      clipped <- geo_clip_polyline_to_polygon(x$x, x$y, xb$x, xb$y)
    }
    xr <- clipped$x
    yr <- clipped$y
    nxr <- length(xr)
    if (!plot) {
      if (nxr == 0) {
        return(invisible(data.frame(lat = numeric(0), lon = numeric(0))))
      }
      xr1 <- invProj(xr, yr)
      xr1 <- data.frame(list(lat = xr1$lat, lon = xr1$lon))
      return(invisible(xr1))
    } else {
      return(list(y = yr, x = xr, nxr = nxr))
    }
  }

# ---- findcut.R ----
#' Find intersection or complement
#'
#' Find intersection or compliment of two polygons.
#'
#'
#' @param x Polygon
#' @param xb Polygon to intersect with/complement from
#' @param in.or.out Whether to take intersect of \code{x} and \code{xb} (0) or
#' complement of \code{x} in \code{xb} (1). Default 0.
#' @return Returns a list of \item{x, y}{Coordinate of intersect or compliment}
#' \item{nxr}{Number/index of returned coordinates in \code{xb} (?)}
#' @note Needs elaboration.
#' @seealso Called by \code{\link{cut_multipoly}}, \code{\link{geointersect}}
#' and \code{\link{reitaplott}}; calls \code{\link{find.hnit}} and
#' \code{\link{geoinside}}.
#' @keywords manip logic
#' @export findcut
findcut <-
  function(x, xb, in.or.out) {
    if (!is.data.frame(x)) {
      x <- data.frame(x = x$x, y = x$y)
    }
    res <- geo_findcut_polyclip(x, xb, in.or.out)
    if (is.null(res)) {
      return(invisible())
    }
    return(list(x = res$x, y = res$y, nxr = length(res$x)))
  }

# ---- find.hnit.R ----
#' Find coordinate(s) ??
#'
#' Find coordinates with some sort of interpolation (??).
#'
#'
#' @param pt Point(s) ??
#' @param poly Polygon (??)
#' @return Returns list with components: \item{x, y }{of coordinates}
#' @note ~~further notes~~ Needs elaboration.
#' @seealso Called by \code{\link{findcut}}
#' @keywords manip
#' @export find.hnit
find.hnit <-
  function(pt, poly) {
    pt1 <- floor(pt)
    pt2 <- pt - pt1
    y <- poly$y[pt1] + pt2 * (poly$y[pt1 + 1] - poly$y[pt1])
    x <- poly$x[pt1] + pt2 * (poly$x[pt1 + 1] - poly$x[pt1])
    return(data.frame(x = x, y = y))
  }

# ---- frame2gpx.R ----
#' Convert latlon data frame to gpx file.
#'
#' Writes a gpx file of a dataframe with a call to \code{gpsbabel} in the shell
#'
#'
#' @param data Data frame with positions in columns \code{lat} and \code{lon}.
#' @param filename Name of gpx-file, defaults to 'tmp.gpx'.
#' @param type Type of gpx-file, one of \code{wpt} for waypoints, \code{rte}'
#' for route or \code{trk} for track.
#' @note Requires \code{gpsbabel} installation working from the command line.
#' @seealso \url{gpsbabel.org}
#' @keywords manip
#' @examples
#'
#' \dontrun{
#' # some positions
#' pos <- rPeri(323)
#' frame2gpx(pos)
#' system("more tmp.gpx")
#' system("rm tmp.gpx")
#' }
#'
#' @export frame2gpx
frame2gpx <-
  function(data, filename = "tmp.gpx", type = "rte") {
    if (!is.data.frame(data)) {
      stop("'data' not a dataframe")
    }
    container <- tempfile("gpx")
    on.exit(unlink(container))
    colid <- match(c("lat", "lon"), names(data))
    data <- data[, colid]
    data <- data.frame(data, 0:(nrow(data) - 1))
    write.table(
      data,
      file = container,
      row.names = FALSE,
      col.names = FALSE,
      sep = ","
    )
    switch(
      type,
      wpt = system(paste(
        "gpsbabel -i csv -f",
        container,
        "-x transform -o gpx -F",
        filename
      )),
      rte = system(paste(
        "gpsbabel -i csv -f",
        container,
        "-x transform,rte=wpt,del -o gpx -F",
        filename
      )),
      trk = system(paste(
        "gpsbabel -i csv -f",
        container,
        "-x transform,trk=wpt,del -o gpx -F",
        filename
      ))
    )
  }

# ---- bua.R ----
#' Makes a list used in \code{pointkriging}
#'
#' Makes a list of four components sequences based on input number for use in
#' \code{pointkriging}.
#'
#'
#' @param nm A number
#' @return Returns a list with components: \item{rrt}{sequence 1 of length
#' \code{4*nm^2}} \item{crt}{sequence 2, same length as \code{rrt}}
#' \item{rrt}{sequence 3, same length as \code{rrt}} \item{crt}{sequence 4 of
#' length \code{nm + 1}} for use in \code{pointkriging}.
#' @note Needs further elaboration.
#' @seealso \code{\link{pointkriging}}
#' @keywords manip
#' @export bua
bua <-
  function(nm = 10) {
    rrt <- c(0, 0, 1, 1)
    crt <- c(0, 1, 1, 0)
    for (i in 2:nm) {
      stdrrt <- c(matrix(0, 8 * i - 4, 1))
      stdcrt <- stdrrt
      n <- i * 8 - 4
      stdrrt[1:(2 * i)] <- 1 - i
      stdrrt[(2 * i + 1):(4 * i - 1)] <- c((2 - i):i)
      stdrrt[(4 * i - 1):(6 * i - 2)] <- i
      stdrrt[(6 * i - 2):(8 * i - 4)] <- c(i:(2 - i))
      stdcrt[1:(2 * i)] <- (c(1 - i):i)
      stdcrt[(2 * i + 1):(4 * i - 1)] <- i
      stdcrt[(4 * i - 1):(6 * i - 2)] <- c(i:(1 - i))
      stdcrt[(6 * i - 2):(8 * i - 4)] <- 1 - i
      crt <- c(crt, stdcrt)
      rrt <- c(rrt, stdrrt)
    }
    i1 <- 4
    for (i in 2:nm) {
      i1[i] <- i1[i - 1] + 8 * i - 4
    }
    i1 <- c(0, i1)
    # 	Part that comes instead of the loop that
    #	is too slow.
    ind <- c(3, 0, 2, 0, 4, 0, 1)
    r1 <- rrt - 0.1
    c1 <- crt - 0.1
    rr <- sign(r1) + sign(c1) * 2 + 4
    dir <- ind[rr]
    #	dir<- c(1:length(rrt))
    #	for(i in 1:length(rrt)){
    #		if(rrt[i]>0 && crt[i]>0)dir[i]<-1
    #		if(rrt[i]<= 0 && crt[i]>0)dir[i]<-4
    #		if(rrt[i]<= 0 && crt[i]<=0 )dir[i]<-3
    #		if(rrt[i]>0 && crt[i]<=0)dir[i]<-2
    #	}
    return(list(rrt = rrt, crt = crt, dir = dir, i1 = i1))
  }

# ---- ices.R ----
#' ICES Areas
#'
#' Draw a map showing ICES areas 1--14.
#'
#'
#' @param labels is how to annotate areas: \code{"roman"} (I--XIV),
#' \code{FALSE} (no labels), vector (custom), otherwise 1--14.
#' @param diagrams is whether to show diagrams on console.
#' @param col is passed to \code{map}.
#' @param lwd is passed to \code{lines}.
#' @param col.lines is passed to \code{lines}.
#' @param font is passed to \code{text}.
#' @param col.text is passed to \code{text}.
#' @param cex is passed to \code{text}.
#' @return Invisible data frame with coordinates.
#' @note The coordinates were inferred from official ICES maps.
#' @author Arni Magnusson.
#' @keywords hplot spatial utilities
#' @examples
#'
#' ices()
#'
#' @export ices
ices <-
  function(
    labels = "roman",
    diagrams = FALSE,
    col = "black",
    lwd = 3,
    col.lines = "grey80",
    font = 2,
    col.text = "orangered",
    cex = 1
  ) {
    areaLines <- function(area, ...) {
      Lines <- function(x) lines(x$East, x$North, ...)
      lapply(area, Lines)
      invisible(NULL)
    }

    coords <- data.frame(
      Area = as.integer(rep.int(
        c(1:10, 12, 14),
        c(6, 9, 5, 10, 11, 9, 8, 4, 4, 5, 9, 8)
      )),
      Line = rep.int(
        c(
          "0",
          "2",
          "1",
          "4-5-14",
          "4",
          "2-5-6",
          "3",
          "7",
          "all",
          "5-7-12",
          "7",
          "4",
          "6",
          "6-8-12",
          "all",
          "0",
          "2-5-12"
        ),
        c(2, 4, 4, 5, 5, 3, 5, 2, 11, 7, 2, 2, 2, 4, 22, 2, 6)
      ),
      North = c(
        90,
        68.5,
        90,
        72,
        72,
        71.2,
        90,
        72,
        72,
        71.2,
        90,
        63,
        63,
        62,
        62,
        58,
        57.5,
        57.5,
        57,
        57,
        58.6,
        62,
        62,
        58,
        57.5,
        57.5,
        57,
        57,
        51,
        51,
        68,
        68,
        63,
        63,
        60.5,
        60.5,
        60,
        60,
        62,
        62,
        68,
        54.5,
        54.5,
        60,
        60,
        60.5,
        60.5,
        58.6,
        55,
        55,
        51,
        51,
        55,
        55,
        54.5,
        54.5,
        48,
        48,
        48,
        48,
        43,
        43,
        43,
        43,
        36,
        36,
        48,
        48,
        36,
        36,
        48,
        62,
        62,
        60,
        60,
        48,
        48,
        59,
        59,
        62,
        90,
        83.4,
        90,
        68,
        68,
        59,
        59,
        59.8
      ),
      East = c(
        51,
        51,
        30,
        30,
        26,
        26,
        30,
        30,
        26,
        26,
        -11,
        -11,
        -4,
        -4,
        5,
        7,
        7,
        8,
        8,
        8.4,
        -4,
        -4,
        5,
        7,
        7,
        8,
        8,
        8.4,
        1,
        2,
        -27,
        -11,
        -11,
        -4,
        -4,
        -5,
        -5,
        -15,
        -15,
        -27,
        -27,
        -8.3,
        -18,
        -18,
        -5,
        -5,
        -4,
        -4,
        -5.9,
        -5.2,
        1,
        2,
        -5.9,
        -5.2,
        -8.3,
        -18,
        -18,
        -4.6,
        -4.6,
        -18,
        -18,
        -9.3,
        -9.3,
        -18,
        -18,
        -5.6,
        -42,
        -18,
        -18,
        -42,
        -42,
        -27,
        -15,
        -15,
        -18,
        -18,
        -42,
        -42,
        -27,
        -27,
        -40,
        -40,
        -11,
        -11,
        -27,
        -27,
        -44,
        -44
      )
    )
    chunks <- lapply(split(coords, coords$Area), function(x) split(x, x$Line))
    map(xlim = c(-55, 55), ylim = c(30, 90), fill = TRUE, col = col)
    sapply(1:12, function(i) areaLines(chunks[[i]], lwd = lwd, col = col.lines))
    if (!identical(labels, FALSE)) {
      #             I    II   III    IV      V     VI    VII   VIII     IX    X  XII   XIV
      textN <- c(
        72.4,
        72.4,
        56.4,
        56.4,
        63.2,
        57.3,
        51.3,
        45.5,
        39.7,
        43,
        54,
        72.4
      )
      textE <- c(40, 5, 19, 3, -13.6, -13.6, -13.6, -13.6, -13.6, -32, -32, -32)
      strings <-
        if (identical(labels, "roman")) {
          as.roman(c(1:10, 12, 14))
        } else if (length(labels) > 1) {
          labels
        } else {
          c(1:10, 12, 14)
        }
      text(textE, textN, strings, font = font, col = col.text, cex = cex)
    }
    if (diagrams) {
      cat(
        "",
        "Area I: Barents Sea",
        "",
        "             + 90N,30E   + 90N,51E",
        "             |           |",
        "             |           |",
        "  72N,26E +--+ 72N,30E   |",
        "          |              |",
        "          |              |",
        "71.2N,26E +              |",
        "                         |",
        "                         |",
        "                         + 68.5N,51E",
        "",
        "",
        "",
        "Area II: Norwegian Sea",
        "",
        "90N,11W +                                         + 90N,30E",
        "        |                                         |",
        "        |                                         |",
        "        |                              72N,26E +--+ 72N,30E",
        "        |                                      |",
        "        |                                      |",
        "        |                            71.2N,26E +",
        "        |",
        "        |",
        "63N,11W +--------+ 63N,4W",
        "                 |",
        "                 |",
        "          62N,4W +--------+ 62N,5E",
        "",
        "",
        "",
        "Area III: Baltic",
        "",
        "  58N,7E +",
        "         |",
        "         |",
        "57.5N,7E +-----------+ 57.5N,8E",
        "                     |",
        "                     |",
        "              57N,8E +----------+ 57N,8.4E",
        "",
        "",
        "",
        "Area IV: North Sea",
        "",
        "  62N,4W +--------------------+ 62N,5E",
        "         |",
        "         |",
        "58.6N,4W +",
        "                                           58N,7E +",
        "                                                  |",
        "                                                  |",
        "                                         57.5N,7E +--------+ 57.5N,8E",
        "                                                           |",
        "                                                           |",
        "                                                    57N,8E +----------+ 57N,8.4E",
        "           51N,1E +--+ 51N,2E",
        "",
        "",
        "",
        "Area V: Iceland and Faroes",
        "",
        "68N,27W +-----------------------------+ 68N,11W",
        "        |                             |",
        "        |                             |",
        "        |         .    .    . 63N,11W +-----------------------------+ 63N,4W",
        "        |                                                           |",
        "        |         .                                                 |",
        "62N,27W +---------+ 62N,15W                                         |",
        "                  |                                                 |",
        "                  |                                                 |",
        "                  |                               60.5N,5W +--------+ 60.5N,4W",
        "                  |                                        |",
        "                  |                                        |",
        "          60N,15W +----------------------------------------+ 60N,5W",
        "",
        "",
        "",
        "Area VI: Scotland",
        "",
        "                                                     60.5N,5W +----------+ 60.5N,4W",
        "                                                              |          |",
        "                                                              |          |",
        "  60N,18W +---------------------------------------------------+ 60N,5W   |",
        "          |                                                              |",
        "          |                                                              |",
        "          |                                                              + 58.6N,4W",
        "          |",
        "          |",
        "          |                 55N,5.9W ---- 55N,5.2W",
        "          |",
        "          |",
        "54.5N,18W +--+ 54.5N,8.3W",
        "",
        "",
        "",
        "Area VII: Sole",
        "",
        "                            55N,5.9W +--+ 55N,5.2W",
        "",
        "54.5N,18W +--+ 54.5N,8.3W",
        "          |",
        "          |",
        "          |",
        "          |",
        "          |                                                     51N,1E +--+ 51N,2E",
        "          |",
        "          |",
        "          |",
        "  48N,18W +----------------------------------------+ 48N,4.6W",
        "",
        "",
        "",
        "Area VIII: Biscay",
        "",
        "48N,18W +-------------+ 48N,4.6W",
        "        |",
        "        |",
        "43N,18W +--+ 43N,9.3W",
        "",
        "",
        "",
        "Area IX: Portugal",
        "",
        "43N,18W +--+ 43N,9.3W",
        "        |",
        "        |",
        "36N,18W +-------------+ 36N,5.6W",
        "",
        "",
        "",
        "Area X: Azores",
        "",
        "48N,42W +--+  48N,18W",
        "        |  |",
        "        |  |",
        "36N,42W +--+  36N,18W",
        "",
        "",
        "",
        "Area XII: North Azores",
        "",
        "          62N,27W +-----------------------------+ 62N,15W",
        "                  |                             |",
        "                  |                             |",
        "                  |           60N,18W +---------+ 60N,15W",
        "                  |                   |",
        "                  |                   |",
        "59N,42W +---------+ 59N,27W           |",
        "        |                             |",
        "        |                             |",
        "48N,42W +-----------------------------+ 48N,18W",
        "",
        "",
        "",
        "Area XIV: Greenland",
        "",
        "              90N,40W +                   + 90N,11W",
        "                      |                   |",
        "                      |                   |",
        "            83.4N,40W +                   |",
        "                                          |",
        "                                          |",
        "                        68N,27W +---------+ 68N,11W",
        "                                |",
        "                                |",
        "59.8N,44W +                     |",
        "          |                     |",
        "          |                     |",
        "  59N,44W +---------------------+ 59N,27W",
        "",
        "",
        "",
        " 1 Barents Sea",
        " 2 Norwegian Sea",
        " 3 Baltic",
        " 4 North Sea",
        " 5 Iceland and Faroes",
        " 6 Scotland",
        " 7 Sole",
        " 8 Biscay",
        " 9 Portugal",
        "10 Azores",
        "12 North Azores",
        "14 Greenland",
        sep = "\n"
      )
    }
    invisible(coords)
  }

# ---- selectedpar.R ----
#' Parameters manipulation ?
#'
#' Parameters manipulation ?
#'
#'
#' @return Returns the names of some selected parameters.
#' @note Needs elaboration,
#' @seealso Called by the majority of the graphical functions in geo, calls
#' \code{\link{Elimcomp}}.
#' @keywords device
#' @export selectedpar
selectedpar <-
  function() {
    return(Elimcomp(par(no.readonly = T)))
  }

# ---- selpos.R ----
#' Geographical point selection.
#'
#' Select geographical data points by arbitrary criterion.
#'
#' The normal way of working with geographical data is to store positions as a
#' list with names lat and lon. This is easier for most applications, except
#' selection of subsets, where it is essential to access individual elements.
#' The purpose of this routine is merely to ease the selection process.
#'
#' @param lat Latitude of points or list containing lat,lon.
#' @param ind Selection criterion.
#' @param lon Longitude of data points. If missing, this must be part of the
#' lat argument.
#' @return Returns list with elements lat,lon which satisfy the criterion.
#' @seealso \code{\link{geoplot}},
#' @examples
#'
#' \dontrun{
#'              subs<-selpos(pos,,z>6)# Select positions where z>6
#'
#'        The Function is trivially defined as
#'        function(lat, lon = NULL, ind)
#'        {
#'                       if(is.null(lon)) {
#'                            lon <- lat$lon
#'                            lat <- lat$lat
#'                       }
#'                       lat <- lat[ind]
#'                       lon <- lon[ind]
#'                       return(lat, lon)
#'        }
#' }
#' @export selpos
selpos <-
  function(lat, lon = NULL, ind) {
    if (is.null(lon)) {
      lon <- lat$lon
      lat <- lat$lat
    }
    lat <- lat[ind]
    lon <- lon[ind]
    return(lat, lon)
  }

# ---- Reitur2Svaedi1to10.R ----
#' Allocate statistical rectangles and subrectangles to Bormicon-areas 1--10.
#'
#' Routine for allocating rectangles to areas with some in-built decisions for
#' rectangles on the borders of areas.
#'
#'
#' @param reitur Rectangle in the Icelandic statistical rectangle system.
#' @param smareitur Sub-rectangle in the Icelandic statistical rectangle
#' system.
#' @param Totalreitir Projection between a list of all Icelandic rectangles to
#' a list of Bormicon areas.
#' @param Dypisreitir Not documented.
#' @return Returns vector of bormicon areas of the rectangles.
#' @note Objects \code{Totalreitir} containing a list of all rectangles
#' competely contained in bc-areas and \code{Dypisreitir} with something are
#' necessary for the function to work.
#' @seealso Bormicon-area allocation functions \code{\link{inside.reg.bc}} and
#' \code{\link{inside.reg.bc1}}, \code{\link{r2d}}
#' @keywords manip
#' @export Reitur2Svaedi1to10
"Reitur2Svaedi1to10" <-
  function(reitur, smareitur, Totalreitir, Dypisreitir) {
    if (missing(smareitur)) {
      smareitur <- rep(0, length(reitur))
    }
    a <- rep(0, length(reitur))
    i <- match(reitur, Totalreitir$reitur) # all rectangles within same Bormicon area
    i1 <- c(1:length(i))
    i1 <- i1[!is.na(i)]
    i <- i[!is.na(i)]
    a[i1] <- Totalreitir$area[i]
    i <- match(reitur, Dypisreitir$reitur) # rectangles outside and inside 500 m
    i1 <- c(1:length(i))
    i1 <- i1[!is.na(i)]
    i <- i[!is.na(i)]
    if (length(i1) > 0) {
      a[i1] <- Dypisreitir[i, "<500"]
    }
    i <- match(reitur, c(373, 324))
    i1 <- c(1:length(i))
    i1 <- i1[!is.na(i)]
    if (length(i1) > 0) {
      a[i1] <- 1
    }
    i <- match(reitur, c(373, 324)) # rectangles in areas 1 and 10
    i1 <- c(1:length(i))
    i1 <- i1[!is.na(i)]
    if (length(i1) > 0) {
      a[i1] <- 1
    } # mainly in area 1
    i <- match(reitur, c(721, 722, 723)) # rectangles straddling areas 2 and 3
    i1 <- c(1:length(i))
    i1 <- i1[!is.na(i)]
    if (length(i1) > 0) {
      a[i1] <- 2
    }
    i <- match(
      reitur,
      c(Dypisreitir$reitur, Totalreitir$reitur, 323, 324, 721, 722, 723)
    )
    i1 <- c(1:length(i))
    i1 <- i1[is.na(i)]
    if (length(i1) > 0) {
      tmp <- inside.reg.bc1(r2d(reitur[i1] * 100 + smareitur[i1]))
    }
    a[i1] <- tmp$area
    return(a)
  }

# ---- Elimcomp.R ----
#' Parameters manipulation ?
#'
#' Parameters manipulation?
#'
#'
#' @param parlist List of parameters ?
#' @return Manipulated (shortened ?) parameterlist
#' @note Needs elaboration, \code{selectedpar} warps around this function,
#' where parameter names in \code{nonsetpar} come from is a mystery.
#' @seealso Called by \code{\link{geoplot}}, \code{\link{init}} and
#' \code{\link{selectedpar}}.
#' @keywords device
#' @export Elimcomp
Elimcomp <-
  function(parlist) {
    txt <- names(parlist)
    txt <- txt[is.na(match(txt, geo::nonsetpar))]
    res <- list()
    for (i in txt) {
      res[[as.character(i)]] <- parlist[[as.character(i)]]
    }
    return(res)
  }

# ---- geoarea.R ----
#' Calculates the area of a given region.
#'
#' Calculates the area of a given region to a given precision.
#'
#'
#' @param data The region, should contain lat and lon.
#' @param ngrdpts The precision of the calculation.
#' @param Projection Which projection is beeing used.
#' @param old.method If true an older version of this program is used. Default
#' is False.
#' @param robust If true a more robust method is used, default is True.
#' @return The area of the region given.
#' @section Side Effects: None
#' @seealso \code{\link{geodefine}}, \code{\link{geolocator}},
#' \code{\link{geoinside}}.
#' @examples
#'
#'          geoarea(island)         # Calculates the area of Iceland up to
#'                                  # an with default precision.
#'
#'          geoarea(island,10000)   # Calculates the area of Iceland up to
#'                                  # an adiquite precision.
#'
#' #         geoarea(geodefine(),10) # Calculates the area of a region specified
#'                                  # by the user.
#'
#' @export geoarea
geoarea <-
  function(
    data,
    Projection = "Lambert",
    old.method = F,
    ngrdpts = 2000,
    robust = T
  ) {
    area <- 0
    data <- geo.Split.poly(data)
    if (old.method) {
      for (i in 1:length(data)) {
        area <- area + geoarea.old(data[[i]], ngrdpts, robust)
      }
    } else {
      area <- 0
      for (i in 1:length(data)) {
        if (Projection == "Lambert") {
          data[[i]] <- lambert(
            data[[i]]$lat,
            data[[i]]$lon,
            mean(data[[i]]$lat),
            mean(
              data[[
                i
              ]]$lon
            ),
            mean(data[[i]]$lat)
          )
        } else {
          data[[i]] <- mercator(
            data[[i]]$lat,
            data[[i]]$lon,
            b0 = mean(data[[i]]$lat)
          )
        }
        data[[i]] <- data.frame(
          x = data[[i]]$x,
          y = data[[
            i
          ]]$y
        )
        n <- nrow(data[[i]])
        area <- area +
          abs(
            sum(
              data[[i]]$x[1:(n - 1)] *
                data[[
                  i
                ]]$y[2:n] -
                data[[i]]$x[2:n] * data[[i]]$y[1:(n - 1)],
              na.rm = T
            ) /
              2
          )
      }
    }
    return(area)
  }

# ---- geoarea.old.R ----
#' Old method for calculating geographical area
#'
#' Calculates the area inside a geographical region by splitting it into a
#' grid, determining which gridpoints are inside the region and then finds the
#' area.
#'
#'
#' @param reg Region of interest, list with components \code{lat} and
#' \code{lon}.
#' @param n Numeber of gridpoints to use for calculating the area.
#' @param robust Robust or not, defaults to \code{TRUE}.
#' @return Geographical area in square nautical miles.
#' @note Difference between old and new \code{geoarea}-method might be
#' explained better, if indeed it is necessary to keep the old method.
#' @seealso \code{\link{geoarea}.}
#' @keywords arith
#' @export geoarea.old
"geoarea.old" <-
  function(reg, n, robust = T) {
    reg$lat <- (reg$lat * pi) / 180
    reg$lon <- (reg$lon * pi) / 180
    rlat <- range(reg$lat[!is.na(reg$lat)])
    dlat <- (rlat[2] - rlat[1])
    rlon <- range(reg$lon[!is.na(reg$lon)])
    dlon <- (rlon[2] - rlon[1]) * cos((rlat[2] + rlat[1]) / 2)
    ratio <- (dlat / dlon)
    nlat <- floor(sqrt(n) * sqrt(ratio))
    nlon <- round(sqrt(n) / sqrt(ratio))
    dlon <- dlon / cos((rlat[2] + rlat[1]) / 2)
    lat <- rlat[1] + (c(0:(nlat - 1)) * dlat) / nlat + dlat / (2 * nlat)
    lon <- rlon[1] + (c(0:(nlon - 1)) * dlon) / nlon + dlon / (2 * nlon)
    darea <- (lon[2] - lon[1]) * (lat[2] - lat[1]) * 40528473
    latgr <- c(matrix(lat, nlat, nlon))
    longr <- c(t(matrix(lon, nlon, nlat)))
    area <- dlon * dlat * 40528473 * cos((rlat[2] + rlat[1]) / 2)
    border <- adapt(reg$lat, reg$lon)
    inside <- as.integer(geo_point_in_multipolygon(longr, latgr, border))
    ind <- c(1:length(inside))
    ind <- ind[inside != 0]
    mlat <- mean(latgr[ind])
    mlon <- mean(longr[ind])
    cmlat <- mean(cos(latgr[ind]))
    cl <- mean(cos(latgr))
    rat <- length(ind) / length(inside) # fraction outside
    inside.area <- (rat * area * cmlat) / cl
    return(inside.area)
  }

# ---- geodefine.R ----
#' Defines regions.
#'
#' locates points pointed out by users and defines regions.
#'
#' Draws the regions on the plot.
#'
#' @param nholes The number of holes in data, number of regions - 1.
#' @return A list of the points pointed out by the user with NA's between
#' regions.
#' @section Side Effects: Draws the regions on the plot.
#' @seealso \code{\link{geolocator}}.
#' @examples
#'
#'  ##   Push left mouse button to mark point, push middle button to
#'  ##   mark the end of a region.
#'
#' @export geodefine
geodefine <-
  function(nholes = 0) {
    geopar <- getOption("geopar")
    oldpar <- selectedpar()
    par(geopar$gpar)
    on.exit(par(oldpar))
    border <- giveborder(nholes = nholes)
    reg <- border$reg
    par(oldpar)
    if (geopar$projection == "none") {
      reg <- list(x = reg$x, y = reg$y)
    } else {
      reg <- list(lat = reg$lat, lon = reg$lon)
    }
    reg <- data.frame(reg)
    return(reg)
  }

# ---- init.R ----
#' Initiate a geoplot (??)
#'
#' Initiate a geoplot (??).
#'
#'
#' @param lat,lon Latitude and longitude
#' @param type Plot method
#' @param pch Plot character
#' @param xlim,ylim Plot limits
#' @param b0 Base latitude
#' @param r Plot ratio, multiplier on \code{diff(x_or_ylim)}
#' @param xlab,ylab Labels for x- and y-axes, default \code{"Longitude",
#' "Latitude"}
#' @param option Method of determining plot extent, default \code{"cut"}
#' @param grid Should a grid be drawn, default \code{TRUE}
#' @param new Plot control, default \code{FALSE} adds plot to current plot
#' @param cont For use with contours: should space be reserved for contour
#' labels? Default \code{FALSE}
#' @param cex Character size expansion
#' @param col Color, default 1, usually black
#' @param lcont Contour lable space allocation, default c(0.13, 0.21)
#' @param plotit If FALSE plot is only initialized but not plotted. If used
#' other programs are used to fill the plot (geolines, geocontour, geopolygon
#' etc). Most often used in multiple plots.
#' @param reitur Should the grid be that of statistical rectangles?
#' @param smareitur Should the grid be that of statistical sub--rectangles?
#' @param reittext Should the rectangles be labelled?
#' @param axratio Parameter usually not changed by the user.
#' @param lwd Line width
#' @param axlabels If FALSE no numbers are plotted on the axes. Default value
#' is TRUE.
#' @param oldpar The old par--list, from the parent geoplot--call
#' @param projection Projection, default \code{Mercator}
#' @param b1 Second latitude for Lambert projection
#' @param dlat,dlon Defines the grid, to make a grid on the axes, 1 is a number
#' on axis and a line at every deg. Not usualy set by user.
#' @param command The parent \code{geoplot} command is included, although for
#' what purpose isn't quite clear??
#' @param jitter Random jitter to accentuate repeated values. Default no jitter
#' (\code{jitter = 0})
#' @param xaxdist,yaxdist Distance from plot to the labels on axes (dist or r
#' argument to geoaxis).  Default values \code{0.2, 0.3} but higher values mean
#' that axlabels are further away from the plot.  Further flexibility with axes
#' can be reached by calling geoplot with axlabels = FALSE and geoaxis
#' aferwards.
#' @return No value, side effect plotted.
#' @note Needs further elaboration, alternatively hide the function.
#' @seealso Called by \code{\link{geoplot}} calls \code{\link{Elimcomp}},
#' \code{\link{findline}}, \code{\link{geoaxis}}, \code{\link{gridaxes}},
#' \code{\link{gridaxes.Lambert}}, \code{\link{invProj}}, \code{\link{Proj}}.
#' @keywords hplot
#' @export init
init <-
  function(
    lat,
    lon = 0,
    type = "p",
    pch = "*",
    xlim = c(0, 0),
    ylim = c(0, 0),
    b0 = 65,
    r = 1.05,
    xlab = "Longitude",
    ylab = "Latitude",
    option = "cut",
    grid = T,
    new = F,
    cont = F,
    cex = 0.7,
    col = 1,
    lcont = c(0.13, 0.21),
    plotit = T,
    reitur = F,
    smareitur = F,
    reittext = F,
    axratio = 1,
    lwd = 0,
    axlabels = T,
    oldpar,
    projection = "Mercator",
    b1 = 65,
    dlat = 0,
    dlon = 0,
    command = 0,
    jitter = 0,
    xaxdist,
    yaxdist
  ) {
    if (projection == "none") {
      if (length(lon) == 1) {
        lon <- lat$y
        lat <- lat$x
      }
    } else {
      if (length(lon) == 1) {
        lon <- lat$lon
        lat <- lat$lat
      }
    }
    nlat <- length(lat)
    lat <- lat + (runif(nlat) - 0.5) * jitter
    lon <- lon + (runif(nlat) - 0.5) * jitter
    if (xlim[1] == xlim[2]) {
      l1 <- mean(range(lon[!is.na(lon)]))
    } else {
      l1 <- mean(xlim)
    }
    par(xpd = F)
    scale <- "km"
    xgr <- Proj(lat, lon, scale, b0, b1, l1, projection)
    # 	size of text
    par(cex = cex)
    if (lwd != 0) {
      par(lwd = lwd)
    }
    if (!axlabels) {
      xlab <- ""
      ylab <- ""
    }
    # 	contourplot
    if (!cont) {
      lcont[1] <- 0
      lcont[2] <- 0
    }
    if (cont) {
      option <- "nocut"
    }
    plt <- oldpar$plt
    contlab <- plt
    contlines <- plt
    contlines[1] <- plt[1] + lcont[2] * (plt[2] - plt[1])
    contlab[2] <- plt[1] + lcont[1] * (plt[2] - plt[1])
    par(plt = contlines)
    # Find borders, adjust them if given.
    xyratio <- par()$pin[1] / par()$pin[2]
    #*1.04777  ratio of axes.
    if (projection == "none") {
      ind <- c(1:length(xgr$x))
      ind <- ind[!is.na(xgr$x)]
      #No NAs
      if (xlim[1] == xlim[2]) {
        xmin <- min(xgr$x[ind])
        xmax <- max(xgr$x[ind])
      } else {
        xmin <- xlim[1]
        xmax <- xlim[2]
        r <- 1
      }
      if (ylim[1] == ylim[2]) {
        ymin <- min(xgr$y[ind])
        ymax <- max(xgr$y[ind])
      } else {
        ymin <- ylim[1]
        ymax <- ylim[2]
        r <- 1
      }
    } else {
      ind <- c(1:length(xgr$lon))
      ind <- ind[!is.na(xgr$lon)]
      #No NAs
      if (xlim[1] == xlim[2]) {
        xmin <- min(xgr$lon[ind])
        xmax <- max(xgr$lon[ind])
      } else {
        xmin <- xlim[1]
        xmax <- xlim[2]
        r <- 1
      }
      if (ylim[1] == ylim[2]) {
        ymin <- min(xgr$lat[ind])
        ymax <- max(xgr$lat[ind])
      } else {
        ymin <- ylim[1]
        ymax <- ylim[2]
        r <- 1
      }
    }
    if (projection == "Lambert") {
      xt1 <- c(l1, xmin, xmax, xmax)
      xt2 <- c(ymin, ymin, ymin, ymax)
    } else if (projection == "none") {
      xt2 <- c(xmin, xmax)
      xt1 <- c(ymin, ymax)
    } else {
      xt1 <- c(xmin, xmax)
      xt2 <- c(ymin, ymax)
    }
    xl <- Proj(xt2, xt1, scale, b0, b1, l1, projection)
    xmin <- min(xl$x)
    ymin <- min(xl$y)
    xmax <- max(xl$x)
    ymax <- max(xl$y)
    xymax <- max((ymax - ymin), (xmax - xmin) / xyratio)
    meanx <- (xmin + xmax) / 2
    meany <- (ymin + ymax) / 2
    r1 <- r + (r - 1) / 2
    r1 <- r1 - 0.5
    if (option == "cut") {
      # cut figure and graph region
      limx <- c(meanx - r1 * (xmax - xmin), meanx + r1 * (xmax - xmin))
      limy <- c(meany - r1 * (ymax - ymin), meany + r1 * (ymax - ymin))
      xyr <- (ymax - ymin) / ((xmax - xmin) / xyratio)
      pinpar <- c(1:2)
      if (xyr > 1) {
        pinpar[1] <- par()$pin[1] / xyr
        pinpar[2] <- par()$pin[2]
      } else {
        pinpar[1] <- par()$pin[1]
        pinpar[2] <- par()$pin[2] * xyr
      }
      par(pin = pinpar)
    } else {
      limx <- c(meanx - r1 * xymax * xyratio, meanx + r1 * xymax * xyratio)
      limy <- c(meany - r1 * xymax, meany + r1 * xymax)
    }
    if (type == "l") {
      gx <- limx
      gy <- limy
      border <- list(
        x = c(gx[1], gx[2], gx[2], gx[1], gx[1]),
        y = c(
          gy[1],
          gy[1],
          gy[2],
          gy[2],
          gy[1]
        )
      )
      xx <- findline(xgr, border)
    } else {
      ind <- c(1:length(xgr$x))
      ind <- ind[
        (xgr$x > limx[1]) &
          (xgr$x < limx[2]) &
          (xgr$y > limy[1]) &
          (xgr$y < limy[2])
      ]
      xx <- list(x = xgr$x[ind], y = xgr$y[ind])
    }
    if (length(xx$x) == 0) {
      type <- "n"
      xx <- xgr
    }
    # to get rid of errors if no point in plot.
    par(new = new)
    if (plotit) {
      if (projection == "none") {
        plot(
          xx$x,
          xx$y,
          type = type,
          pch = pch,
          xlim = limx,
          ylim = limy,
          xlab = xlab,
          ylab = ylab,
          col = col
        )
      } else {
        plot(
          xx$x,
          xx$y,
          type = type,
          pch = pch,
          xlim = limx,
          ylim = limy,
          axes = FALSE,
          xlab = xlab,
          ylab = ylab,
          col = col
        )
        # plot grid and axes
        if (projection == "Lambert") {
          d <- gridaxes.Lambert(
            limx,
            limy,
            scale,
            b0,
            xyratio,
            grid,
            col,
            reitur,
            smareitur,
            axratio,
            axlabels,
            b1,
            l1,
            projection,
            dlat,
            dlon
          )
        } else {
          d <- gridaxes(
            limx,
            limy,
            scale,
            b0,
            xyratio,
            grid,
            col,
            reitur,
            smareitur,
            axratio,
            axlabels,
            b1,
            l1,
            projection,
            dlat,
            dlon
          )
        }
      }
    } else {
      plot(
        xx$x,
        xx$y,
        type = "n",
        pch = pch,
        xlim = limx,
        ylim = limy,
        axes = F,
        xlab = "",
        ylab = "",
        col = col
      )
    }
    #par(new = T)
    gpar <- par(no.readonly = TRUE)
    # save graphical setup
    o <- invProj(limx, limy, scale, b0, b1, l1, projection)
    gpar <- Elimcomp(gpar)
    geopar <- list(
      gpar = gpar,
      limx = limx,
      limy = limy,
      scale = scale,
      b0 = b0,
      b1 = b1,
      l1 = l1,
      contlab = contlab,
      contlines = contlines,
      cont = cont,
      projection = projection,
      origin = o,
      command = command
    )

    # store geopar list inside options(), where plot functions can access it
    options(geopar = geopar)

    # Extra to get geoaxis instead of normal axis added in R version.

    if (axlabels && projection == "Mercator") {
      if (!reitur && !smareitur) {
        geoaxis(side = 2, dist = yaxdist, dlat = d$dlat, inside = F, cex = cex)
        geoaxis(side = 1, dlon = d$dlon, inside = F, cex = cex, dist = xaxdist)
      } else {
        if (reitur) {
          geoaxis(side = 2, dlat = d$dlat, inside = F, cex = 0.63)
          geoaxis(side = 1, dlon = d$dlon, inside = F, cex = 0.63)
        }
        if (smareitur) {
          geoaxis(side = 2, dlat = d$dlat * 2, inside = F, cex = 0.63)
          geoaxis(side = 1, dlon = d$dlon * 2, inside = F, cex = 0.63)
        }
      }
    }
    return(invisible())
  }
