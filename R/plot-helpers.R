# Auto-generated grouping file: plot-helpers.R
# Original function definitions were moved here for maintainability.

# ---- geosubplot.R ----
#' Adds a plot to an existing plot initialized by geoplot.
#'
#' Adds a plot, of any kind, to the current plot at a location specified by the
#' user.
#'
#' The \pkg{geo} functions rely on the parameters in \code{options("geopar")}
#' for plotting. Every time \code{geoplot} is called a new set of geopar is
#' made and the current erased. If you want to change the parameters in the
#' background plot after you call geosubplot you have to save the current
#' geopar before calling geosubplot. When reassigning geopar, the command
#' \code{options(geopar=list(...))} must be used.
#'
#' When using \code{geosubplot} it is important to save these parameters before
#' the subplot is plotted if one wants to make changes to the large plot
#' afterwards.
#'
#' @param fun a call to the function to be subplotted.  Be sure to call geoplot
#' with new = T.
#' @param pos Position of the plot.  Should include \$lat and \$lon, if
#' length(\$lat) = 1 that point will determine the middle of the subplot, if
#' length(\$lat)=2 the points will determine oppesite corners of the subplots
#' position.
#' @param size The width and the height of the plot if length(pos\$lat)=1.
#' Default is 2,2.
#' @param fill If true the background of the subplot area will be filled.
#' Default is F.
#' @param fillcol fill colour, the colour of the background of the subplot
#' area, default is 0 (usually white)
#' @param \dots The program accepts any parameter that the subplot program will
#' accept.
#' @return none
#' @section Side Effects: A plot added to the current plot.
#' @seealso \code{\link{subplot}}, \code{\link{geoplot}}, \code{\link{geopar}}.
#' @examples
#'
#' \dontrun{
#'       #####################################################
#'       # Example 1                                         #
#'       #####################################################
#'
#'       geoplot()
#'       pos<- list(lat = 63.5,lon=-11.75)
#'       geosubplot(geoplot(faeroes,pch=" ",country =faeroes,new=T)
#'                  ,pos,fill=T)
#'       # Plots the Faeroes on a plot with Iceland. Be sure to
#'       # use new = T if geoplot is called again.
#'
#'       #####################################################
#'       # Example 2                                         #
#'       #####################################################
#'
#'       geoplot()
#'       large.geopar <- geopar             # Parameters saved.
#'       pos <- list(lat=c(63,64),lon=c(-27,-24))
#'       geosubplot(geoplot(island, new=T,grid=F,type="l"),pos)
#'
#'       geotext(65,-18,"subplot")           # Text on subplot.
#'       small.geopar <- geopar # Parameters for subplot saved.
#'
#'       # geopar <- large.geopar       # Make big plot active.
#'       # Unless you are working directly with the .Data dir of the
#'       # geolibrary this assignment will not work, must use:
#'       assign("geopar",large.geopar,where=0)
#'
#'       geotext(65,-18,"Big plot")         # Text on big plot.
#'
#'       # Another subplot.
#'
#'       pos <- list(lat=c(63,64),lon=c(-17,-14))
#'       geosubplot(geoplot(island,new=T,grid=F,type="l"),pos,fill=T)
#'       # Another subplot drawn.
#'       geotext(65,-18,"subplot # 2")
#'
#'       small.geopar.2 <- geopar # parameters for subplot # 2 saved.
#'       # geopar <- large.geopar # Big plot made active again
#'       # Same as above, instead use:
#'       assign("geopar",large.geopar,where=0)
#'
#'       # See also similar example in geopar.
#' }
#' @export geosubplot
geosubplot <-
  function(fun, pos, size = c(2, 2), fill, fillcol, ...) {
    geopar <- getOption("geopar")
    if (length(pos$lat) == 1) {
      # Calculate new limits.
      plt.size <- par()$pin
      rlon <- (diff(geopar$origin$lon) * size[1]) / plt.size[1]
      rlat <- (diff(geopar$origin$lat) * size[2]) / plt.size[2]
      pos <- data.frame(
        lat = pos$lat + c(-0.5, 0.5) * rlat,
        lon = pos$lon + c(-0.5, 0.5) * rlon
      )
    }
    if (!missing(fill)) {
      if (!missing(fillcol)) {
        geopolygon(pos, col = fillcol)
      } else {
        geopolygon(pos, col = 0)
      }
    }
    pos <- Proj(pos)
    oldpar <- selectedpar()
    par(geopar$gpar)
    on.exit(par(oldpar))
    pr <- subplot(fun, pos, ...)
    return(invisible())
  }

# ---- subplot.R ----
#' Add subplot
#'
#' Add subplot.
#'
#'
#' @param fun Graphcical function to call
#' @param x,y Coordinates
#' @param size Subplot size (inches?)
#' @param vadj Vertical adjustment
#' @param hadj Horizontal adjustment
#' @param pars Parameters to set?
#' @return Returns parameter list invisibly, side effect subplot added to
#' current plot.
#' @note Needs elaboration.
#' @seealso Called by \code{\link{geosubplot}}, calls
#' \code{\link{selectedpar}}.
#' @keywords aplot
#' @export subplot
subplot <-
  function(fun, x, y, size = c(1, 1), vadj = 0.5, hadj = 0.5, pars) {
    if (missing(fun)) {
      stop("missing argument \"fun\"")
    }
    if (missing(pars)) {
      # set graphical parameters
      opars <- selectedpar() #(no.readonly = TRUE)
      # save old parameters
      par(err = -1)
      fin <- par()$fin
      # dimensions of figure, inches
      #
      #     mai doesn't deal with pty='s', etc
      #     mai <- par()$mai	# bottom, left, top, right margins, in inches
      pltin <- par("plt") * fin[c(1, 1, 2, 2)]
      mai <- c(
        pltin[3],
        pltin[1],
        fin[2] - pltin[4],
        fin[1] -
          pltin[
            2
          ]
      )
      #
      #
      usr <- par()$usr
      # limits in user units : xmin,xmax,ymin,ymax
      # uin paramter does not exist in R.
      uin <- par()$pin / (c(usr[2] - usr[1], usr[4] - usr[3])) #par()$uin
      # inches per user units , x then y.
      if (missing(x)) {
        if (missing(size)) {
          cat(
            "Using function \"locator(2)\" to place opposite corners of subplot\n"
          )
          x <- locator(2)
        } else {
          cat("Using function \"locator(1)\" to place subplot\n")
          x <- locator(1)
        }
      }
      if (!is.null(x$x) && !is.null(x$y)) {
        y <- x$y
        x <- x$x
      }
      if (length(x) == 2 && length(y) == 2) {
        # then x,y represent corners of plot
        # reparameterize to lower left corner, size
        x <- sort(x)
        y <- sort(y)
        size[1] <- (x[2] - x[1]) * uin[1]
        size[2] <- (y[2] - y[1]) * uin[2]
        x <- x[1]
        y <- y[1]
        hadj <- 0
        vadj <- 0
      }
      if (length(x) != 1 || length(y) != 1) {
        stop("length of x and y must both be same: 1 or 2")
      }
      # convert x, y to inches from edges of plot, xi and yi
      xi <- mai[2] + (x - usr[1]) * uin[1]
      yi <- mai[1] + (y - usr[3]) * uin[2]
      hoff <- size[1] * hadj
      voff <- size[2] * vadj
      newmai <- c(
        yi - voff,
        xi - hoff,
        fin[2] - yi - size[2] + voff,
        fin[1] - xi - size[1] + hoff
      )
      newmex <- sqrt(max(size) / min(fin))
      if (any(newmai < 0)) {
        stop("subplot out of bounds")
      }
      par(pty = "m", mex = newmex, mai = newmai)
    } else {
      opars <- par(pars)
    }
    # don't set new graphical parameters
    opars$new <- F
    #sometimes axes-less image plots will make it stick
    par(new = T)
    # don't erase current plot
    on.exit(par(opars))
    # don't erase current plot
    eval(fun, sys.parent(1))
    invisible(par()[names(opars)])
  }

# ---- geolegend.R ----
#' Put a legend on a plot in the geo series.
#'
#' Adds a legend to current plot.  The location can be specified with lat and
#' lon.  Allows all the same parameters as legend.
#'
#' See legend.
#'
#' @param pos The position of the text, should include lat and lon.  If
#' lat and lon are llength 1, they determine the top left corner of the
#' rectangle; if theey are length 2 vectors, the give opposite corners of the
#' rectangular area.  A list containing x and y values may be supplied.
#' @param legend Vector of character strings to be associated with plot.
#' @param \dots The function allows any optional argument to the legend
#' function to be taken.
#' @return None.
#' @section Side Effects: Draws a box at specified coordinates and puts inside
#' (if possible) examples of lin, points, marks and/or shading, each identified
#' with a user-specified text string.
#' @seealso \code{\link{legend}}.
#' @examples
#'
#'            # The function is currently defined as
#'        function(pos, legend, ...)
#'        {
#'                       oldpar <- par()
#'                       par(geopar$gpar)
#'                       on.exit(par(oldpar))
#'                       xx <- Proj(pos$lat, pos$lon)
#'                       legend(xx$x, xx$y, legend = legend, ...)
#'        }
#'
#' @export geolegend
geolegend <-
  function(pos, legend, ...) {
    geopar <- getOption("geopar")
    oldpar <- selectedpar()
    par(geopar$gpar)
    on.exit(par(oldpar))
    xx <- Proj(pos$lat, pos$lon)
    legend(xx$x, xx$y, legend = legend, ...)
  }

# ---- geozoom.R ----
#' Zoom into plots.
#'
#' Zoom into current geoplot, redraws current geoplot with area defined by
#' user.  The current plot can be restored by using geodezoom.
#'
#'
#' @return none.
#' @section Side Effects: The last call to geoplot is recalled with different
#' borders for x and y.
#' @seealso \code{\link{geoplot}}, \code{\link{geodezoom}}.
#' @examples
#'
#'     geoplot()
#'     geozoom()
#'     # Click with mouse as when placing legend i.e. first place the
#'     # mouse where the upper left corner is supposed to be and click
#'     # once, then move to where the lower right corner is supposed to
#'     # be and also press once.
#'     geodezoom()
#'     # Return to previous plot, here geoplot().
#'
#' @export geozoom
geozoom <-
  function() {
    geopar <- getOption("geopar")
    if (as.character(geopar$command[length(geopar$command)]) != "123") {
      com <- c(geopar$command, zoom = 123)
    } else {
      com <- geopar$command
    }
    eval(com)
  }

# ---- geodezoom.R ----
#' Restores a zoomed plot.
#'
#' Geodezoom restores a plot zoomed with geodezoom.
#'
#'
#' @return none
#' @section Side Effects: The limits of the current plot change back to its
#' original size.
#' @seealso \code{\link{geoplot}}, \code{\link{geozoom}}.
#' @examples
#'
#' ##    See examples in help(geozoom).
#'
#'
#' @export geodezoom
geodezoom <-
  function() {
    geopar <- getOption("geopar")
    if (as.character(geopar$command[length(geopar$command)]) == "123") {
      com <- geopar$command[1:(length(geopar$command) - 1)]
    } else {
      com <- geopar$command
    }
    eval(com)
  }

# ---- geoworld.R ----
#' Plots rough outline of the world.
#'
#' Plots roughly the outlines of those countries which have borders
#' intersecting the current plot initialized by geoplot.  The countries can
#' also be filled.
#'
#'
#' @param regions Allows plotting only a certain part of the world to speed up
#' the function, such as regions = "iceland". Default is plotting what is
#' insidie the map.
#' @param exact Draws a more exact plot.
#' @param boundary If true country boundaries are drawn.  Default is false.
#' @param fill If true countries are filled with a color.  Default is false.
#' @param color Default is 1 (usually black).
#' @param lwd Linewidth, default is 1.
#' @param lty Linetype, default is 1.
#' @param plot If false a plot is not drawn.  Default is true.
#' @param type If lines or points should be potted, see type for geoplot.
#' @param pch The character to be used for plotting, see par.
#' @param database The database the world plot is to be taken from.  Currently
#' there are two possible databases world and worldHires.  world is in the map
#' library and worlHires in the mapdata library and is much more precies.
#' @param return.data If true those points used to make the in the plot are
#' return, default is FALSE. Can be used to save the coastlines of specified
#' countries.
#' @param outside If TRUE data are plotted outside the borders.  Default is
#' FALSE.
#' @param allowed.size Maximum size of polygon that can be filled.  Default is
#' 80 000 which is rather large polygon but this value is rapidly changing by
#' more powerful hardware.
#' @return default none, see option return data.
#' @section Side Effects: the outlines of all countries who intersect current
#' plot are drawn.
#' @seealso \code{\link{geoplot}}, \code{\link{fill.outside.border}},
#' \code{\link{geopolygon}}, \code{\link{par}}.
#' @examples
#'
#'    geoplot(xlim = c(0, -53), ylim = c(53, 75))
#'      geoworld()
#'
#'      # Should plot in all countries who intersect the plot draw
#'      # with geoplot.
#'
#' # The packages maps and mapdata need to be installed
#' # worldHires is a very detailed database of coastlines from the
#' # package mapdata.  Could be problematic if used with fill = TRUE)
#' # Allowed.size is the maximum allowed size of polygons.
#' library(maps) # world coastlines and programs
#' library(mapdata) # more detailed coastlines
#' geoplot(xlim = c(20, 70), ylim = c(15, 34))
#' geoworld(database = "worldHires", fill = TRUE, col = 30, allowed.size = 1e5)
#'
#' geoplot(xlim = c(20, 70), ylim = c(15, 34), dlat = 10, dlon = 10)
#' geoworld(database = "world", fill = TRUE, col = 30) #
#'
#' geoplot(xlim = c(-10, 70), ylim = c(71, 81), b0 = 80,
#'   dlat = 2, dlon = 10) # 0 must be high here else
#' geoworld(database = "world", fill = TRUE, col = 30) #the plot fails.
#'
#' # Lambert projection,
#' geoplot(xlim = c(-10, 70), ylim = c(71, 81),
#'   dlat = 2, dlon = 10, projection = "Lambert")
#' geoworld(database = "world", fill = TRUE, col = 30)
#'
#' @export geoworld
geoworld <-
  function(
    regions = ".",
    exact = FALSE,
    boundary = TRUE,
    fill = FALSE,
    color = 1,
    lwd = 1,
    lty = 1,
    plot = TRUE,
    type = "l",
    pch = ".",
    database = "world",
    return.data = FALSE,
    outside = FALSE,
    allowed.size = 80000
  ) {
    geopar <- getOption("geopar")
    resolution <- 0 #1
    interior <- FALSE
    r <- 1.2
    doproj <- FALSE
    if (fill) {
      interior <- TRUE
    }
    if (geopar$projection == "Lambert") {
      # complicated borders in lat, lon
      p1 <- list(
        x = c(
          geopar$limx[1],
          mean(geopar$limx),
          geopar$limx[
            1
          ],
          geopar$limx[2]
        ),
        y = c(
          geopar$limy[1],
          geopar$limy[
            2
          ],
          geopar$limy[2],
          geopar$limy[2]
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
    }
    xlim <- mean(xlim) + r * (xlim - mean(xlim)) # add
    ylim <- mean(ylim) + r * (ylim - mean(ylim)) # to get everything
    # parameter checks
    # turn the region names into a list of polygon numbers

    coord <- maps::map(
      database,
      regions,
      exact,
      plot = FALSE,
      xlim = xlim,
      ylim = ylim,
      fill = fill
    )

    if (doproj) {
      coord <- Proj(
        coord$y,
        coord$x,
        geopar$scale,
        geopar$b0,
        geopar$b1,
        geopar$l1,
        geopar$projection
      )
      coord$error <- FALSE
    }

    if (return.data) {
      return(data.frame(lat = coord$y, lon = coord$x))
    }
    # do the plotting, if requested
    data <- data.frame(lat = coord$y, lon = coord$x)
    if (plot) {
      if (fill) {
        geopolygon(data, col = color, allowed.size = allowed.size)
      }
      if (!fill) geolines(data, col = color, lwd = lwd, lty = lty)
    }
    return(invisible())
  }

# ---- Arrow.R ----
#' Add arrow to plot.
#'
#' Adds arrow to a plot, given base and point position along with half angle.
#'
#'
#' @param pos List with components \code{lat, lon} of length 2 or more (only
#' first two used).
#' @param angle Angle (< 90) determining arrow sharpness
#' @param col Arrow color, defaults to color 2 of palette in effect.
#' @return Mostly used for plotting, but the function returns the arrow polygon
#' invisibly.
#' @seealso \code{\link{geopolygon}}, \code{\link{invProj}}
#' @keywords aplot
#' @examples
#'
#' geoplot()
#' Arrow(list(lat=c(65,65.5),lon=c(-19, -18)),angle=60,col="brown")
#' Arrow(list(lat=c(65,65.5),lon=c(-19, -18)),angle=45,col="red")
#' Arrow(list(lat=c(65,65.5),lon=c(-19, -18)),angle=30,col="green")
#' Arrow(list(lat=c(65,65.5),lon=c(-19, -18)),angle=30,col="blue")
#'
#' @export Arrow
Arrow <-
  function(pos, angle = 15, col = 2) {
    pos <- Proj(pos)
    dx <- -diff(pos$x)
    dy <- -diff(pos$y)
    d <- sqrt(dy * dy + dx * dx)
    d1 <- d * tan((angle * pi) / 180)
    p1y <- pos$y[1] + d1 / d * dx
    p1x <- pos$x[1] - d1 / d * dy
    p2y <- pos$y[1] - d1 / d * dx
    p2x <- pos$x[1] + d1 / d * dy
    d <- data.frame(
      y = c(pos$y[2], p1y, p2y, pos$y[2]),
      x = c(pos$x[2], p1x, p2x, pos$x[2])
    )
    d <- invProj(d)
    geopolygon(d, col = col)
    return(invisible(data.frame(lat = d$lat, lon = d$lon)))
  }

# ---- SegmentWithArrow.R ----
#' Plot line segment with arrow at the end.
#'
#' Plot line segment with arrow at the end.
#'
#'
#' @param pos Segment positions.
#' @param angle (Half-)Angle (< 90) determining arrow sharpness.
#' @param size Size of arrow.
#' @param col Color of arrow.
#' @param lwd Line width of segment.
#' @note Needs further checking and elaboration.
#' @keywords aplot
#' @export SegmentWithArrow
SegmentWithArrow <-
  function(pos, angle = 15, size = 0.2, col = "blue", lwd = 2) {
    geopar <- getOption("geopar")
    plt.size <- geopar$gpar$pin
    dist <- arcdist(
      pos$lat[1],
      pos$lon[1],
      pos$lat[2],
      pos$lon[2],
      scale = "nmi"
    )
    arrowsize <- diff(geopar$origin$lat) * size / geopar$gpar$pin[2] * 60
    rat <- min(c(arrowsize / dist, 0.5))
    tmp <- pos
    tmp[1, ] <- tmp[2, ] + rat * (tmp[1, ] - tmp[2, ])
    tmp <- Proj(tmp)
    dx <- diff(tmp$x)
    dy <- diff(tmp$y)
    rat <- tan(angle * pi / 180)
    tmp1 <- data.frame(x = tmp$x[c(1, 2, 1)], y = tmp$y[c(1, 2, 1)])
    tmp1$y[1] <- tmp1$y[1] - rat * dx
    tmp1$x[1] <- tmp1$x[1] + rat * dy
    tmp1$y[3] <- tmp1$y[3] + rat * dx
    tmp1$x[3] <- tmp1$x[3] - rat * dy
    tmp1 <- invProj(tmp1)
    if (lwd > 0) {
      geolines(pos, col = col, lwd = lwd)
    }
    geopolygon(tmp1, col = col)
  }

# ---- Open.curve.R ----
#' Open smooth curve through positions
#'
#' A smooth curve is fitted to the positions with natural spline as implemented
#' in function \code{ns}.
#'
#'
#' @param gogn Data frame of positions to be smoothed
#' @param df Degrees of freedom
#' @param n Number of points returned per data point
#' @return Data frame of positions with components \item{lat, lon}{in decimal
#' degrees}
#' @note Function \code{ns} is missing, assume it is some sort of natural
#' spline.
#' @keywords manip
#' @export Open.curve
Open.curve <-
  function(gogn, df = nrow(gogn) / 2, n = 10) {
    gogn$index <- c(1:nrow(gogn))
    df <- round(df)
    x <- glm(lat ~ ns(index, df = df), data = gogn)
    y <- glm(lon ~ ns(index, df = df), data = gogn)
    r <- range(gogn$index)
    pred.frame <- data.frame(
      index = seq(
        r[1],
        r[2],
        length = nrow(gogn) *
          n
      )
    )
    pred.frame$lat <- predict(x, pred.frame)
    pred.frame$lon <- predict(y, pred.frame)
    pred.frame <- pred.frame[, c("lat", "lon")]
    return(pred.frame)
  }

# ---- Closed.curve.R ----
#' Closed smooth curve through positions
#'
#' A smooth curve is fitted to the positions with periodic spline as
#' implemented in function \code{ps}.
#'
#'
#' @param gogn Data frame of positions to be smoothed
#' @param df Degrees of freedom
#' @param n Number of points returned per data point
#' @return Data frame of positions with components \item{lat, lon }{in decimal
#' degrees}
#' @note Missing function \code{spline.des} is required for \code{\link{ps}} to
#' work.
#' @seealso \code{\link{ps}}
#' @keywords manip
#' @export Closed.curve
Closed.curve <-
  function(gogn, df = round(nrow(gogn) / 2), n = 10) {
    gogn$index <- c(1:nrow(gogn))
    tmpper <- c(1, nrow(gogn))
    x <- glm(lat ~ ps(index, df = df, period = tmpper), data = gogn)
    y <- glm(lon ~ ps(index, df = df, period = tmpper), data = gogn)
    r <- range(gogn$index)
    pred.frame <- data.frame(index = seq(r[1], r[2], length = nrow(gogn) * n))
    pred.frame$lat <- predict(x, pred.frame)
    pred.frame$lon <- predict(y, pred.frame)
    pred.frame[, c("lat", "lon")]
  }

# ---- currentarrows.R ----
#' Plot arrows and segments showing the size and direction of currents.
#'
#' Plot arrows and segments showing the size and direction of currents.
#'
#'
#' @param data Data in a list with components \code{lat} and \code{lon} with
#' decimal degrees, and \code{current} with the current magnitude.
#' @param maxsize Maximum current segment size.
#' @param maxn Current given with \code{maxsize}, defaults to
#' \code{max(data$current)}.
#' @param col Color of current arrows and segments.
#' @param lwd Line width of the segments showing current.
#' @param arrowsize Arrow size.
#' @param center Whether or not to center the arrow, defaults to \code{TRUE}.
#' @note Needs further checking and elaboration.
#' @keywords aplot
#' @export currentarrows
currentarrows <-
  function(
    data,
    maxsize = 0.5,
    maxn,
    col = "blue",
    lwd = 2,
    arrowsize = 0.2,
    center = T
  ) {
    geopar <- getOption("geopar")
    res <- list()
    xsizerat <- geopar$gpar$pin[1] / diff(geopar$origin$lon)
    ysizerat <- geopar$gpar$pin[2] / diff(geopar$origin$lat)
    data$rat <- cos(data$lat * pi / 180)
    if (missing(maxn)) {
      maxn <- max(data$current)
    }

    tmp <- data.frame(lat = c(1, 1), lon = c(1, 1))
    for (i in 1:nrow(data)) {
      tmp[1, ] <- data[i, c("lat", "lon")]
      tmp[2, "lon"] <- tmp[1, "lon"] +
        maxsize *
          data$current[i] /
          maxn *
          cos(data$angle[i] * pi / 180) /
          data$rat[i] /
          ysizerat
      tmp[2, "lat"] <- tmp[1, "lat"] +
        maxsize *
          data$current[i] /
          maxn *
          sin(data$angle[i] * pi / 180) /
          ysizerat
      if (center) {
        #center the arrow, else start
        dlat <- diff(tmp$lat)
        dlon <- diff(tmp$lon)
        tmp$lat <- tmp$lat - dlat / 2
        tmp$lon <- tmp$lon - dlon / 2
      }
      res[[i]] <- tmp
      SegmentWithArrow(tmp, lwd = lwd, size = arrowsize, col = col)
    }
    return(invisible(res))
  }
