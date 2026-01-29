# Auto-generated grouping file: grid-interp.R
# Original function definitions were moved here for maintainability.

# ---- combine.rt.R ----
#' Aggregate data on square grid, pad with zeros.  Faster than tapply.
#'
#' Function that smooths data so data.  In each given square where the number
#' of points exceeds certain minimum the program gives the mean, sum, variance
#' or median of the points within the square as well as the number of points
#' and indication if the minimum number of points was reached.  For each
#' datapoint latitude, longitude and z has to be given.  The program returns
#' the mean and mean longitude for points within a square, as well as the
#' number of points behind that point. The program also has the possibility to
#' remove outliers within each square. This program can be used to prepare data
#' for the program pointkriging if the data is so dense in certain places that
#' it disturbs the neighbourhood search or if there are +10000 datapoints.
#'
#' It can also be used to find sums or averages of points within squares.
#'
#' The program works quite fast even for very large datasets.
#'
#'
#' @param lat Latitude of datapoints. ( or x coordinates)
#' @param lon Longitude of datapoints. (or y coordinate)
#' @param z Values at datapoints.
#' @param grlat Latitude of defined grid.
#' @param grlon Longitude of defined grid.  If 0 grlat is a list with
#' components lat and lon.
#' @param fun Function (?).
#' @param fill If fill is T the center points of squares where the number of
#' points does not reach the minimum is set to zero.  Good for data like
#' trawlers report where it can be assumed that there is little fish where they
#' do not try.
#' @param reg List with two components lat and lon.  Points outside region
#' are not returned.  The list is typically output from the program
#' define.area.
#' @param minnumber Minimum number of points needed for the square to be valid.
#' Default value is 2.
#' @param wsp Workspace.  Not of interest.
#' @param wz Weighing for the z values.  If one is trying to find the mean
#' tons/hour in an area is it reasonable to weigh tons/hour by the catch.  If
#' the weight is zero within a square unweighed mean is used.
#' @param wlat Weighing to find the mean latitude and mean longitude.  It is
#' often reasonable to weigh the latitude and the longitude by the catch.
#' @param xy Projected? Default unprojected (lat/lon) values, \code{FALSE}.
#' @param rat Ratio for "rm.outliers".  If rat is for example 0.2 20\% of the
#' points on each side are moved.  i.e. the middle 60\% are kept.  Default
#' value is 0.6.
#' @param type Only value with description \code{rm.outliers}.
#' @section Value: <s-example> List with components lat,lon,z,n and
#' fill.  lat mean latitude of points within each square.  lon mean
#' longitude of points within each square z sum, mean, variance or median of
#' data n Number of points behind point.
#'
#' If type = "rm.outliers" n this component stores the number of the square
#' corresponding to each point. fill If 0 there are datapoints behind the
#' points else it is an artificial point. (fill = T) </s-example>
#' @seealso \code{\link{variogram}}, \code{\link{variofit}},
#' \code{\link{pointkriging}}, \code{\link{grid}},
#' \code{\link{geocontour.fill}}.
#' @keywords <!--Put one or more s-keyword tags here-->
#' @export combine.rt
combine.rt <-
  function(
    lat,
    lon,
    z,
    grlat,
    grlon = 0,
    fun,
    fill = F,
    reg = 0,
    minnumber = 2,
    wsp = 0,
    wz = 0,
    wlat = 0,
    xy = F,
    rat = 0.2,
    type
  ) {
    if (missing(fun) && !missing(type)) {
      fun <- type
    }
    # for compatibility
    if (!missing(fun) && fun == "summa") {
      fun <- "sum"
    }
    # also for compatibility
    if (xy) {
      if (length(grlon) < 2) {
        grlon <- grlat$y
        grlat <- grlat$x
      }
    } else {
      if (length(grlon) < 2) {
        grlon <- grlat$lon
        grlat <- grlat$lat
      }
    }
    ndata <- length(lat)
    if (length(wz) != ndata) {
      wz <- rep(1, ndata)
    }
    if (length(wlat) != ndata) {
      wlat <- rep(1, ndata)
    }
    n <- length(grlon)
    m <- length(grlat)
    row <- cut(lat, grlat, labels = FALSE) # R ver
    col <- cut(lon, grlon, labels = FALSE) # R ver
    reitur <- (n - 1) * (row - 1) + col
    ind <- c(1:length(reitur))
    ind <- ind[!is.na(reitur)]
    lat <- lat[ind]
    lon <- lon[ind]
    z <- z[ind]
    wlat <- wlat[ind]
    wz <- wz[ind]
    reitur <- reitur[ind]
    maxrt <- (n - 1) * (m - 1)
    grdlat <- (grlat[1:(m - 1)] + grlat[2:m]) / 2
    grdlon <- (grlon[1:(n - 1)] + grlon[2:n]) / 2
    #	what to do
    if (fun == "mean") {
      option <- 1
    }
    if (fun == "sum") {
      option <- 2
    }
    if (fun == "median") {
      option <- 3
    }
    if (fun == "variance") {
      option <- 4
    }
    if (fun == "rm.outliers") {
      option <- 5
    }
    if (fun == "keep.all") {
      option <- 6
    }
    #	Fill up matrix of data.
    pts.in.reit <- c(matrix(0, round(ndata * 1.2), 1))
    npts.in.reit <- jrt <- indrt <- rep(0, maxrt + 1)
    nnewlat <- 0
    if (option == 5) {
      newlat <- newlon <- newz <- newn <- fylla <- rep(
        0,
        length(
          lat
        )
      )
    } else if (option == 6) {
      newlat <- newlon <- newz <- newn <- fylla <- rep(
        0,
        (length(
          lat
        ) +
          length(grlat) * length(grlon)) *
          1.1
      )
    } else {
      newlat <- newlon <- newz <- newn <- fylla <- rep(
        0,
        maxrt +
          1
      )
    }
    if (wsp == 0) {
      wsp <- ndata
    }
    outcome <- geo_combinert_impl(
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
    )
    newlat <- outcome$lat
    newlon <- outcome$lon
    newz <- outcome$z
    newn <- outcome$n
    fylla <- outcome$fill
    if (xy) {
      projection <- "none"
    } else {
      projection <- "Mercator"
    }
    if (length(reg) > 1) {
      inni <- inside(newlat, newlon, reg, option = 0, projection = projection)
      ind <- c(1:length(inni))
      ind <- ind[inni == 1]
      newlat <- newlat[ind]
      newlon <- newlon[ind]
      newz <- newz[ind]
      newn <- newn[ind]
    }
    if (option == 5) {
      fylla <- 0
    }
    # not used
    if (xy) {
      z <- list(x = newlat, y = newlon, z = newz, n = newn, fill = fylla)
    } else {
      z <- list(lat = newlat, lon = newlon, z = newz, n = newn, fill = fylla)
    }
    z <- data.frame(z)
    attributes(z)$fun <- fun
    return(invisible(z))
  }

# ---- variogram.R ----
#' Calculates the distance between each pair of datapoints.
#'
#' The program calculates the distance between each pair of datapoints.  The
#' distances are grouped in groups such that even number of pairs is in each
#' group.  Then the estimated variogram for each group is calculated either by
#' taking the mean or by a method from Cressie and Hawkins (1980).  The latter
#' method does in essence take the sum of the values^0.25. Only pair of points
#' with distance less than certain distance are used. Zero - Zero pairs are not
#' used if zzp is F.
#'
#'
#' @param lat Latitude of datapoints.  If lon=0 lat is a list with components
#' lat and lon.
#' @param z Values at datapoints.
#' @param lon longitude of datapoints.
#' @param nbins Number of distance intervals used.
#' @param maxdist maximum distance of interest.  Default value is range of
#' data*0.7.
#' @param Hawk If true the method from Cressie and Hawkins (1980) is used, else
#' the mean.  Default value is T
#' @param throwout If T datapoints with value zero are not used at all.
#' Default value is F which means that they are used.  In all cases zero-zero
#' pairs are not used when the variogram is estimated.
#' @param scale "km" or "nmi". Default is "km".
#' @param evennumber If T distance classes are chosen so approximately the same
#' number of points is in each distance class.  Else even distance increments
#' are used.
#' @param zzp If true zero-zero pairs are used else not.  Default value is F.
#' @param minnumber Distance intervals with minnumber or less pairs are not
#' included.  Default is zero.
#' @param col.names if lat is a dataframe col.names should contain the names of
#' the vectors containing the x and y coordinates, default is c("lat","lon")
#' @section Value: A list with the following components: <s-example>
#'
#' number: Number of pair in each distance class.  dist: Mean distance in each
#' distance class.  vario: variogram for each distance class. </s-example> The
#' list is suitable for the program variofit.  The variogram can also be
#' plotted by plvar(vagram,fit=F)
#' @seealso \code{\link{variofit}}, \code{\link{pointkriging}},
#' \code{\link{plvar}}.
#' @export variogram
variogram <-
  function(
    lat,
    lon = 0,
    z,
    nbins = 100,
    maxdist = 0,
    Hawk = T,
    throwout = F,
    scale = "km",
    evennumber = T,
    zzp = F,
    minnumber = 0,
    col.names = c(
      "lat",
      "lon"
    )
  ) {
    if (is.data.frame(lat)) {
      lon <- lat[[col.names[2]]]
      lat <- lat[[col.names[1]]]
    }
    eps <- 1e-06
    rad <- 6378.388
    # Radius of earth in km.
    if (col.names[1] == "lat" && col.names[2] == "lon") {
      xy <- F
      if (length(lon) < 2) {
        lon <- lat$lon
        lat <- lat$lat
      }
      #list
      if (scale == "nmi") {
        rad <- rad / 1.852
      }
      # distances in miles.
      lon <- (lon * pi) / 180
      # change from degrees to radians
      lat <- (lat * pi) / 180
    } else {
      xy <- T
    }
    if (throwout) {
      # throw out zero points.
      lat <- lat[abs(z) > eps]
      lon <- lon[abs(z) > eps]
      z1 <- z[abs(z) > eps]
      z <- z1
    }
    variance <- var(z)
    count <- length(lon)
    # measurements
    if (maxdist == 0) {
      rlat <- range(lat)
      rlon <- range(lon)
      if (xy) {
        maxdist <- pdistx(
          rlat[2],
          rlon[2],
          rlat[1],
          rlon[
            1
          ]
        ) *
          0.7
      } else {
        maxdist <- pdist(rlat[2], rlon[2], rlat[1], rlon[1]) *
          0.7
      }
      if (scale == "nmi") {
        maxdist <- maxdist / 1.852
      }
    }
    varioa <- dista <- numbera <- rep(0, nbins)
    if (evennumber) {
      nbins <- nbins * 10
    }
    ddist <- maxdist / nbins
    dist <- vario <- number <- rep(0, nbins)
    out <- geo_variogram_impl(
      lat,
      lon,
      z,
      ddist,
      nbins,
      Hawk,
      evennumber,
      zzp,
      xy
    )
    nbins <- out$nbins
    vario <- out$vario[1:nbins]
    dist <- out$dist[1:nbins]
    number <- out$number[1:nbins]
    ind <- c(1:length(number))
    ind <- ind[number < minnumber + 1]
    if (length(ind) == 0) {
      return(list(
        vario = vario,
        dist = dist,
        number = number,
        variance = variance
      ))
    } else {
      return(list(
        vario = vario[-ind],
        dist = dist[-ind],
        number = number[-ind],
        variance = variance
      ))
    }
  }

# ---- variofit.R ----
#' Function that fits a model to a variogram.
#'
#' Function that fits a model to a variogram.  The fitting occurs either
#' automatically or interactively.  The function is called after the function
#' variogram which calculates the variogram to which the model is fitted.
#' Currently only spherical model is supported.  Later other models will be
#' added.
#'
#'
#' @param vagram List with the calculated variogram. Components of the list
#' are: dist mean distance of the interval.  <s-example> vario calculated
#' value of the variogram.  number number of datapoints in the interval.
#' </s-example> In nearly all cases vagram will be the output from the program
#' variogram.
#' @param model Type of model.  Default is spherical.  It is currently the only
#' model supported.
#' @param option Method to use in automatic fitting.  Allowed values are 1,2,3
#' and 4.  Default value is 2.  For further information see below.
#' @param interactivt If T the fitting is done interactively by plotting the
#' variogram on the screen and asking the user to select sill, range and nugget
#' by the locator function.
#' @param sill Sill of the variogram, or: Limit of the variogram tending to
#' infinity lag distances (wikipedia).
#' @section Value: <s-example> A list with the following components.  nugget
#' : Estimated nugget effect sill : Estimated sill range : Estimated range
#' dist : mean distance of the interval.  vario : calculated value of the
#' variogram.  number : number of datapoints in the interval. </s-example>
#' @seealso \code{\link{variogram}}, \code{\link{pointkriging}}.
#' @export variofit
variofit <-
  function(vagram, model = 1, option = 2, interactivt = F, sill = 0) {
    if (model == 1 && !interactivt && option < 5) {
      if (sill == 0 && length(vagram$variance) > 0) {
        vagram$variance <- sill
      }
      vgr <- fitspher.aut.1(vagram, option, sill)
      if (vgr$error == 1) {
        return()
      }
      return(list(
        rang1 = vgr$rang1,
        sill = vgr$sill,
        nugget = vgr$nugget,
        dist = vagram$dist,
        vario = vagram$vario,
        number = vagram$number
      ))
    }
    if (interactivt) {
      k <- 1
      ld <- floor(length(vagram$dist) / 1.2)
      sill <- rang1 <- nugget <- rep(0, 10)
      ans <- "y"
      col <- 10
      plvar(vagram, fit = F)
      #		cat(" What type of model : , Gaussian, spherical ")
      while (ans == "y" || ans == "Y") {
        cat(" Give sill, range and nugget  in this order : \n")
        x <- locator(n = 3)
        sill[k] <- x$y[1]
        rang1[k] <- x$x[2]
        nugget[k] <- x$y[3]
        txt0 <- paste(" k = ", as.character(k))
        txt1 <- paste(" sill =", as.character(round(sill[k], digits = 2)))
        txt2 <- paste(
          "range = ",
          as.character(round(
            rang1[
              k
            ],
            digits = 2
          ))
        )
        txt3 <- paste(
          "nugget = ",
          as.character(round(
            nugget[
              k
            ],
            digits = 2
          ))
        )
        print(txt1)
        print(txt2)
        print(txt3)
        lines(
          vagram$dist,
          spherical(
            rang1[k],
            sill[k],
            nugget[
              k
            ],
            vagram$dist
          ),
          col = col
        )
        text(vagram$dist[ld], sill[k], as.character(k), col = col)
        col <- col + 10
        cat(" \n Try again y/n  : ")
        ans <- readline()
        k <- k + 1
        if (k == 10) NULL
        #				break()
      }
      nm <- 0
      cat("Give the number of the best model, default the last one:")
      nm <- scan(n = 1)
      if (length(nm) == 0) {
        nm <- k - 1
      }
      # default.
      rang1 <- rang1[nm]
      sill <- sill[nm]
      nugget <- nugget[nm]
    }
    return(list(
      rang1 = rang1,
      sill = sill,
      nugget = nugget,
      dist = vagram$dist,
      vario = vagram$vario,
      number = vagram$number
    ))
  }

# ---- pointkriging.R ----
#' interpolates regularly spaced data on a grid.
#'
#' The function interpolates regularly spaced data on a grid.  The program uses
#' inverse distance method that takes clustering into account.  Under certain
#' conditions this method can be called kriging.  For each gridpoint the
#' program looks for neighbourhood points according to certain criteria.  The
#' program has a possibility to prevent smearing data out from one area to
#' another where it is not wanted like between two fjords.  The program has the
#' possibility of universal kriging with the drift in lat,lon or due to an
#' external variable.
#'
#'
#' @param lat Latitude of datapoints.
#' @param lon Longitude of datapoints.
#' @param z Values at datapoints.
#' @param xgr Description of the grid. Can be output from program grid or just
#' a list with components lat and lon.
#' @param vagram Components of the variogram, a list with a least 3 components,
#' sill, nugget & rang1.
#' @param maxnumber Number of neighbourhood points used , default is 16.  In
#' some cases 16 points are not found.
#' @param scale Scale "km" or "miles", default is "miles".
#' @param option Option used for selecting neighbourhood points.  Allowed
#' values 1,2,3 and 4.  Default value is one.  For further information see
#' below.
#' @param maxdist If option = 4 all points within maxdist are used.  If option
#' = 4 the default value of maxdist is the range of the variogram.  maxdist has
#' also meaning when option = 1,2 or 3.  In those cases points further away
#' from any datapoint than maxdist are set to zero, mean z or NA.
#' @param rat The number of points in the first step of the search is
#' rat*maxnumber.
#' @param nb Parameter describing the extent of the area where neighbourhood
#' points are searched in the first round.  Default value is 8 which means that
#' and area of 16x16 gridpoints is searched.
#' @param set Points outside region or further away than maxdist from any
#' datapoint are set to either zero (set=0) or mean(z) set=1 or NA set =-1.
#' @param areas A list defining a number of areas.  NA is between areas.
#' Points in different areas are treated as independed.  Two neighbourhood
#' fjords could be defined as different areas so the program does not
#' interpolate between them.
#' @param varcalc If varcalc is true the estimation variance at each datapoint
#' is calculated. Default value is F.
#' @param sill Sill in variance calculations.  Default value is the sill of the
#' variogram.
#' @param minnumber If number of neighbourhood points found is less than or
#' equal to minnumber the point is considered outside the areas covered by the
#' datapoints and set to NA,0 or mean(z)
#' @param suboption If option = 4 and more than maxnumber points are found in
#' the area the program switches to option 1, 2 or 3 in the point search.
#' Default value is 1.
#' @param outside If outside is T points further away from the area than nb*dx
#' are excluded.  dx is the grid interval.  Too many points outside of the area
#' can problems in the search because the grid is used to divide the area in
#' squares and everything left and below the first gridpoint is for example one
#' square.
#' @param degree Degree of drift polynomial for universal kriging.  0, 1 or 2.
#' Default 0.
#' @param lognormal To be described.
#' @param zeroset To be described.
#' @return A vector with the calculated values at the gridpoints.
#' @section Side Effects: The program is partly written in C so if it crashes
#' Splus is exited.
#' @seealso \code{\link{variogram}}, \code{\link{variofit}},
#' \code{\link{grid}}, \code{\link{geocontour.fill}}.
#' @examples
#'
#' ##      See geocontour.fill
#'
#' @export pointkriging
pointkriging <-
  function(
    lat,
    lon,
    z,
    xgr,
    vagram,
    maxnumber = 16,
    scale = "km",
    option = 1,
    maxdist = 0,
    rat = 3,
    nb = 8,
    set = 0,
    areas = 0,
    varcalc = F,
    sill = 0,
    minnumber = 2,
    suboption = 1,
    outside = T,
    degree = 0,
    lognormal = F,
    zeroset = F
  ) {
    i <- match("rang1", names(vagram))
    if (is.na(i) || is.null(vagram$rang1) || length(vagram$rang1) == 0) {
      if (!is.na(match("range", names(vagram))) && length(vagram$range) > 0) {
        vagram$rang1 <- vagram$range
      } else {
        cat("variogram wrong")
        return(invisible())
      }
    }
    if (lognormal) {
      varcalc <- T
    }
    vgr <- c(vagram$rang1, vagram$sill, vagram$nugget)
    # components of variogram.
    ndata <- length(lat)
    d <- c(1, 3, 6)
    if (degree > 2) {
      degree <- 2
    }
    #	get row indices.
    xxx <- bua(nb)
    stdrrt <- xxx$rrt
    stdcrt <- xxx$crt
    dir <- xxx$dir
    i1 <- xxx$i1
    # 	get rid of data outside borders.
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
      ind <- c(1:length(lat))
      ind <- ind[lat > minlat & lat < maxlat & lon > minlon & lon < maxlon]
      lat <- lat[ind]
      lon <- lon[ind]
      z <- z[ind]
      ndata <- length(lat)
    }
    #	Fill up matrix of data.
    if (length(xgr$grpt) == 0) {
      lat1 <- c(t(matrix(xgr$lat, length(xgr$lat), length(xgr$lon))))
      lon1 <- c(matrix(xgr$lon, length(xgr$lon), length(xgr$lat)))
      #		geopoints(lat1,lon1)
      n <- length(xgr$lon)
      m <- length(xgr$lat)
      #
      # # labels = FALSE added in R version. # #
      #
      row <- cut(lat, c(-999, xgr$lat, 999), labels = FALSE)
      col <- cut(lon, c(-999, xgr$lon, 999), labels = FALSE)
      inni <- rep(1, length(lat1))
    }
    #	What to set points outside the range of data to.
    if (set == 0) {
      mz <- 0
    }
    if (set > 0) {
      mz <- mean(z)
    }
    if (set < 0) {
      mz <- -99999
    }
    #might be used for identification.
    reitur <- (n + 1) * (row - 1) + col
    treitur <- rep(1, ndata)
    # storage.
    pts.in.reit <- c(matrix(0, ndata * 1.2, 1))
    maxrt <- max(reitur)
    npts.in.reit <- rep(0, round((maxrt + 1) * 1.2))
    # 	mark points inside areas.
    if (length(areas) > 1) {
      ind <- c(1:length(areas$lat))
      ind <- ind[is.na(areas$lat)]
      if (length(ind) == 0) {
        NULL
      }
      #			break()
      nareas <- length(ind) + 1
      #number of areas
      ind <- c(0, ind, (length(areas$lat) + 1))
      isub <- rep(0, length(lat))
      isub1 <- rep(0, length(lat1))
      subareas <- 1
      for (i in (1:nareas)) {
        reg <- list(
          lat = areas$lat[
            (ind[i] + 1):(ind[i + 1] -
              1)
          ],
          lon = areas$lon[
            (ind[i] + 1):(ind[i + 1] -
              1)
          ]
        )
        border <- adapt(reg$lat, reg$lon)
        inn <- geo_point_in_multipolygon(lon, lat, border)
        inn1 <- geo_point_in_multipolygon(lon1, lat1, border)
        isub <- as.integer(inn) * i + isub
        isub1 <- as.integer(inn1) * i + isub1
      }
    } else {
      # No special areas.
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
      # look for dimensions of squares.
      if (maxdist == 0) {
        maxdist <- vagram$rang1
      }
      d1 <- pdist(gr$lat[1], gr$lon[1], gr$lat[2], gr$lon[2])
      d2 <- pdist(gr$lat[1], gr$lon[1], gr$lat[1], gr$lon[2])
      nm <- max(c(floor(maxdist / d1 + 1), floor(maxdist / d2 + 1)))
      if (nm > nb) {
        nm <- nb
      }
      i1 <- c(0, i1[nm + 1])
    }
    cov <- c(matrix(
      0,
      maxnumber + d[degree + 1],
      maxnumber +
        d[
          degree +
            1
        ]
    ))
    rhgtside <- x <- rhgtsbck <- rep(0, maxnumber + d[degree + 1])
    zgr <- variance <- lagrange <- rep(0, length(lat1))
    #	npts.in.reit <- rep(0, ndata)
    indrt <- jrt <- npts.in.reit
    if (varcalc && sill == 0) {
      sill <- vagram$sill
    }
    # calculate variance.
    xy <- 0
    # not xy coordinates
    out <- geo_pointkriging_impl(
      lat,
      lon,
      z,
      lat1,
      lon1,
      vgr,
      maxnumber,
      maxdist,
      option,
      minnumber,
      mz,
      zeroset,
      varcalc,
      sill,
      reitur = reitur,
      n = n,
      m = m,
      stdcrt = stdcrt,
      stdrrt = stdrrt,
      dir = dir,
      i1 = i1,
      rat = rat,
      treitur = treitur,
      isub = isub,
      isubgr = isub1,
      subareas = subareas,
      xy = xy,
      suboption = suboption
    )
    zgr <- out$zgr
    zgr[zgr == -99999] <- NA
    variance <- out$variance
    lagrange <- out$lagrange
    if (varcalc) {
      zgr <- list(zgr = zgr, variance = variance, lagrange = lagrange)
    }
    attributes(zgr)$vagram <- vagram
    attributes(zgr)$grid <- xgr
    attributes(zgr)$nb <- nb
    attributes(zgr)$option <- option
    attributes(zgr)$maxnumber <- maxnumber
    return(zgr)
  }

# ---- gridpoints.R ----
#' Produce gridpoints over an area
#'
#' Produce gridpoints over an area.
#'
#'
#' @param border Border of the area
#' @param dx Resolution in each direction (?)
#' @param grpkt ???
#' @param nx Number of gridpoints in each direction (?)
#' @param n Total number of gridpoints (?)
#' @return List with components: \item{xgr}{List of gridpoints in components
#' \code{lat, lon} or \code{x,y} depending on the projection.} \item{xgra}{List
#' of those gridpoints within the area given in \code{border}}
#' @note Needs further elaboration, check use with \code{find = TRUE} in
#' \code{setgrid}.
#' @seealso Called by \code{\link{setgrid}}.
#' @keywords manip
#' @export gridpoints
gridpoints <-
  function(border, dx, grpkt, nx, n) {
    geopar <- getOption("geopar")
    if (length(grpkt) == 1) {
      # gridpoints not given.
      if (geopar$projection == "none") {
        xmin <- min(border$x)
        xmax <- max(border$x)
        ymin <- min(border$y)
        ymax <- max(border$y)
      } else {
        xmin <- min(border$lon)
        xmax <- max(border$lon)
        ymin <- min(border$lat)
        ymax <- max(border$lat)
        meanlat <- (mean(border$lat) * pi) / 180
      }
      if (dx[1] == 0) {
        if (nx[1] == 0) {
          n <- sqrt(n)
          if (geopar$projection == "none") {
            k <- (xmax - xmin) / (ymax - ymin)
          } else {
            k <- ((xmax - xmin) * cos(meanlat)) / (ymax - ymin)
          }
          nx[1] <- round(n * sqrt(k))
          nx[2] <- round(n / sqrt(k))
        }
        dx[1] <- (xmax - xmin) / nx[1]
        dx[2] <- (ymax - ymin) / nx[2]
      } else {
        tmp <- dx[1]
        dx[1] <- dx[2]
        dx[2] <- tmp
        #exchange lat lon.
        nx[1] <- trunc((xmax - xmin) / dx[1])
        nx[2] <- trunc((ymax - ymin) / dx[2])
      }
      xgr <- (xmin - dx[1]) + c(1:(nx[1] + 2)) * dx[1]
      ygr <- (ymin - dx[2]) + c(1:(nx[2] + 2)) * dx[2]
    } else if (geopar$projection == "none") {
      xgr <- grpkt$x
      ygr <- grpkt$y
    } else {
      xgr <- grpkt$lon
      ygr <- grpkt$lat
    }
    lx <- length(xgr)
    ly <- length(ygr)
    xgra <- c(matrix(xgr, lx, ly))
    ygra <- c(t(matrix(ygr, ly, lx)))
    if (geopar$projection == "none") {
      xgra <- list(x = xgra, y = ygra)
      xgr <- list(x = xgr, y = ygr)
    } else {
      xgra <- list(lon = xgra, lat = ygra)
      xgr <- list(lon = xgr, lat = ygr)
    }
    return(list(xgr = xgr, xgra = xgra))
  }

# ---- geogrid.R ----
#' Plots a grid.
#'
#' Plots a grid defined by the vectors lat, lon. The grid is plotted on a graph
#' initialized by geoplot.  lon gives the meridians plotted and lat the
#' parallels plotted.
#'
#'
#' @param lat,lon Latitude and longitude of data ( or x and y coordinates),
#' negative for southern latitudes and western longitudes.  May be supplied as
#' two vectors or as a dataframe lat (or x) including vectors \code{lat$lat}
#' and \code{lat$lon} (\code{x$x} and \code{x$y} if projection = none).
#' @param col Color number used, default value is 1 (black).
#' @param type "l" means line and "p" points.  Default is "l".
#' @param lwd Linewidth.  Default value is the value set when the program was
#' called.
#' @param lty Linetype.  Default value is the value set when the program was
#' called.
#' @param pch Type of symbol at gridpoints default is "+".
#' @param nx sets smoothness of curved Lambert parallels
#' @return No values returned.
#' @seealso \code{\link{geoplot}}, \code{\link{geolines}},
#' \code{\link{geopolygon}}, \code{\link{geotext}}, \code{\link{geosymbols}},
#' \code{\link{geopar}}, \code{\link{geolocator}}, \code{\link{geocontour}}.
#' @examples
#'
#' \dontrun{       geogrid(latgr, longgr)
#'
#'        codgrd <- list(lat = seq(62, 68, by = 0.1), lon = seq(-28, -10, 0.25))
#'        geogrid(codgrd)   # a fine grid of Iceland and neighbouring seas
#'        geoplot(new = T)
#' }
#' @export geogrid
geogrid <-
  function(
    lat,
    lon = 0,
    col = 1,
    type = "l",
    lwd = 0,
    lty = 0,
    pch = "+",
    nx = 5
  ) {
    geopar <- getOption("geopar")
    oldpar <- selectedpar()
    if (length(lon) == 1) {
      if (geopar$projection == "none") {
        lon <- lat$y
        lat <- lat$x
      } else {
        lon <- lat$lon
        lat <- lat$lat
      }
    }
    if (geopar$projection == "Lambert") {
      nx <- nx
    } else {
      nx <- 1
    }
    if (geopar$projection != "none") {
      if (mean(lat, na.rm = T) > 1000) {
        lat <- geoconvert(lat)
        lon <- -geoconvert(lon)
      }
    }
    if (type == "l") {
      llon <- length(lon)
      llat <- length(lat)
      latgr <- t(matrix(lat, llat, llon))
      longr <- matrix(lon, llon, llat)
      latgr <- rbind(latgr, rep(NA, ncol(latgr)))
      longr <- rbind(longr, rep(NA, ncol(longr)))
      geolines(latgr, longr, col = col, lwd = lwd, lty = lty, nx = nx)
      llon <- length(lon)
      llat <- length(lat)
      latgr <- matrix(lat, llat, llon)
      longr <- t(matrix(lon, llon, llat))
      latgr <- rbind(latgr, rep(NA, ncol(latgr)))
      longr <- rbind(longr, rep(NA, ncol(longr)))
      geolines(latgr, longr, col = col, lwd = lwd, lty = lty, nx = nx)
    } else {
      llon <- length(lon)
      llat <- length(lat)
      latgr <- c(t(matrix(lat, llat, llon)))
      longr <- c(matrix(lon, llon, llat))
      geopoints(latgr, longr, pch = pch)
    }
    return(invisible())
    par(oldpar)
  }
