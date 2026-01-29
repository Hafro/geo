# Auto-generated grouping file: rect-utils.R
# Original function definitions were moved here for maintainability.

# ---- rectGrid.R ----
#' Produce a grid of rectangles on a plot, filled with colors if desired.
#'
#'
#' Functions that plot a line grid or one filled with colors for rectangle
#' codes in systems of various resolutions with call to \code{\link{geolines}}
#' or \code{\link{geopolygon}} and perimeter utility functions (see
#' \code{\link{rectPeri}}).
#'
#' The functions simply outline or fill the rectangles they are given.  whereas
#' \code{\link{reitaplott}} and \code{\link{geoSR}} assume levels and are more
#' hi-level.
#'
#' @name rGrid
#' @aliases rgrid srgrid mrgrid drgrid
#' @param r,sr,dr,mr Codes of rectangle to be outlined or filled. In different
#' resolutions, \code{r, sr} with their own system (see
#' \code{\link{deg2rect}}), \code{mr} dimensions based on minutes, \code{dr} on
#' degrees.
#' @param dlat,dlon Dimensions of latitude and longitude given in minutes and
#' degrees for \code{mrgrid} and \code{drgrid}, respectively
#' @param fill Logical, whether or not to fill the plotted rectangles.
#' @param \dots other arguments to \code{\link{geopolygon}} or
#' \code{\link{geolines}} as appropriate, notably \code{col}.
#' @return No values returned, used for side-effects.
#' @note Functions \code{\link{reitaplott}} and \code{\link{geoSR}} have more
#' in-built functionality to deal with level-plots of rectangles.
#' @author STJ
#' @seealso \code{\link{deg2rect}}, \code{\link{geolines}},
#' \code{\link{geopolygon}}, \code{\link{rectPeri}}, \code{\link{reitaplott}},
#' \code{\link{geoSR}}.
#' @keywords hplot spatial
#' @examples
#'
#'
#' geoplot(grid = FALSE)
#' tmp <- island
#' tmp$sr <- d2sr(island)
#' srects <- aggregate(. ~ sr, tmp, length)
#' names(srects)[2] <- "count"
#' srects$lev <- cut(srects$count, c(0, 1, 5, 10, 20, 50, 100))
#' mycol <- heat.colors(length(unique(srects$lev)))
#' srgrid(srects$sr, fill = TRUE, col = mycol[srects$lev])
#' geolines(island)
#'
#'

#' @export rgrid
#' @rdname rectGrid
rgrid <-
  function(r, fill = FALSE, ...) {
    rect_grid_impl(
      r2d(r),
      lat_offset = c(-1 / 4, 1 / 4, 1 / 4, -1 / 4, -1 / 4),
      lon_offset = c(-0.5, -0.5, 0.5, 0.5, -0.5),
      fill = fill,
      ...
    )
  }

#' @export srgrid
#' @rdname rectGrid
srgrid <-
  function(sr, fill = FALSE, ...) {
    rect_grid_impl(
      sr2d(sr),
      lat_offset = c(-1 / 8, 1 / 8, 1 / 8, -1 / 8, -1 / 8),
      lon_offset = c(-0.25, -0.25, 0.25, 0.25, -0.25),
      fill = fill,
      ...
    )
  }

#' @export mrgrid
#' @rdname rectGrid
mrgrid <-
  function(mr, dlat = 5, dlon = 10, fill = FALSE, ...) {
    rect_grid_impl(
      mr2d(mr, dlat = dlat, dlon = dlon),
      lat_offset = c(
        dlat / 120,
        dlat / 120,
        -dlat / 120,
        -dlat / 120,
        dlat / 120
      ),
      lon_offset = c(
        dlon / 120,
        -dlon / 120,
        -dlon / 120,
        dlon / 120,
        dlon / 120
      ),
      fill = fill,
      ...
    )
  }

#' @export drgrid
#' @rdname rectGrid
drgrid <-
  function(dr, dlat = 1, dlon = 2, fill = FALSE, ...) {
    rect_grid_impl(
      dr2d(dr, dlat = dlat, dlon = dlon),
      lat_offset = c(dlat / 2, dlat / 2, -dlat / 2, -dlat / 2, dlat / 2),
      lon_offset = c(dlon / 2, -dlon / 2, -dlon / 2, dlon / 2, dlon / 2),
      fill = fill,
      ...
    )
  }

rect_grid_impl <-
  function(center, lat_offset, lon_offset, fill = FALSE, ...) {
    n <- length(center$lat)
    lat <- center$lat
    lon <- center$lon
    lat <- c(rep(lat, 5), rep(NA, n))
    lon <- c(rep(lon, 5), rep(NA, n))
    lat <- as.vector(matrix(matrix(lat, nrow = 6, byrow = T), ncol = 1))
    lon <- as.vector(matrix(matrix(lon, nrow = 6, byrow = T), ncol = 1))
    lat <- lat + c(lat_offset, NA)
    lon <- lon + c(lon_offset, NA)
    lat <- data.frame(lat = lat, lon = lon)
    if (fill) {
      geopolygon(lat, ...)
    } else {
      geolines(lat, ...)
    }
  }

# ---- rectArea.R ----
#' Given rectangle code return area in square kilometers or nautical miles
#'
#' Rectangle area is returned through a call to
#' \code{\link{rectPeri}}-functions and \code{\link{geoarea}}.
#'
#' @name rectArea
#' @aliases rA srA mrA drA
#' @param r,sr,mr,dr rectangle code, as in \code{\link{rect2deg}} and
#' \code{\link{deg2rect}}.
#' @param scale \code{nmi, km}, default \code{nmi} returns values in square
#' nautical miles for all except \code{drA} returns area in square kilometers.
#' @param dlat,dlon Dimensions of latitude and longitude given in minutes and
#' degrees for \code{mrPeri} and \code{drPeri}, respectively.
#' @return Rectangle area in square nautical miles or kilometers.
#' @note Unit \code{nmi} is used for historical/acoustical (sA) reasons.
#' @seealso \code{\link{rectPeri}}, \code{\link{deg2rect}},
#' \code{\link{geoarea}}.
#' @keywords arith manip
#' @examples
#'
#'   srA(7121)
#'   srA(7121, "km")
#'   srA(7121, "km")/1.852^2
#'   srA(7121, "km")
#'   rA(712)
#'   srA(7121) + srA(7122) + srA(7123) + srA(7124)
#'

#' @export rA
#' @rdname rectArea
rA <-
  function(r, scale = "nmi") {
    rect_area_impl(r, scale = scale, peri_fn = rPeri)
  }

#' @export srA
#' @rdname rectArea
srA <-
  function(sr, scale = "nmi") {
    rect_area_impl(sr, scale = scale, peri_fn = srPeri)
  }

#' @export mrA
#' @rdname rectArea
mrA <-
  function(mr, dlat = 5, dlon = 10, scale = "nmi") {
    rect_area_impl(
      mr,
      scale = scale,
      peri_fn = mrPeri,
      dlat = dlat,
      dlon = dlon
    )
  }

#' @export drA
#' @rdname rectArea
drA <-
  function(dr, dlat = 1, dlon = 2, scale = "km") {
    rect_area_impl(
      dr,
      scale = scale,
      peri_fn = drPeri,
      dlat = dlat,
      dlon = dlon
    )
  }

rect_area_impl <-
  function(code, scale = "nmi", peri_fn, dlat = NULL, dlon = NULL) {
    if (!(scale == "nmi" | scale == "km")) {
      stop("Unit square nautical miles or kilometers only")
    }
    if (is.null(dlat) && is.null(dlon)) {
      A <- sapply(code, function(x) geoarea(peri_fn(x)))
    } else {
      A <- sapply(
        code,
        function(x, dlat, dlon) {
          geoarea(peri_fn(x, dlat = dlat, dlon = dlon))
        },
        dlat = dlat,
        dlon = dlon
      )
    }
    if (scale == "nmi") {
      return(A / 1.852^2)
    }
    A
  }

# ---- rectPeri.R ----
#' Given rectangle code return perimeter as a polygon in lat lon
#'
#'
#' The outline/boundary of a statistical rectangle is returned as 5 positions,
#' the first and last of which are the same.
#'
#' @name rectPeri
#' @aliases rPeri srPeri mrPeri drPeri
#' @param r,sr,mr,dr Rectangle codes.
#' @param dlat,dlon Dimensions of latitude and longitude given in minutes and
#' degrees for \code{mrPeri} and \code{drPeri}, respectively.
#' @return Rectangle outline as 5 positions.
#' @note Should perhaps be extended to give a list or dataframe of polygons for
#' more than one \code{r, sr, mr} or \code{dr}.
#' @seealso \code{\link{deg2rect}}, \code{\link{rectArea}},
#' \code{\link{geoarea}}.
#' @keywords arith manip
#' @examples
#'
#'   geoplot(island, type = "n", grid = FALSE)
#'   geolines(rPeri(468))
#'   geolines(srPeri(4681))
#'

#' @export rPeri
#' @rdname rectPeri
rPeri <-
  function(r) {
    rect_peri_impl(
      r2d(r),
      lat_offset = c(1 / 4, 1 / 4, -1 / 4, -1 / 4, 1 / 4),
      lon_offset = c(0.5, -0.5, -0.5, 0.5, 0.5)
    )
  }

#' @export srPeri
#' @rdname rectPeri
srPeri <-
  function(sr) {
    rect_peri_impl(
      sr2d(sr),
      lat_offset = c(1 / 8, 1 / 8, -1 / 8, -1 / 8, 1 / 8),
      lon_offset = c(0.25, -0.25, -0.25, 0.25, 0.25)
    )
  }

#' @export mrPeri
#' @rdname rectPeri
mrPeri <-
  function(mr, dlat = 5, dlon = 10) {
    rect_peri_impl(
      mr2d(mr, dlat = dlat, dlon = dlon),
      lat_offset = c(
        dlat / 120,
        dlat / 120,
        -dlat / 120,
        -dlat / 120,
        dlat / 120
      ),
      lon_offset = c(
        dlon / 120,
        -dlon / 120,
        -dlon / 120,
        dlon / 120,
        dlon / 120
      )
    )
  }

#' @export drPeri
#' @rdname rectPeri
drPeri <-
  function(dr, dlat = 1, dlon = 2) {
    rect_peri_impl(
      dr2d(dr, dlat = dlat, dlon = dlon),
      lat_offset = c(dlat / 2, dlat / 2, -dlat / 2, -dlat / 2, dlat / 2),
      lon_offset = c(dlon / 2, -dlon / 2, -dlon / 2, dlon / 2, dlon / 2)
    )
  }

rect_peri_impl <-
  function(center, lat_offset, lon_offset) {
    lat <- center$lat
    lon <- center$lon
    lat <- lat + lat_offset
    lon <- lon + lon_offset
    data.frame(lat = lat, lon = lon)
  }
# ---- Set.grd.and.z.R ----
#' Manipulate grid and z-values for contouring.
#'
#' Manipulate grid and z-values for contouring.
#'
#'
#' @param grd grid
#' @param z z-value
#' @param mask mask
#' @param set set
#' @param col.names column names, defaults to \code{lat} and \code{lon}
#' @return Returns a list of: \item{grd}{grid} \item{z}{value over grid}
#' @note Used in \code{geocontour}-functions.
#' @keywords manip
#' @export Set.grd.and.z
Set.grd.and.z <-
  function(grd, z, mask, set = NA, col.names = c("lon", "lat")) {
    # z is a name of a column in the dataframe grd.
    if (is.data.frame(grd) && is.character(z)) {
      z <- grd[, z]
    }
    if (is.data.frame(grd) && nrow(grd) == length(z)) {
      i1 <- match(col.names[1], names(grd))
      i2 <- match(col.names[2], names(grd))
      xgr <- sort(unique(grd[, i1]))
      ygr <- sort(unique(grd[, i2]))
      xgr.1 <- c(matrix(xgr, length(xgr), length(ygr)))
      ygr.1 <- c(t(matrix(ygr, length(ygr), length(xgr))))
      xgr.data <- data.frame(x = xgr.1, y = ygr.1)
      names(xgr.data) <- col.names
      xgr.data$z <- rep(set, nrow(xgr.data))
      index <- paste(xgr.data[, 1], xgr.data[, 2], sep = "-")
      index1 <- paste(grd[, i1], grd[, i2], sep = "-")
      j <- match(index1, index)
      xgr.data$z[j] <- z
      grd1 <- list(xgr, ygr)
      names(grd1) <- col.names
      return(list(grd = grd1, z = xgr.data$z))
    }
    # grd is a list like returned by pointkriging
    if (is.list(grd) && !is.data.frame(grd)) {
      i1 <- match(col.names[1], names(grd))
      i2 <- match(col.names[2], names(grd))
      xgr <- grd[[i1]]
      ygr <- grd[[i2]]
      if (length(xgr) * length(ygr) != length(z)) {
        cat("Incorrect length on z")
        return(invisible())
      }
      xgr.1 <- c(matrix(xgr, length(xgr), length(ygr)))
      ygr.1 <- c(t(matrix(ygr, length(ygr), length(xgr))))
      xgr.data <- data.frame(x = xgr.1, y = ygr.1)
      names(xgr.data) <- col.names
      xgr.data$z <- z
      grd1 <- list(xgr, ygr)
      names(grd1) <- col.names
      return(list(grd = grd1, z = xgr.data$z))
    }
  }

# ---- setgrid.R ----
#' Produce a grid over an area
#'
#' Produce a grid over an area, possibly interactively.
#'
#'
#' @param lat Latitude
#' @param lon Longitude, if not included in \code{lat}
#' @param type Plot type
#' @param pch Plot character
#' @param xlim,ylim Limits for plot
#' @param b0 Base latitude
#' @param r Range expansion
#' @param country Country plotted
#' @param xlab,ylab Labels for x and y axes
#' @param option Method for determining plotted area extent, default "cut" (to
#' the range of the data)
#' @param reg Region to be gridded, can be set interactively
#' @param dx Resolution in each direction (?)
#' @param nx Number of gridpoints in each direction (?)
#' @param grpkt Gridpoints can also be supplied to the function for plotting
#' (??????????)
#' @param scale Projection scale (general \code{geo} default is "km")
#' @param find Should the gridpoints within \code{reg} be determined?
#' @param new Plot control argument ?
#' @param grid Draw grid (which grid?)
#' @param projection Projection to use
#' @param n Number of gridpoints (?)
#' @param b1 Second latitude for the Lambert projection
#' @param nholes number of holes to be sent to \code{geodefine} when setting
#' out the region to be gridded
#' @return List of components: \item{grpt}{Gridpoints} \item{reg}{Region over
#' which the grid was laid} \item{find}{Was \code{find = TRUE}?} \item{xgr}{If
#' \code{find = TRUE} the gridpoints within region \code{reg} is also
#' returned.}
#' @note Needs elaboration, check use of \code{find = TRUE}
#' @seealso Calls a number of functions, i.e. \code{\link{geodefine}},
#' \code{\link{geoplot}}, \code{\link{geopoints}}, \code{\link{gridpoints}},
#' \code{\link{inside}}, \code{\link{selectedpar}}
#' @keywords aplot iplot
#' @export setgrid
setgrid <-
  function(
    lat,
    lon = 0,
    type = "p",
    pch = "*",
    xlim = c(0, 0),
    ylim = c(0, 0),
    b0 = 65,
    r = 1.1,
    country = geo::island,
    xlab = "default",
    ylab = "default",
    option = "cut",
    reg = 0,
    dx = c(0, 0),
    nx = c(0, 0),
    grpkt = 0,
    scale = "km",
    find = F,
    new = F,
    grid = T,
    projection = "Mercator",
    n = 2500,
    b1 = b0,
    nholes = 0
  ) {
    geopar <- getOption("geopar")
    if (length(lon) == 1) {
      if (projection == "none") {
        lon <- lat$y
        lat <- lat$x
      } else {
        lon <- lat$lon
        lat <- lat$lat
      }
    }
    geoplot(
      lat,
      lon,
      type = type,
      pch = pch,
      xlim = xlim,
      ylim = ylim,
      b0 = b0,
      r = r,
      country = country,
      xlab = xlab,
      ylab = ylab,
      option = option,
      new = new,
      grid = grid,
      projection = projection,
      b1 = b1
    )
    # Find borders either given or with the locator.
    oldpar <- selectedpar()
    par(geopar$gpar)
    # set graphical parameters
    on.exit(par(oldpar))
    if (length(reg) == 1) {
      # use the locator.
      reg <- geodefine(nholes = nholes)
    }
    xgr <- gridpoints(reg, dx, grpkt, nx, n)
    # grid points.
    grpt <- xgr$xgr
    xgr <- xgr$xgra
    # change names
    geopoints(xgr, pch = ".")
    # 	Find what is inside the borders.
    if (find) {
      xgr <- inside(xgr, reg = reg)
      geopoints(xgr, pch = "+")
      return(list(xgr = xgr, grpt = grpt, reg = reg, find = find))
    } else {
      return(list(grpt = grpt, reg = reg, find = find))
    }
  }
