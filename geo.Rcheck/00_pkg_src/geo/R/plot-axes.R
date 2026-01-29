# Auto-generated grouping file: plot-axes.R
# Original function definitions were moved here for maintainability.

# ---- geoaxis.R ----
#' Setup axes for a geoplot
#'
#' Set up axes for a geoplot.
#'
#'
#' @param side On which side should the axis be drawn?
#' @param pos Positions of labels (?)
#' @param dist Distance from plot of axes labels (?)
#' @param dlat Latitude resolution of labels (?)
#' @param dlon Longitude resolution of labels (?)
#' @param csi Character size inches, default 0.12
#' @param cex Character size expansion, default 0.7
#' @param inside Whether or not stay inside ??????????
#' @param r yet another setting ?????????
#' @param \dots Additional arguments to \code{geotext}
#' @return Adds labels to a geoplot, no value returned.
#' @note Needs further elaboration.
#' @seealso Calls \code{\link{geotext}}, called by \code{\link{init}}.
#' @keywords aplot
#' @export geoaxis
geoaxis <-
  function(
    side,
    pos,
    dist,
    dlat = 0.5,
    dlon = 1,
    csi = 0.12,
    cex = 0.7,
    inside = T,
    r = 1,
    ...
  ) {
    geopar <- getOption("geopar")
    m <- par()$cex * csi
    if (inside) {
      m <- -m
    }
    if (side == 2 || side == 4) {
      ratio <- diff(geopar$origin$lon) / geopar$gpar$pin[1]
    } else {
      ratio <- diff(geopar$origin$lat) / geopar$gpar$pin[2]
    }
    if (side == 2 || side == 4) {
      if (missing(pos)) {
        pos1 <- (geopar$origin$lat[1] %/% dlat) * dlat - dlat
        pos2 <- (geopar$origin$lat[2] %/% dlat) * dlat + dlat
        pos <- seq(pos1, pos2, by = dlat)
      }
      pos <- pos[pos <= geopar$origin$lat[2] & pos >= geopar$origin$lat[1]]
      if (missing(dist)) {
        if ((side == 4 && inside) || (side == 2 && !inside)) {
          lat1 <- pos %% 1
          lat2 <- lat1 * 60 %% 1
          if (any(lat2)) {
            lm <- 8
          } else if (any(lat1)) {
            lm <- 6
          } else {
            lm <- 4
          }
          dist <- lm * m * 0.6 * r
        } else if ((side == 2 && inside) || (side == 4 && !inside)) {
          dist <- m / 2.5 * r
        }
      }
    } else if (side == 3 || side == 1) {
      if (missing(dist)) {
        dist <- m * r
      }
      if (missing(pos)) {
        pos1 <- (geopar$origin$lon[1] %/% dlon) * dlon - dlon
        pos2 <- (geopar$origin$lon[2] %/% dlon) * dlon + dlon
        pos <- seq(pos1, pos2, by = dlon)
      }
      pos <- pos[pos <= geopar$origin$lon[2] & pos >= geopar$origin$lon[1]]
    }
    if (side == 2 || side == 4) {
      if (side == 2) {
        lonpos <- geopar$origin$lon[1] - ratio * dist
      }
      if (side == 4) {
        lonpos <- geopar$origin$lon[2] + ratio * dist
      }
      lat1 <- trunc(pos)
      lat2 <- pos %% 1
      txt <- paste(lat1, "\u00b0", sep = "")
      lat2 <- round(lat2 * 60, 2)
      i <- lat2 > 0
      if (any(i)) {
        txt[i] <- paste(txt[i], lat2[i], "'", sep = "")
      }
      geotext(
        pos,
        rep(lonpos, length(lat1)),
        adj = 0,
        txt,
        cex = cex,
        outside = T,
        ...
      )
    } else {
      if (side == 1) {
        latpos <- geopar$origin$lat[1] - ratio * dist
      }
      if (side == 3) {
        latpos <- geopar$origin$lat[2] + ratio * dist
      }
      pos1 <- abs(pos)
      lon1 <- trunc(pos1)
      lon2 <- pos1 %% 1
      txt <- paste(lon1, "\u00b0", sep = "")
      lon2 <- round(lon2 * 60, 2)
      i <- lon2 > 0
      if (any(i)) {
        txt[i] <- paste(txt[i], lon2[i], "'", sep = "")
      }
      geotext(
        rep(latpos, length(pos)),
        pos,
        txt,
        adj = 0.5,
        cex = cex,
        outside = T,
        ...
      )
    }
  }

# ---- gridaxes.R ----
#' Set up axes for a geoplot
#'
#' Set up axes for a geoplot.
#'
#'
#' @param limx Longitude limits
#' @param limy Latitude limits
#' @param scale Scale to supply to \code{Proj, invProj}
#' @param b0 Base latitude for the Mercator projection.  Default value is 65
#' (typical for Iceland)
#' @param xyratio Argument that can be used to set the aspect ratio (?)
#' @param grid If grid is TRUE meridians and parallels are plotted, else not.
#' Default TRUE
#' @param col Color of gridlines
#' @param reitur Should the grid show statistical rectangles?
#' @param smareitur Should the grid show statistical sub--rectangles?
#' @param axratio Parameter usually not changed by the user (?)
#' @param axlabels If FALSE no numbers are plotted on the axes. Default TRUE
#' @param b1 Second latitude to define Lambert projection (?, as there's a
#' Lambert version of this function)
#' @param l1 The longitude defining the Lambert projection, default is the
#' \code{l1} defined in geopar, ditto ??
#' @param projection Projection ?, other than Mercator ??)
#' @param dlat Latitude axis increment between labels
#' @param dlon Longitude axis increment between labels
#' @return No value, useful because of its side effect of adding axes to a
#' geoplot.
#' @note May need further elaboration or simplification (referring to the
#' general geoplot help). Coordinate with the geoaxes.Lambert and gridaxes
#' helpfiles (supply as one??). Why are the \code{dlat} and \code{dlim}
#' returned for this one?
#' @seealso Called by \code{\link{init}}, calls \code{\link{invProj}},
#' \code{\link{Proj}}, \code{\link{mercator}} and \code{\link{plot_nogrid}}.
#' @keywords aplot
#' @export gridaxes
gridaxes <-
  function(
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
  ) {
    axlabels = F # added to make geoaxis default in init() for R ver.
    o <- invProj(limx, limy, scale, b0, b1, l1, projection)
    r1 <- (limy[2] - limy[1]) / (limx[2] - limx[1])
    # ratio
    nlon <- 30
    nlat <- round((nlon * r1) / xyratio) * 2
    if (dlat == 0 && dlon == 0) {
      if ((o$lon[2] - o$lon[1]) > 40) {
        dlon <- 10
      }
      if ((o$lon[2] - o$lon[1]) > 1) {
        dlon <- 1 / 3
      }
      if ((o$lon[2] - o$lon[1]) > 3) {
        dlon <- 1 / 2
      }
      if ((o$lon[2] - o$lon[1]) > 6) {
        dlon <- 1
      }
      if ((o$lon[2] - o$lon[1]) > 10) {
        dlon <- 2
      }
      if ((o$lon[2] - o$lon[1]) > 20) {
        dlon <- 4
      }
      if ((o$lon[2] - o$lon[1]) <= 1) {
        dlon <- 1 / 6
      }
      if ((o$lon[2] - o$lon[1]) < 0.4) {
        dlon <- 1 / 12
      }
      if ((o$lon[2] - o$lon[1]) < 0.2) {
        dlon <- 1 / 30
      }
      if ((o$lon[2] - o$lon[1]) < 0.1) {
        dlon <- 1 / 60
      }
      if ((o$lon[2] - o$lon[1]) < 0.05) {
        dlon <- 1 / 120
      }
      dlat <- dlon / 2
      if (reitur) {
        dlon <- 1
        dlat <- 0.5
      }
      if (smareitur) {
        dlon <- 0.5
        dlat <- 0.25
      }
    }
    if (dlat == 0 && dlon != 0) {
      dlat <- dlon / 2
    }
    if (dlat != 0 && dlon == 0) {
      dlon <- dlat * 2
    }
    dlat <- dlat / axratio
    dlon <- dlon / axratio
    olo <- o$lon[1] - ((o$lon[1] / dlon) - floor(o$lon[1] / dlon)) * dlon
    ola <- o$lat[1] - ((o$lat[1] / dlat) - floor(o$lat[1] / dlat)) * dlat
    latgr <- ola + c(0:(nlat * 2)) * dlat
    latgr[latgr > 85] <- 85
    longr <- olo + c(0:(nlon * 2)) * dlon
    latgr <- latgr[(latgr <= o$lat[2]) & (latgr > o$lat[1])]
    #171
    longr <- longr[(longr <= o$lon[2]) & (longr > o$lon[1])]
    latgr2 <- c(o$lat[1], latgr, o$lat[2])
    longr2 <- c(o$lon[1], longr, o$lon[2])
    nlat <- length(latgr2)
    nlon <- length(longr2)
    latgr1 <- matrix(latgr2, nlat, nlon)
    longr1 <- t(matrix(longr2, nlon, nlat))
    # 	plot grid
    plotgr2 <- Proj(latgr1, longr1, scale, b0, b1, l1, projection)
    n <- ncol(plotgr2$x)
    n1 <- c(1:n)
    n1[1:n] <- NA
    # add NA for plot
    plx.lon <- rbind(plotgr2$x, n1)
    ply.lon <- rbind(plotgr2$y, n1)
    par(err = -1)
    if (grid) {
      lines(plx.lon, ply.lon, col = col)
    }
    # plot grid.
    n <- nrow(plotgr2$x)
    n1 <- c(1:n)
    n1[1:n] <- NA
    # add NA for plot
    plx.lat <- rbind(t(plotgr2$x), n1)
    ply.lat <- rbind(t(plotgr2$y), n1)
    par(err = -1)
    if (grid) {
      lines(plx.lat, ply.lat, col = col)
    }
    # plot grid.
    # 	Plot axes
    latcha <- round((abs(latgr) - trunc(abs(latgr))) * 60, digits = 2)
    loncha <- round((abs(longr) - trunc(abs(longr))) * 60, digits = 2)
    indlat <- latcha == 60
    indlon <- loncha == 60
    latchar <- as.character(trunc(abs(latgr)) + indlat)
    lonchar <- as.character(trunc(abs(longr)) + indlon)
    latcha <- as.character(latcha - indlat * 60)
    loncha <- as.character(loncha - indlon * 60)
    latmin <- rep("'", length(latcha))
    lonmin <- rep("'", length(loncha))
    if (floor(dlat) == dlat) {
      ind <- c(1:length(latcha))
      ind <- ind[latcha == "0"]
      latcha[ind] <- " "
      latmin[ind] <- " "
    } else {
      latcha[latcha == "0"] <- "00"
    }
    if (floor(dlon) == dlon) {
      ind <- c(1:length(loncha))
      ind <- ind[loncha == "0"]
      loncha[ind] <- " "
      lonmin[ind] <- " "
    } else {
      loncha[loncha == "0"] <- "00"
    }
    latchar <- paste(latchar, "\u00b0", latcha, latmin, sep = "")
    lonchar <- paste(lonchar, "\u00b0", loncha, lonmin, sep = "")
    latchar <- c(" ", latchar, " ")
    lonchar <- c(" ", lonchar, " ")
    #	vect<-c(1:length(longr2)); vect[1:length(longr2)] <- o$y[1]
    vect <- rep(60, length(longr2))
    # bretting 11-7
    plotgrlon <- Proj(vect, longr2, scale, b0, b1, l1, projection)
    vect <- c(1:length(latgr2))
    vect[1:length(latgr2)] <- o$x[1]
    plotgrlat <- mercator(latgr2, vect, scale, b0)
    par(adj = 0.5)
    if (axlabels) {
      if (grid) {
        # how the axes are plotted.
        axis(1, plotgrlon$x, lonchar, tick = F, col = col) # If grid.
        axis(2, plotgrlat$y, latchar, tick = F, col = col)
      } else {
        axis(1, plotgrlon$x, tick = F, col = col) # If axlabels.
        axis(3, plotgrlon$x, F, tick = F, col = col)
        axis(2, plotgrlat$y, latchar, tick = F, col = col)
        axis(4, plotgrlat$y, F, tick = F, col = col)
        xgr <- Proj(latgr, longr, scale, b0, b1, l1, projection)
        plot_nogrid(o, xgr$x, xgr$y, col)
      }
    }
    # no axlabels
    if (grid) {
      # how the axes are plotted.
      axis(1, plotgrlon$x, F, tick = F, col = col)
      axis(2, plotgrlat$y, F, tick = F, col = col)
    } else {
      xgr <- Proj(latgr, longr, scale, b0, b1, l1, projection)
      plot_nogrid(o, xgr$x, xgr$y, col)
    }

    return(list(dlon = dlon, dlat = dlat))
  }

# ---- gridaxes.Lambert.R ----
#' Set up axes for a Lambert projected geoplot
#'
#' Set up axes for a Lambert projected geoplot.
#'
#'
#' @param limx Longitude limits
#' @param limy Latitude limits
#' @param scale Scale to supply to \code{Proj, invProj}
#' @param b0 Base latitude for the Lambert projection.  Default value is 65
#' (typical for Iceland)
#' @param xyratio Unused argument (?)
#' @param grid If grid is TRUE meridians and parallels are plotted, else not.
#' Default TRUE
#' @param col Color of gridlines
#' @param reitur Should the grid show statistical rectangles?
#' @param smareitur Should the grid show statistical sub--rectangles?
#' @param axratio Parameter usually not changed by the user (?)
#' @param axlabels If FALSE no numbers are plotted on the axes. Default TRUE
#' @param b1 Second latitude to define Lambert projection
#' @param l1 The longitude defining the Lambert projection, default is the
#' \code{l1} defined in geopar
#' @param projection Projection (but is the function meaningful for other than
#' Lambert?)
#' @param dlat Latitude axis increment between labels
#' @param dlon Longitude axis increment between labels
#' @param col1 Color of axes and labels, default 1 (but might be \code{col}
#' @return No value, useful because of its side effect of adding axes to a
#' Lambert geo--plot.
#' @note May need further elaboration or simplification (referring to the
#' general geoplot help). Coordinate with the geoaxes and gridaxes helpfiles
#' (supply as one??).
#' @seealso Called by \code{\link{init}}, calls \code{\link{adjust.grd}},
#' \code{\link{cut_box.1}}, \code{\link{cut_box.2}}, \code{\link{fill.points}},
#' \code{\link{invProj}}, \code{\link{Proj}}.
#' @keywords aplot
#' @export gridaxes.Lambert
gridaxes.Lambert <-
  function(
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
    dlon,
    col1 = 1
  ) {
    lx <- c(limx[1], limx[1], limx[2], mean(limx))
    ly <- c(limy[2], limy[1], limy[2], limy[2])
    o1 <- invProj(lx, ly, scale, b0, b1, l1, projection)
    o <- invProj(limx, limy, scale, b0, b1, l1, projection)
    lines(
      c(o$x[1], o$x[2], o$x[2], o$x[1], o$x[1]),
      c(o$y[1], o$y[1], o$y[2], o$y[2], o$y[1])
    )
    r1 <- (limy[2] - limy[1]) / (limx[2] - limx[1])
    # ratio
    if (dlat == 0 && dlon == 0) {
      if ((o$lon[2] - o$lon[1]) > 1) {
        dlon <- 1 / 3
      }
      if ((o$lon[2] - o$lon[1]) > 3) {
        dlon <- 1 / 2
      }
      if ((o$lon[2] - o$lon[1]) > 6) {
        dlon <- 1
      }
      if ((o$lon[2] - o$lon[1]) > 10) {
        dlon <- 2
      }
      if ((o$lon[2] - o$lon[1]) > 20) {
        dlon <- 4
      }
      if ((o$lon[2] - o$lon[1]) > 40) {
        dlon <- 8
      }
      if ((o$lon[2] - o$lon[1]) <= 1) {
        dlon <- 1 / 6
      }
      if ((o$lon[2] - o$lon[1]) < 0.4) {
        dlon <- 1 / 12
      }
      if ((o$lon[2] - o$lon[1]) < 0.2) {
        dlon <- 1 / 30
      }
      if ((o$lon[2] - o$lon[1]) < 0.1) {
        dlon <- 1 / 60
      }
      if ((o$lon[2] - o$lon[1]) < 0.05) {
        dlon <- 1 / 120
      }
      dlat <- dlon / 2
      if (reitur) {
        dlon <- 1
        dlat <- 0.5
      }
      if (smareitur) {
        dlon <- 0.5
        dlat <- 0.25
      }
    }
    if (dlat == 0 && dlon != 0) {
      dlat <- dlon / 2
    }
    if (dlat != 0 && dlon == 0) {
      dlon <- dlat * 2
    }
    nx <- floor((o$lon[2] - o$lon[1]) * 0.3) + 2
    dlat <- dlat / axratio
    dlon <- dlon / axratio
    nlon <- floor(o1$lon[3] - o1$lon[1]) / dlon + 1
    nlat <- floor(o1$lat[1] - o1$lat[2]) / dlat + 1
    olo <- o1$lon[1] - ((o1$lon[1] / dlon) - floor(o1$lon[1] / dlon)) * dlon
    ola <- o1$lat[2] - ((o1$lat[2] / dlat) - floor(o1$lat[2] / dlat)) * dlat
    latgr <- ola + c(0:(nlat * 2)) * dlat
    latgr <- latgr[latgr < o1$lat[4] + dlat]
    longr <- olo + c(-1:(nlon * 2)) * dlon
    longr <- longr[longr < o1$lon[3] + dlon]
    latgr2 <- latgr
    longr2 <- longr
    nlat <- length(latgr2)
    nlon <- length(longr2)
    latgr1 <- matrix(latgr2, nlat, nlon)
    longr1 <- t(matrix(longr2, nlon, nlat))
    # 	plot grid vertical.
    plotgr2 <- Proj(latgr1, longr1, scale, b0, b1, l1, projection)
    n <- ncol(plotgr2$x)
    n1 <- c(1:n)
    n1[1:n] <- NA
    # add NA for plot
    plx.lon <- rbind(plotgr2$x, n1)
    ply.lon <- rbind(plotgr2$y, n1)
    plx <- cut_box.1(plx.lon, ply.lon, o$x, o$y)
    if (!grid) {
      plx1 <- adjust.grd(plx)
    } else {
      plx1 <- plx
    }
    par(err = -1)
    if (grid) {
      lines(plx1$x, plx1$y, col = col)
    }
    # plot grid.
    #	Horizontal grid
    plx$x <- matrix(plx$x, 3, )
    n <- nrow(latgr1)
    n1 <- c(1:n)
    n1[1:n] <- NA
    # add NA for plot
    pl.lat <- rbind(t(latgr1), n1)
    pl.lon <- rbind(t(longr1), n1)
    x <- fill.points(pl.lon, pl.lat, nx = 10)
    x <- Proj(x$y, x$x, scale, b0, b1, l1, projection)
    ply <- cut_box.2(x$x, x$y, o$x, o$y)
    if (!grid) {
      ply1 <- adjust.grd(ply)
    } else {
      ply1 <- ply
    }
    par(err = -1)
    lines(ply1$x, ply1$y, col = col)
    # plot grid.
    # 	Plot axes
    indx <- c(1:length(latgr))
    indx <- indx[latgr < o1$lat[1] & latgr > o1$lat[2]]
    longr <- longr[plx$ind]
    latcha <- round((abs(latgr) - trunc(abs(latgr))) * 60, digits = 2)
    loncha <- round((abs(longr) - trunc(abs(longr))) * 60, digits = 2)
    ind1 <- c(1:length(latcha))
    ind1 <- ind1[latcha == 0]
    ind2 <- c(1:length(loncha))
    ind2 <- ind2[loncha == 0]
    indlat <- latcha == 60
    indlon <- loncha == 60
    latchar <- as.character(trunc(abs(latgr)) + indlat)
    lonchar <- as.character(trunc(abs(longr)) + indlon)
    latcha <- as.character(latcha - indlat * 60)
    loncha <- as.character(loncha - indlon * 60)
    if (length(ind1) == 0) {
      latchar <- paste(latchar, "\u00b0", latcha, "'", sep = "")
    } else {
      if (floor(dlat) == dlat) {
        latchar[ind1] <- paste(latchar[ind1], "\u00b0")
      } else {
        latchar[ind1] <- paste(latchar[ind1], "\u00b0", "00'", sep = "")
      }
      latchar[-ind1] <- paste(
        latchar[-ind1],
        "\u00b0",
        latcha[-ind1],
        "'",
        sep = ""
      )
    }
    if (length(ind2) == 0) {
      lonchar <- paste(lonchar, "\u00b0", loncha, "'", sep = "")
    } else {
      if (floor(dlon) == dlon) {
        lonchar[ind2] <- paste(lonchar[ind2], "\u00b0")
      } else {
        lonchar[ind2] <- paste(lonchar[ind2], "\u00b0", "00'", sep = "")
      }
      lonchar[-ind2] <- paste(
        lonchar[-ind2],
        "\u00b0",
        loncha[-ind2],
        "'",
        sep = ""
      )
    }
    par(adj = 0.5)
    if (axlabels) {
      # geoaxis(side=2,pos = ply$y1[indx], dis=0.3,inside=F)
      # geoaxis(side=1,pos = plx$x[1, plx$ind],inside=F)
      # print(plx$x[1, plx$ind])
      # print(   ply$y1[indx])
      axis(1, plx$x[1, plx$ind], lonchar, tick = F, col = col1)
      axis(2, ply$y1[indx], latchar[indx], tick = F, col = col1, las = 1) #las R vers.
    }
    return(invisible())
  }

# ---- pltgrid.R ----
#' Plots grid lines
#'
#' Plots grid lines.
#'
#'
#' @param xgrid Should x-grid be drawn, default NULL?
#' @param ygrid Should y-grid be drawn, default NULL?
#' @param xpos xpos ?, if missing taken from \code{par("xaxp")}
#' @param ypos ypos ?, if missing taken from \code{par("yaxp")}
#' @param \dots optional parameters to be sent to \code{lines}
#' @return No value, draws grid lines on current plot.
#' @note Needs elaboration. Prints ypos ??
#' @seealso Neither called by nor calls any function in package geo.
#' @keywords aplot
#' @export pltgrid
pltgrid <-
  function(xgrid = NULL, ygrid = NULL, xpos, ypos, ...) {
    if (!is.null(xgrid)) {
      if (missing(xpos)) {
        xpos <- seq(
          par()$xaxp[1.],
          par()$xaxp[2.],
          length = par()$xaxp[3.] + 1.
        )
      }
      ypos1 <- xpos
      xpos <- matrix(xpos, length(xpos), 3.)
      xpos[, 3.] <- rep(NA, nrow(xpos))
      ypos1 <- xpos
      ypos1[, 1.] <- par()$usr[3.]
      ypos1[, 2.] <- par()$usr[4.]
      lines(t(xpos), t(ypos1), ...)
    }
    if (!is.null(ygrid)) {
      if (missing(ypos)) {
        ypos <- seq(
          par()$yaxp[1.],
          par()$yaxp[2.],
          length = par()$yaxp[3.] + 1.
        )
      }
      print(ypos)
      ypos <- matrix(ypos, length(ypos), 3.)
      ypos[, 3.] <- rep(NA, nrow(ypos))
      xpos <- ypos
      xpos[, 1.] <- par()$usr[2.]
      xpos[, 2.] <- par()$usr[1.]
      lines(t(xpos), t(ypos), ...)
    }
  }

# ---- plot_nogrid.R ----
#' Grid control ?
#'
#' Grid or border control of some sort?
#'
#'
#' @param o o, some outer boundary?
#' @param xgr xgr ?
#' @param ygr ygr ?
#' @param col Color
#' @return No value, some lines added to current geoplot.
#' @note Needs elaboration.
#' @seealso Called by \code{\link{gridaxes}}.
#' @keywords aplot
#' @export plot_nogrid
plot_nogrid <-
  function(o, xgr, ygr, col) {
    frame <- list(
      x = c(o$x[1], o$x[2], o$x[2], o$x[1], o$x[1]),
      y = c(
        o$y[1],
        o$y[1],
        o$y[2],
        o$y[2],
        o$y[1]
      )
    )
    dx <- (o$x[2] - o$x[1]) / 100
    ly <- length(ygr)
    lx <- length(xgr)
    lengd <- ly * 2 + lx * 2
    o1 <- o$x[1]
    ind <- c(1:ly)
    my <- mx <- matrix(NA, lengd, 3)
    mx[ind, 1] <- o1
    mx[ind, 2] <- o1 + dx
    my[ind, 1] <- my[ind, 2] <- ygr
    o1 <- o$x[2]
    ind <- c((ly + 1):(ly * 2))
    mx[ind, 1] <- o1 - dx
    mx[ind, 2] <- o1
    my[ind, 1] <- my[ind, 2] <- ygr
    o1 <- o$y[1]
    ind <- c((ly * 2 + 1):(ly * 2 + lx))
    my[ind, 1] <- o1
    my[ind, 2] <- o1 + dx
    mx[ind, 1] <- mx[ind, 2] <- xgr
    o1 <- o$y[2]
    ind <- c((ly * 2 + lx + 1):(ly * 2 + lx * 2))
    my[ind, 1] <- o1 - dx
    my[ind, 2] <- o1
    mx[ind, 1] <- mx[ind, 2] <- xgr
    lines(t(mx), t(my), col = col)
    lines(frame, col = col)
    return(invisible())
  }
