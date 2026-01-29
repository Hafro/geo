# Auto-generated grouping file: geometry.R
# Original function definitions were moved here for maintainability.

# ---- inside.R ----
#' Finds a subset of data inside (or outside) a region
#'
#' Finds a subset of data within or without a region, returned as submatrix,
#' boolean vector or indices of the original data.
#'
#'
#' @param lat,lon Latitude and longitude of the data, if \code{lat = 0},
#' \code{lat} must have components \code{lat, lon} or \code{x, y} in case
#' projection is \code{"none"}.
#' @param reg Region we want to check wheter or not includes the data.
#' @param option How should the results be returned: \describe{
#' \item{1}{Submatrix of data inside \code{reg}} \item{2}{Submatrix of data
#' outside \code{reg}} \item{3}{Boolean vector, TRUE for data inside
#' \code{reg}} \item{4}{Boolean vector, TRUE for data outside \code{reg}}
#' \item{5}{Indices of data inside \code{reg}} \item{6}{Indices of data outside
#' \code{reg}}}
#' @param projection Projection, default \code{"none"}
#' @return Submatrix, boolean vector or index to data as described for argument
#' \code{option}.
#' @note Needs elaboration, why is this needed in addition to \code{geoinside}?
#' @seealso Called by \code{\link{combine.rt}}, \code{\link{setgrid}}, calls
#' \code{\link{adapt}}.
#' @keywords manip
#' @export inside
inside <-
  function(lat, lon = 0., reg, option = 1., projection = "Mercator") {
    # temporary copy
    tmp <- lat
    if (length(lon) < 2. & length(lat) >= 2.) {
      if (projection == "none") {
        lon <- lat$y
        lat <- lat$x
      } else {
        lon <- lat$lon
        lat <- lat$lat
      }
    }
    if (length(reg$lat) == 2. && length(reg$lon) == 2.) {
      # rectangular limits 2 pts.
      la <- range(reg$lat)
      lo <- range(reg$lon)
      reg <- list(
        lat = c(la[1.], la[1.], la[2.], la[2.], la[1.]),
        lon = c(lo[1.], lo[2.], lo[2.], lo[1.], lo[1.])
      )
    }
    n <- length(reg$lat)
    # has to be closed
    if (n > 0.) {
      if (reg$lat[1.] != reg$lat[n] | reg$lon[1.] != reg$lon[n]) {
        reg$lat <- c(reg$lat, reg$lat[1.])
        reg$lon <- c(reg$lon, reg$lon[1.])
      }
    }
    indx <- c(1.:length(lat))
    indx <- indx[is.na(lat)]
    #outside borders.
    if (length(indx) > 0.) {
      lat[indx] <- 70.
      lon[indx] <- -60.
    }
    if (projection == "none") {
      border <- adapt(reg$x, reg$y, projection = "none")
      border <- list(lat = border$y, lon = border$x, lxv = border$lxv)
    } else {
      border <- adapt(reg$lat, reg$lon)
    }
    inni <- as.integer(geo_point_in_multipolygon(lon, lat, border))
    ind <- c(1.:length(inni))
    ind <- ind[inni > 0.]
    if (option == 1.) {
      if (is.data.frame(tmp)) {
        tmp <- tmp[ind, ]
        return(tmp)
      } else {
        lat <- lat[ind]
        lon <- lon[ind]
        if (projection == "none") {
          return(x = lat, y = lon)
        } else {
          return(lat, lon)
        }
      }
    } else if (option == 2.) {
      if (is.data.frame(tmp)) {
        tmp <- tmp[-ind, ]
        return(tmp)
      } else {
        lat <- lat[-ind]
        lon <- lon[-ind]
        if (projection == "none") {
          return(x = lat, y = lon)
        } else {
          return(lat, lon)
        }
      }
    } else if (option == 3.) {
      return(inni)
    } else if (option == 5.) {
      ind <- c(1.:length(inni))
      ind <- ind[inni == 0.]
      return(ind)
    } else {
      return(ind)
    }
  }

# ---- geoinside.R ----
#' Finds a subset of a given set of data which is inside a given region.
#'
#' Finds a subset of a given set of data which is inside or outside a given
#' region and returns a submatrix of those values, boolean vector of indexes or
#' index vector.
#'
#'
#' @param data a dataframe, should include vectors lat and lon, but will
#' except other names, see col.names.
#' @param reg The region we want to determine whether the data is inside of,
#' should include vectors with same names as data.
#' @param option Allows you to determine on what format you recieve the output:
#' <s-example> option = 1: returns the submatrix of data which is inside reg.
#' option = 2: returns the submatrix of data which is outside reg.  option = 3:
#' returns a boolean vector saying whether a given index is inside reg.  option
#' = 4: returns a boolean vector saying whether a give index is outside reg.
#' option = 5: returns a vector of indexes to data, data[return[i],] is the
#' i-th point in data inside reg.  option = 6: returns a vector of indexes to
#' data, data[return[i],] is the i-th point in data outside reg. </s-example>
#' @param col.names Default col.names = c("lat","lon"), determines the names of
#' the base vectors of the space we are viewing.  May be replaced by for
#' instance col.names = c("x","y")
#' @param na.rm If true values where lat or lon are NA are removed.
#' Default is false.
#' @param robust If true a robust search is done, if false the function runs
#' faster.  Default is true. Robust = T will not work if the regions edges
#' overlap each other, if region is sensibly defined this will not happen and
#' robust =F should be used.
#' @return Returns and output vector or matrix, see option.
#' @section Side Effects: None.
#' @seealso \code{\link{geoplot}}, \code{\link{geolocator}}.
#' @examples
#'
#' \dontrun{   seafishing <- geoinside(fishing,island,option=2)
#'    # Removes those datapoints from fishing where fishing took
#'    # place inside Iceland (misspells).
#'
#'    grd <- list(lat=c(64,64,63,63),lon=c(-23,-22,-22,-23))
#'    ins.lat.64.63.lon.23.22 <- geoinside(fishing,grd,robust =T)
#'    # Extracts those points from fishing where fishing
#'    # took place inside the given box.
#'
#'
#'
#'    #######################################################
#'    # Example                                             #
#'    #######################################################
#'
#'    par(mfrow=c(2,1))
#'    stations<-data.frame(lat=stodvar$lat,lon=stodvar$lon)
#'    stations<-stations[!is.na(stations$lon),]
#'    stations<-stations[!is.na(stations$lat),]
#'
#'    geoplot(grid=F)
#'    geopoints(stations,pch=".",col=25)
#'    title(main="Before geoinside")
#'
#'    sea.stations <- geoinside(stations,island,option=2)
#'    # Removes those datapoints from stations where
#'    # measurments took place inside Iceland (misspells).
#'
#'    geoplot(grid=F)
#'    geopoints(sea.stations,pch=".",col=25)
#'    title(main="After geoinside")
#'
#'    #######################################################
#'
#' }
#' @export geoinside
geoinside <-
  function(
    data,
    reg,
    option = 1,
    col.names = c("lat", "lon"),
    na.rm = T,
    robust = F
  ) {
    if (!is.data.frame(data)) {
      i <- match(col.names, names(data))
      data <- data.frame(data[[i[1]]], data[[i[2]]])
      names(data) <- col.names
    }
    i <- match(col.names, names(data))
    index <- rep(NA, nrow(data))
    j <- rep(T, nrow(data))
    tmp <- data
    if (na.rm) {
      j <- !is.na(data[, i[1]]) & !is.na(data[, i[2]])
      data <- data[j, ]
    }
    i1 <- match(col.names, names(reg))
    regx <- reg[[i1[1]]]
    regy <- reg[[i1[2]]]
    n <- length(regx)
    k <- (regx[1] != regx[n] || regy[1] != regy[n]) && length(regx) != 2
    if (k && !is.na(k)) {
      regx <- c(regx, regx[1])
      regy <- c(regy, regy[1])
    }
    reg <- list(x = regx, y = regy)
    if (length(reg$x) == 2) {
      reg <- list(
        x = c(reg$x[1], reg$x[2], reg$x[2], reg$x[1], reg$x[1]),
        y = c(reg$y[1], reg$y[1], reg$y[2], reg$y[2], reg$y[1])
      )
    }
    data <- list(x = data[[i[1]]], y = data[[i[2]]])
    border <- adapt(reg$y, reg$x, projection = "none")
    inside <- as.integer(geo_point_in_multipolygon(
      data$x,
      data$y,
      list(lat = border$y, lon = border$x, lxv = border$lxv)
    ))
    index[j] <- inside
    inside <- index
    ind <- c(1:length(inside))
    ind <- ind[inside > 0 & !is.na(inside)]
    if (option == 1) {
      tmp <- tmp[ind, ]
      return(tmp)
    } else if (option == 2) {
      tmp <- tmp[-ind, ]
      return(tmp)
    } else if (option == 3) {
      return(inside)
    } else if (option == 4) {
      return(1 - inside)
    } else if (option == 5) {
      ind <- c(1:length(inside))
      ind <- ind[inside == 0]
      return(ind)
    } else if (option == 6) {
      ind <- c(1:length(inside))
      ind <- ind[inside != 0]
      return(ind)
    } else {
      return(ind)
    }
  }

# ---- inside.reg.bc.R ----
#' Determine which bormicon (or gadget) region data belong to.
#'
#' Determine which bormicon (or approximately gadget) region data belong to.
#'
#'
#' @param data Data set with coordinates in components \code{lat, lon}.
#' @param only.sv.1to10 Label only data belonging to areas 1 to 10 (depth < 500
#' m). Default FALSE
#' @param ignore.latlon Use rectangle resolution ???
#' @param ignore.area0 Action for data not belonging to bc-areas, not used???
#' @return Returns original data with area code as an added component
#' \code{area}.
#' @note Needs elaboration, esp. when based on rectangles, merge doc with
#' inside.reg.bc1.
#' @seealso Calls \code{\link{inside.reg.bc1}},
#' \code{\link{Reitur2Svaedi1to10}}, \code{\link{sr2d}}. Data set
#' \code{\link{reg.bc}} with bormicon-area outlines is used.
#' @keywords manip
#' @export inside.reg.bc
inside.reg.bc <-
  function(data, only.sv.1to10 = F, ignore.latlon = F, ignore.area0 = T) {
    if (is.na(match("lat", names(data)))) {
      data$lat <- data$lon <- rep(NA, nrow(data))
    }
    if (!is.na(match("area", names(data)))) {
      print("warning column area exists")
      return(invisible(data))
    }
    n <- nrow(data)
    data$area <- rep(NA, nrow(data))
    index <- !is.na(data$lat) & !is.na(data$lon)
    index1 <- c(1:length(index))
    index1 <- index1[index]
    if (ignore.latlon) {
      index1 <- NULL
    }
    if (length(index1) > 0) {
      area <- inside.reg.bc1(data[index1, c("lat", "lon")])$area
      data$area[index1] <- area
    }
    if (is.na(match("reitur", names(data)))) {
      return(data)
    }
    if (ignore.latlon) {
      index1 <- c(1:nrow(data))
    } else {
      index <- (is.na(data$lat) | is.na(data$lon)) & !is.na(data$reitur)
      if (ignore.area0) {
        index <- index | (data$area == 0 & !is.na(data$area))
      }
      index1 <- c(1:length(index))
      index1 <- index1[index]
    }
    if (length(index1) > 0) {
      reitdata <- data[index1, ]
      if (only.sv.1to10) {
        reitdata$area <- Reitur2Svaedi1to10(reitdata$reitur)
      } else {
        if (is.na(match("smareitur", names(reitdata)))) {
          reitdata$smareitur <- rep(0, nrow(reitdata))
        } else {
          reitdata$smareitur[is.na(reitdata$smareitur)] <-
            0
        }
        tmp <- data.frame(sr2d(reitdata$reitur * 10 + reitdata$smareitur))
        ind <- c(1:nrow(tmp))
        ind <- ind[!is.na(tmp$lat)]
        reitdata$area[ind] <- inside.reg.bc1(tmp[ind, ])$area
      }
      data$area[index1] <- reitdata$area
    }
    return(data)
  }

# ---- inside.reg.bc1.R ----
#' Determine which bormicon (or gadget) region data belong to.
#'
#' Determine which bormicon (or approximately gadget) region data belong to.
#'
#'
#' @param data Data set with coordinates in components \code{lat, lon}.
#' @return Returns original data with area code as an added component
#' \code{area}.
#' @note Needs further elaboration ?
#' @seealso Calls \code{\link{geoinside}}, called by
#' \code{\link{inside.reg.bc}} and \code{\link{Reitur2Svaedi1to10}}. Data set
#' \code{\link{reg.bc}} with bormicon-area outlines is used.
#' @keywords manip
#' @export inside.reg.bc1
inside.reg.bc1 <-
  function(data) {
    if (nrow(data) > 1) {
      tmpdata <- data[, c("lat", "lon")]
    } else {
      tmpdata <- as.data.frame(data[, c("lat", "lon")])
    }
    tmpdata$area <- rep(0, nrow(tmpdata))
    i <- 1
    ind <- geoinside(tmpdata, reg = geo::reg.bc[[i]], option = 0, robust = F)
    if (length(ind) > 0) {
      tmpdata[ind, "area"] <- i
    }
    i <- 2
    j <- tmpdata$area == 0
    j1 <- c(1:length(j))
    j1 <- j1[j == T]
    if (length(j1) > 0) {
      ind <- geoinside(
        tmpdata[j1, ],
        reg = geo::reg.bc[[i]],
        option = 0,
        robust = F
      )
      if (length(ind) > 0) {
        tmpdata[j1[ind], "area"] <- i
      }
    }
    i <- 3
    j <- tmpdata$area == 0
    j1 <- c(1:length(j))
    j1 <- j1[j == T]
    if (length(j1) > 0) {
      ind <- geoinside(
        tmpdata[j1, ],
        reg = geo::reg.bc[[i]],
        option = 0,
        robust = F
      )
      if (length(ind) > 0) {
        tmpdata[j1[ind], "area"] <- i
      }
    }
    i <- 4
    j <- tmpdata$area == 0
    j1 <- c(1:length(j))
    j1 <- j1[j == T]
    if (length(j1) > 0) {
      ind <- geoinside(
        tmpdata[j1, ],
        reg = geo::reg.bc[[i]],
        option = 0,
        robust = F
      )
      if (length(ind) > 0) {
        tmpdata[j1[ind], "area"] <- i
      }
    }
    i <- 5
    j <- tmpdata$area == 0
    j1 <- c(1:length(j))
    j1 <- j1[j == T]
    if (length(j1) > 0) {
      ind <- geoinside(
        tmpdata[j1, ],
        reg = geo::reg.bc[[i]],
        option = 0,
        robust = F
      )
      if (length(ind) > 0) {
        tmpdata[j1[ind], "area"] <- i
      }
    }
    i <- 6
    j <- tmpdata$area == 0
    j1 <- c(1:length(j))
    j1 <- j1[j == T]
    if (length(j1) > 0) {
      ind <- geoinside(
        tmpdata[j1, ],
        reg = geo::reg.bc[[i]],
        option = 0,
        robust = F
      )
      if (length(ind) > 0) {
        tmpdata[j1[ind], "area"] <- i
      }
    }
    i <- 7
    j <- tmpdata$area == 0
    j1 <- c(1:length(j))
    j1 <- j1[j == T]
    if (length(j1) > 0) {
      ind <- geoinside(
        tmpdata[j1, ],
        reg = geo::reg.bc[[i]],
        option = 0,
        robust = F
      )
      if (length(ind) > 0) {
        tmpdata[j1[ind], "area"] <- i
      }
    }
    i <- 8
    j <- tmpdata$area == 0
    j1 <- c(1:length(j))
    j1 <- j1[j == T]
    if (length(j1) > 0) {
      ind <- geoinside(
        tmpdata[j1, ],
        reg = geo::reg.bc[[i]],
        option = 0,
        robust = F
      )
      if (length(ind) > 0) {
        tmpdata[j1[ind], "area"] <- i
      }
    }
    i <- 9
    j <- tmpdata$area == 0
    j1 <- c(1:length(j))
    j1 <- j1[j == T]
    if (length(j1) > 0) {
      ind <- geoinside(
        tmpdata[j1, ],
        reg = geo::reg.bc[[i]],
        option = 0,
        robust = F
      )
      if (length(ind) > 0) {
        tmpdata[j1[ind], "area"] <- i
      }
    }
    i <- 10
    j <- tmpdata$area == 0
    j1 <- c(1:length(j))
    j1 <- j1[j == T]
    if (length(j1) > 0) {
      ind <- geoinside(
        tmpdata[j1, ],
        reg = geo::reg.bc[[i]],
        option = 0,
        robust = F
      )
      if (length(ind) > 0) {
        tmpdata[j1[ind], "area"] <- i
      }
    }
    i <- 11
    j <- tmpdata$area == 0
    j1 <- c(1:length(j))
    j1 <- j1[j == T]
    if (length(j1) > 0) {
      ind <- geoinside(
        tmpdata[j1, ],
        reg = geo::reg.bc[[i]],
        option = 0,
        robust = F
      )
      if (length(ind) > 0) {
        tmpdata[j1[ind], "area"] <- i
      }
    }
    i <- 12
    j <- tmpdata$area == 0
    j1 <- c(1:length(j))
    j1 <- j1[j == T]
    if (length(j1) > 0) {
      ind <- geoinside(
        tmpdata[j1, ],
        reg = geo::reg.bc[[i]],
        option = 0,
        robust = F
      )
      if (length(ind) > 0) {
        tmpdata[j1[ind], "area"] <- i
      }
    }
    i <- 13
    j <- tmpdata$area == 0
    j1 <- c(1:length(j))
    j1 <- j1[j == T]
    if (length(j1) > 0) {
      ind <- geoinside(
        tmpdata[j1, ],
        reg = geo::reg.bc[[i]],
        option = 0,
        robust = F
      )
      if (length(ind) > 0) {
        tmpdata[j1[ind], "area"] <- i
      }
    }
    i <- 14
    j <- tmpdata$area == 0
    j1 <- c(1:length(j))
    j1 <- j1[j == T]
    if (length(j1) > 0) {
      ind <- geoinside(
        tmpdata[j1, ],
        reg = geo::reg.bc[[i]],
        option = 0,
        robust = F
      )
      if (length(ind) > 0) {
        tmpdata[j1[ind], "area"] <- i
      }
    }
    i <- 15
    j <- tmpdata$area == 0
    j1 <- c(1:length(j))
    j1 <- j1[j == T]
    if (length(j1) > 0) {
      ind <- geoinside(
        tmpdata[j1, ],
        reg = geo::reg.bc[[i]],
        option = 0,
        robust = F
      )
      if (length(ind) > 0) {
        tmpdata[j1[ind], "area"] <- i
      }
    }
    i <- 16
    j <- tmpdata$area == 0
    j1 <- c(1:length(j))
    j1 <- j1[j == T]
    if (length(j1) > 0) {
      ind <- geoinside(
        tmpdata[j1, ],
        reg = geo::reg.bc[[i]],
        option = 0,
        robust = F
      )
      if (length(ind) > 0) {
        tmpdata[j1[ind], "area"] <- i
      }
    }
    data$area <- tmpdata$area
    return(data)
  }

# ---- inside.reg.lump.R ----
#' Inside region in lumpsucker fishery
#'
#' Finds regulation area from a position given in dataframe
#'
#' to be added later
#'
#' @param data Data frame with columns \code{lat} and \code{lon} givin postions
#' @return Original data with column area added, with index to list of
#' regulation areas in \code{\link{reg.lump}}.
#' @note Could be repeated for other area divisions.
#' @author STJ
#' @seealso \code{\link[geo]{inside.reg.bc}}, \code{\link{reg.lump}}.
#' @references Borrows from \code{\link[geo]{inside.reg.bc}}.
#' @keywords manip
#' @examples
#'
#' ##---- Should be DIRECTLY executable !! ----
#' ##-- ==>  Define data, use random,
#' ##--	or do  help(data=index)  for the standard data sets.
#'
#' ## The function is currently defined as
#' function (data)
#' {
#'     if (nrow(data) > 1)
#'         tmpdata <- data[, c("lat", "lon")]
#'     else tmpdata <- as.data.frame(data[, c("lat", "lon")])
#'     tmpdata$area <- rep(0, nrow(tmpdata))
#'     i <- 1
#'     ind <- geoinside(tmpdata, reg = reg.lump[[i]], option = 0,
#'         robust = FALSE)
#'     if (length(ind) > 0)
#'         tmpdata[ind, "area"] <- i
#'     i <- 2
#'     j <- tmpdata$area == 0
#'     j1 <- c(1:length(j))
#'     j1 <- j1[j == T]
#'     if (length(j1) > 0) {
#'         ind <- geoinside(tmpdata[j1, ], reg = reg.lump[[i]],
#'             option = 0, robust = FALSE)
#'         if (length(ind) > 0)
#'             tmpdata[j1[ind], "area"] <- i
#'     }
#'     i <- 3
#'     j <- tmpdata$area == 0
#'     j1 <- c(1:length(j))
#'     j1 <- j1[j == T]
#'     if (length(j1) > 0) {
#'         ind <- geoinside(tmpdata[j1, ], reg = reg.lump[[i]],
#'             option = 0, robust = FALSE)
#'         if (length(ind) > 0)
#'             tmpdata[j1[ind], "area"] <- i
#'     }
#'     i <- 4
#'     j <- tmpdata$area == 0
#'     j1 <- c(1:length(j))
#'     j1 <- j1[j == T]
#'     if (length(j1) > 0) {
#'         ind <- geoinside(tmpdata[j1, ], reg = reg.lump[[i]],
#'             option = 0, robust = FALSE)
#'         if (length(ind) > 0)
#'             tmpdata[j1[ind], "area"] <- i
#'     }
#'     i <- 5
#'     j <- tmpdata$area == 0
#'     j1 <- c(1:length(j))
#'     j1 <- j1[j == T]
#'     if (length(j1) > 0) {
#'         ind <- geoinside(tmpdata[j1, ], reg = reg.lump[[i]],
#'             option = 0, robust = FALSE)
#'         if (length(ind) > 0)
#'             tmpdata[j1[ind], "area"] <- i
#'     }
#'     i <- 6
#'     j <- tmpdata$area == 0
#'     j1 <- c(1:length(j))
#'     j1 <- j1[j == T]
#'     if (length(j1) > 0) {
#'         ind <- geoinside(tmpdata[j1, ], reg = reg.lump[[i]],
#'             option = 0, robust = FALSE)
#'         if (length(ind) > 0)
#'             tmpdata[j1[ind], "area"] <- i
#'     }
#'     i <- 7
#'     j <- tmpdata$area == 0
#'     j1 <- c(1:length(j))
#'     j1 <- j1[j == T]
#'     if (length(j1) > 0) {
#'         ind <- geoinside(tmpdata[j1, ], reg = reg.lump[[i]],
#'             option = 0, robust = FALSE)
#'         if (length(ind) > 0)
#'             tmpdata[j1[ind], "area"] <- i
#'     }
#'     i <- 8
#'     j <- tmpdata$area == 0
#'     j1 <- c(1:length(j))
#'     j1 <- j1[j == T]
#'     if (length(j1) > 0) {
#'         ind <- geoinside(tmpdata[j1, ], reg = reg.lump[[i]],
#'             option = 0, robust = FALSE)
#'         if (length(ind) > 0)
#'             tmpdata[j1[ind], "area"] <- i
#'     }
#'     data$area <- tmpdata$area
#'     return(data)
#'   }
#'
#' @export inside.reg.lump
inside.reg.lump <-
  function(data) {
    if (nrow(data) > 1) {
      tmpdata <- data[, c("lat", "lon")]
    } else {
      tmpdata <- as.data.frame(data[, c("lat", "lon")])
    }
    tmpdata$area <- rep(0, nrow(tmpdata))
    i <- 1
    ind <- geoinside(
      tmpdata,
      reg = geo::reg.lump[[i]],
      option = 0,
      robust = FALSE
    )
    if (length(ind) > 0) {
      tmpdata[ind, "area"] <- i
    }
    i <- 2
    j <- tmpdata$area == 0
    j1 <- c(1:length(j))
    j1 <- j1[j == T]
    if (length(j1) > 0) {
      ind <- geoinside(
        tmpdata[j1, ],
        reg = geo::reg.lump[[i]],
        option = 0,
        robust = FALSE
      )
      if (length(ind) > 0) {
        tmpdata[j1[ind], "area"] <- i
      }
    }
    i <- 3
    j <- tmpdata$area == 0
    j1 <- c(1:length(j))
    j1 <- j1[j == T]
    if (length(j1) > 0) {
      ind <- geoinside(
        tmpdata[j1, ],
        reg = geo::reg.lump[[i]],
        option = 0,
        robust = FALSE
      )
      if (length(ind) > 0) {
        tmpdata[j1[ind], "area"] <- i
      }
    }
    i <- 4
    j <- tmpdata$area == 0
    j1 <- c(1:length(j))
    j1 <- j1[j == T]
    if (length(j1) > 0) {
      ind <- geoinside(
        tmpdata[j1, ],
        reg = geo::reg.lump[[i]],
        option = 0,
        robust = FALSE
      )
      if (length(ind) > 0) {
        tmpdata[j1[ind], "area"] <- i
      }
    }
    i <- 5
    j <- tmpdata$area == 0
    j1 <- c(1:length(j))
    j1 <- j1[j == T]
    if (length(j1) > 0) {
      ind <- geoinside(
        tmpdata[j1, ],
        reg = geo::reg.lump[[i]],
        option = 0,
        robust = FALSE
      )
      if (length(ind) > 0) {
        tmpdata[j1[ind], "area"] <- i
      }
    }
    i <- 6
    j <- tmpdata$area == 0
    j1 <- c(1:length(j))
    j1 <- j1[j == T]
    if (length(j1) > 0) {
      ind <- geoinside(
        tmpdata[j1, ],
        reg = geo::reg.lump[[i]],
        option = 0,
        robust = FALSE
      )
      if (length(ind) > 0) {
        tmpdata[j1[ind], "area"] <- i
      }
    }
    i <- 7
    j <- tmpdata$area == 0
    j1 <- c(1:length(j))
    j1 <- j1[j == T]
    if (length(j1) > 0) {
      ind <- geoinside(
        tmpdata[j1, ],
        reg = geo::reg.lump[[i]],
        option = 0,
        robust = FALSE
      )
      if (length(ind) > 0) {
        tmpdata[j1[ind], "area"] <- i
      }
    }
    i <- 8
    j <- tmpdata$area == 0
    j1 <- c(1:length(j))
    j1 <- j1[j == T]
    if (length(j1) > 0) {
      ind <- geoinside(
        tmpdata[j1, ],
        reg = geo::reg.lump[[i]],
        option = 0,
        robust = FALSE
      )
      if (length(ind) > 0) {
        tmpdata[j1[ind], "area"] <- i
      }
    }
    data$area <- tmpdata$area
    return(data)
  }

# ---- cut_box.1.R ----
#' Cut box ?
#'
#' Cut box in connection with overlaying a Lambert projected plot with a grid.
#'
#'
#' @param x,y Longitude and latitude of gridlines
#' @param xb,yb Longitude and latitude limits
#' @return List with compoents: \item{x}{Longitudes??} \item{y}{Latitudes??}
#' \item{ind}{Indices??}
#' @note Internal in \code{gridaxes.Lambert}, needs elaboration.
#' @seealso \code{\link{gridaxes.Lambert}}
#' @keywords manip
#' @export cut_box.1
cut_box.1 <-
  function(x, y, xb, yb) {
    ind <- c(1:length(x))
    ind <- ind[is.na(x)]
    x <- matrix(x, , ind[1], byrow = T)
    y <- matrix(y, , ind[1], byrow = T)
    n <- ind[1] - 1
    t1 <- (yb[1] - y[, 1]) / (y[, n] - y[, 1])
    t2 <- (yb[2] - y[, 1]) / (y[, n] - y[, 1])
    x1 <- y1 <- matrix(NA, nrow(x), 3)
    x1[, 1] <- x[, 1] + t1 * (x[, n] - x[, 1])
    x1[, 2] <- x[, 1] + t2 * (x[, n] - x[, 1])
    y1[, 1] <- y[, 1] + t1 * (y[, n] - y[, 1])
    y1[, 2] <- y[, 1] + t2 * (y[, n] - y[, 1])
    ind2 <- cut(x1[, 1], xb, labels = FALSE) # labels=FALSE R ver.
    ind <- c(1:length(ind2))
    ind2 <- ind[!is.na(ind2)]
    ind <- cut(x1[, 1], c(-9999999, xb), labels = FALSE) # labels=FALSE R ver.
    ind1 <- c(1:length(ind))
    ind1 <- ind1[!is.na(ind) & ind == 1]
    t1 <- (xb[1] - x[ind1, 1]) / (x[ind1, n] - x[ind1, 1])
    x1[ind1, 1] <- x[ind1, 1] + t1 * (x[ind1, n] - x[ind1, 1])
    y1[ind1, 1] <- y[ind1, 1] + t1 * (y[ind1, n] - y[ind1, 1])
    ind1 <- c(1:length(ind))
    ind1 <- ind1[is.na(ind)]
    t1 <- (xb[2] - x[ind1, 1]) / (x[ind1, n] - x[ind1, 1])
    x1[ind1, 1] <- x[ind1, 1] + t1 * (x[ind1, n] - x[ind1, 1])
    y1[ind1, 1] <- y[ind1, 1] + t1 * (y[ind1, n] - y[ind1, 1])
    ind <- cut(x1[, 2], c(-9999999, xb), labels = FALSE) # labels=FALSE R ver.
    ind1 <- c(1:length(ind))
    ind1 <- ind1[ind == 1 | is.na(ind)]
    x1[ind1, ] <- NA
    y1[ind1, ] <- NA
    return(list(x = t(x1), y = t(y1), ind = ind2))
  }

# ---- cut_box.2.R ----
#' Cut box type 2???
#'
#' Cut box type 2???.
#'
#'
#' @param x Longtude ?
#' @param y Latitude ?
#' @param xb Limits of longitude?
#' @param yb Limits of latitude?
#' @return List with components: \item{x, y}{Longitude and latitude of ???}
#' \item{x1, y1}{Some other Longitude and latitude of ???}
#' @note Internal to \code{gridaxes.Lambert}, needs elaboration.
#' @seealso \code{\link{gridaxes.Lambert}}
#' @keywords manip
#' @export cut_box.2
cut_box.2 <-
  function(x, y, xb, yb) {
    ind <- c(1:length(x))
    inds <- ind[is.na(x)]
    ind <- inds
    xx <- matrix(x, , ind[1], byrow = T)
    yy <- matrix(y, , ind[1], byrow = T)
    ind <- cut(x, xb, labels = FALSE) # labels=FALSE R ver.
    ind1 <- ind[2:length(ind)]
    ind <- ind[1:(length(ind) - 1)]
    ii <- c(1:length(ind))
    i <- ifelse(is.na(ind) & !is.na(ind1), ii, NA)
    i <- i[!is.na(i)]
    i1 <- ifelse(!is.na(ind) & is.na(ind1), ii, NA)
    i1 <- i1[!is.na(i1)]
    i2 <- c(1:length(ind))
    i2 <- i2[is.na(ind)]
    x2 <- y2 <- x3 <- y3 <- matrix(NA, nrow(xx), 3)
    x2[, 1] <- x[i]
    x2[, 2] <- x[i + 1]
    y2[, 1] <- y[i]
    y2[, 2] <- y[i + 1]
    x3[, 1] <- x[i1]
    x3[, 2] <- x[i1 + 1]
    y3[, 1] <- y[i1]
    y3[, 2] <- y[i1 + 1]
    t1 <- (xb[1] - x2[, 1]) / (x2[, 2] - x2[, 1])
    t2 <- (xb[2] - x3[, 1]) / (x3[, 2] - x3[, 1])
    x1 <- y1 <- matrix(NA, nrow(xx), 3)
    x1[, 1] <- x2[, 1] + t1 * (x2[, 2] - x2[, 1])
    x1[, 2] <- x3[, 1] + t2 * (x3[, 2] - x3[, 1])
    y1[, 1] <- y2[, 1] + t1 * (y2[, 2] - y2[, 1])
    y1[, 2] <- y3[, 1] + t2 * (y3[, 2] - y3[, 1])
    y[i2] <- NA
    x[i2] <- NA
    x[i] <- x1[, 1]
    y[i] <- y1[, 1]
    x[i1 + 1] <- x1[, 2]
    y[i1 + 1] <- y1[, 2]
    ind <- cut(y, c(-999999, yb, 999999), labels = FALSE) # labels=FALSE R ver.
    ind1 <- c(1:length(ind))
    ind1 <- ind1[ind != 2]
    x[ind1] <- NA
    y[ind1] <- NA
    return(list(x = x, y = y, x1 = c(x1[, 1]), y1 = c(y1[, 1])))
  }

# ---- cut_multipoly.R ----
#' Intersect or take complement (?) of polygons
#'
#' Intersect or take complement (?) of one or many polygons with a single one.
#'
#'
#' @param x Polygon or polygons, seperated with NAs, hence 'multipoly'
#' @param xb Polygon to intersect with/complement from
#' @param in.or.out Whether to take the intersect (0) or complement of x in xb
#' (1). Default 0
#' @return List with compents: \item{x, y}{with coordinates of intersection or
#' complement (?)}
#' @note Check use of \code{in.or.out=1}, when there are many polygons in
#' \code{x}, how is the complement with \code{xb} taken? Needs elaboration.
#' Possibly drop in.or.out from argument list and fix it at 0 in call to
#' findcut.
#' @seealso Called by \code{\link{geopolygon}}, calls \code{\link{findcut}} and
#' \code{\link{prepare.line}}
#' @keywords manip
#' @export cut_multipoly
cut_multipoly <-
  function(x, xb, in.or.out = 0) {
    ind <- x$x[is.na(x$x)]
    if (length(ind) == 0) {
      x2 <- findcut(x, xb, in.or.out)
    } else {
      x2 <- list(x = NA, y = NA)
      ind <- prepare.line(x$x)
      for (i in 1:ind$nlx) {
        x1 <- list(
          x = x$x[ind$lx1[i]:ind$lx2[i]],
          y = x$y[
            ind$lx1[i]:ind$lx2[i]
          ]
        )
        x1 <- findcut(x1, xb, in.or.out)
        x2$x <- c(x2$x, NA, x1$x)
        x2$y <- c(x2$y, NA, x1$y)
      }
      x2$x <- x2$x[-c(1:2)]
      x2$y <- x2$y[-c(1:2)]
    }
    return(x2)
  }

# ---- geochull.R ----
#' Convex hull of a set of positions
#'
#' Finds the convex hull of a set of positions in lat and lon.
#'
#'
#' @param lat,lon Position(s) as decimal degrees latitude and longitude.  If
#' 'lat' is 'list' its components 'lat$lat' and 'lat$lon' are used for 'lat'
#' and 'lon'.
#' @return List with components \code{lat} and \code{lon} of the convex hull of
#' the input.
#' @seealso \code{\link{Proj}}, \code{\link{invProj}},
#' \code{\link[grDevices]{chull}}
#' @keywords manip
#' @examples
#'
#' # draws the convex hull of Iceland's coastline.
#' geoplot()
#' geolines(geochull(island))
#'
#' @export geochull
geochull <-
  function(lat, lon = NULL) {
    if (is.null(lon)) {
      lon <- lat$lon
      lat <- lat$lat
    }
    x <- Proj(lat, lon)$x
    y <- Proj(lat, lon)$y
    id <- chull(x, y)
    id <- c(id, id[1])
    data.frame(invProj(x[id], y[id])[c("lat", "lon")])
  }

# ---- geointersect.R ----
#' Find intersection of 2 polygons
#'
#' Find intersection of 2 polygons
#'
#'
#' @param data Polygon.
#' @param border Polygon to intersect with/complement from.
#' @param in.or.out Whether to take intersect of A and B (0)
#' or complement of A in B (1). Default 0.
#' @seealso \code{\link{findcut}}, \code{\link{invProj}}, \code{\link{Proj}}
#' @keywords logic manip
#' @export geointersect
geointersect <-
  function(data, border, in.or.out) {
    tmp <- invProj(findcut(Proj(data), Proj(border), in.or.out))
    return(data.frame(lat = tmp$lat, lon = tmp$lon))
  }
