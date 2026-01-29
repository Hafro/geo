# Auto-generated grouping file: plot-core.R
# Original function definitions were moved here for maintainability.

# ---- geoplot.R ----
#' Plots lat and lon coordinates using Mercator or Lambert transformation.
#'
#' Creates a plot of given data, as the "plot" function but allows input data
#' to have latitude and longitude coordinates.Coordinates are latitude and
#' longitude in degrees (default) or x, y in m (or other units).
#'
#' The program performs the Mercator(default) or Lambert transformation of the
#' data in degrees and plots it. The plot is scaled such that 1cm in vertical
#' and horizontal directions correspond to the same distance. The program is
#' used to initialize drawings to be used by programs, i.e. geolines,
#' geopolygon, geopoints, geotext, geosymbol, geogrid, geocontour.fill,
#' geoimage and geocontour. The inputs to the program are decimal numbers
#' negative for western longitudes e.g.lat = 65.75 lon = -25.8. Whether the
#' program interprets data as lat, lon or x, y depends on the parameter
#' projection. If projection is "none" data is interpreted as x, y else lat,
#' lon. When the data is interpreted as x, y lists are assumed to have the
#' components x and y, else lat and lon.Geoplot is often used with type
#' = "n" so the datapoints used to set up the drawing are not seen. Calling
#' geoplot with plotit = FALSE sets up the drawing without putting anything on
#' the screen ( or page).
#'
#'
#' @param lat,lon Latitude and longitude of data (or x and y coordinates),
#' negative for southern latitudes and western longitudes. May be supplied as
#' two vectors or as a list or dataframe lat (or x) including vectors latlat
#' and latlon (xx and xy if projection = none). If xlim and ylim are
#' given the arguments lat and lon are not required.
#' @param type Options are the same as in the plot function i.e "l" for lines,
#' "n" for not plotting the data, "p" for points etc. Default value is "p"
#' @param pch Type of symbol drawn in points. Default is "*". Any other
#' character or symbol can be used, seet the help on points.
#' @param xlim x limits of drawing (longitudinal direction). If not given the
#' program finds the limits as the range of the data times the parameter r
#' (1.05 default).  xlim can be a list (dataframe) with components lat and lon
#' (x and y if projection = "none").
#' @param ylim y limits of drawing (latitudinal direction). If not given and
#' xlim is not a list the program finds the ulimits as the range of the data
#' times the parameter r (1.05).
#' @param b0 Base latitude for the Mercator or Lambert transform.  Default
#' value is 65 (typical for Iceland).  If Mercator transform is used values
#' close to the mean of the data are recommended except the data extend very
#' far north, (> 75 th degree) then b0 should be close to the northern limits
#' of the data).
#' @param r Size of area which is plotted. r = 1.0 means exactly the range of
#' the datapoints, but r = 1.5 means that the range is 1.5 times the range of
#' data. Default value is 1.05. Does not matter if xlim and ylim are given.
#' @param country Country that is plotted.  Options are: \verb{ 1. island 1300
#' points (iceland) 2. bisland 20000 points (iceland fine) 3. greenland 62000
#' points 4. faeroes 2100 points 5. eyjar 2200 points(islands around iceland)
#' 6. none no country plotted } Which map is used depends on the size of the
#' area plotted. If small part of the coast is seen bisland is used, else
#' Iceland. Isands can be added later by geolines(eyjar). Default is set by a
#' variable with the name COUNTRY.DEFAULT.  COUNTRY.DEFAULT <- "island" makes
#' iceland the default country.  The program geoworld can be used to add all
#' coastlines that intersect the map and also to make new countries (see
#' geoworld).
#' @param xlab X-label. Default value is " "
#' @param ylab Y-label. Default value is " "
#' @param option Can be either "cut" or "nocut". If "nocut" the plot always
#' fills the plotted area but if "cut" the plot does not fill it in the
#' direction where the range of data is minimum. It has to be kept in mind that
#' the program always keeps the same scale vertically and horizontally. Default
#' value is "cut". Not effective when contourplots are plotted.
#' @param grid If grid is TRUE meridians and paralells are plotted, else not.
#' Default value is TRUE.
#' @param new If new is FALSE the plot is added to the current plot otherwise a
#' new plot is made. Default value is FALSE. Similar to the Splus command
#' "par(new = TRUE)".
#' @param cont A parameter to reserve space for legend for contours besides the
#' plot. Default value is "FALSE".  Rarely used at the legends are usually put
#' somewhere in the graph.
#' @param cex Relative size of character and symbols (see the help on the
#' parameter cex).  The size of plotted characeters is cex time the parameter
#' csi that can be seen by par()csi.  In earlier versions of geoplot the
#' parameter csi was set but csi is a parameter that can not be set in R.
#' @param col The color number used to for the plot. Default value is 1 that is
#' usually black.
#' @param lcont Limits of area preserved for lables and contour plot as ration
#' of plotting area. Default value is c(0.13, 0.21). That means that the labels
#' take 13\% of the plotting area but the figure 79\%. (Labels to left, figure
#' to left.) 0.08 to 0.1 is a reasonable difference. Only used when cont = TRUE
#' which is seldom used as described erlier.
#' @param plotit If FALSE plot is only initialized but not plotted. If used
#' other programs are used to fill the plot (geolines, geocontour, geopolygon
#' etc). Most often used in multiple plots.
#'
#' Used in connection with geocontour.fill to fewer files but the plot command
#' is given again with new = TRUE when geocontour.fill is called. Plot = FALSE
#' does not work if axeslabels = FALSE. Something seems to have to be on the
#' graph for proper setup.
#' @param reitur Reitur means statistical square in Icelandic.  If true the
#' division of the axes is idendical to the distribution of the ocean around
#' Iceland in statistical squares. Means dlat = 0.5;dlon = 1.
#' @param smareitur If true the division of the axes is idendical to the
#' distribution of the ocean around Iceland in subsquares.dlat = 0.25;dlon =
#' 0.5
#' @param reittext If true the number of each square is written in the center
#' of the square. Only meaningful for Icelandic waters.
#' @param cexrt Relative size of reittext text in statistical squares
#' (cexrt*csi). Default value is 0.7.
#' @param axratio Parameter usually not changed by the user.
#' @param lwd Line width for plot (grid and axes). Default value is the value
#' set when the program was called.(usually 1). Higher values correspond to
#' wider lines.
#' @param lwd1 Line width for plot country. Default value is the value set when
#' the program was called (usually 1). Higher values correspond to wider lines.
#' @param locator Some kind of a simple zoom command. If locator is TRUE the
#' user points with the mouse on the limits of the plot he wants to make. Needs
#' a plot made by geoplot on the screen. Same as if zoom is used.
#' @param axlabels If FALSE no numbers are plotted on the axes. Default value
#' is TRUE.
#' @param projection Projection used to make the plot. Options are "Mercator",
#' "none" and "Lambert". Default value is "Mercator". If projection = "none"
#' data is assumed to be x, y.
#' @param b1 Second latitude to define Lambert projection.
#' @param dlat Defines the grid, to make a grid on the lat axis, 1 is a number
#' on axis and a line at every deg. Not usualy set by user.
#' @param dlon Same as dlat, but for lon.
#' @param jitter useful if many datapoints have the same coordinates, points
#' are jittered randomly to make common values look bigger. jitter = 0.016 is
#' often about right but you may want to have jitter smaller or bigger varying
#' on plot.
#' @param zoom If TRUE the mouse is used to point to two points on the current
#' map with those two new points becoming the new corner points on a new map.
#' . Same as the parameter locator in older geoplot versions.
#' @param csi Size of character.  This parameter can not be set in R but for
#' compatibility with old Splus scripts the parameter cex is readjusted by cex
#' = cex*csi/0.12.  Use of this parameter is not recommended.  Default value is
#' NULL i.e not used.
#' @param csirt Size of reittext. Default value is 0.1. Only for compatibility
#' with older Splus programs but cexrt should be used as the parameter csi can
#' not be set in R:
#' @param xaxdist Distance from plot to the labels on the xaxis (dist or r
#' argument to geoaxis.  Default value is 0.2 but higher value mean that
#' axlabels is further away from the plot.  Further flexibility with axes can
#' be reached by calling geoplot with axlabels = FALSE and geoaxis aferwards.
#' @param yaxdist Distance from plot to the labels on the yaxis (dist or r
#' argument to geoaxis.  Default value is 0.3 but higher value mean that
#' axlabels is further away from the plot.
#' @return No values are returned. The graphical setup is stored in a global
#' list called geopar. That list is accessed by other program that use the same
#' setup.
#' @section Side Effects: There should be no side effects. The program changes
#' a number of graphical parameters but the old parameters are restored before.
#' @seealso \code{\link{geolines}}, \code{\link{geopolygon}},
#' \code{\link{geotext}}, \code{\link{geosymbols}}, \code{\link{geogrid}},
#' \code{\link{geopar}}, \code{\link{geocontour.fill}},
#' \code{\link{geolocator}}, \code{\link{geocontour}},
#' \code{\link{reitaplott}}, \code{\link{geodefine}}, \code{\link{Proj}}.
#' @examples
#'
#' \dontrun{Examples shown here below also include calls to the other functions
#' in the geopackage.  Further explanations of these functions can be
#' found in the appropriate help files.
#'
#' Contour plot of haddock catch in icelandic waters based on logbooks.
#' A color scheme
#' where color 0 is white, 1 black and 2-150 gradually changing from
#' white to black is used.  The data is for 6 years and is stored in a
#' list hadcatch with 6 components.  Circles showing haddock catch in
#' the Icelandic groundfish survey is added on top of the plot with the
#' function geosymbols but utbrteg is a dataframe with information on all
#' catch in the Icelandic groundfish survey (all names in Icelandic ysa
#' means haddock and ar year).  The function bwps is a call to the
#' postscript function with the indicated color scheme.  Designed for
#' Splus and has to be changed for R as the color schemes there are quite
#' different.  This applies to all the examples below.
#'
#' lev <- c(0.5, 1, 2, 4, 6)
#' col <- c(0, 30, 50, 70, 90, 150)
#' txt <- c(1993, 1995, 2000, 2002, 2005, 2006)
#' par(mfrow = c(3, 2));par(mex = 0.01)
#' bwps(file = "hadcatchutbr.ps", height = 6.8, width = 6.5, horizontal = FALSE)
#' for(i in 1:6) {
#'  SMB.std.background(grid = FALSE, axlabels = FALSE)
#'  geocontour.fill(hadcatch[[i]], levels = lev, col = col,
#'     white = TRUE, working.space = 2e6)
#'  gbplot(200)
#'  geotext(67.3, -27.6, txt[i], csi = 0.16, adj = 0)
#'  geopolygon(island, col = 0);geolines(island)
#'  tmp <- utbrteg[utbrteg$ar == txt[i], ] # select the year
#'  geosymbols(tmp, z = tmp$ysa.kg, circles = 0.2,
#'     sqrt = TRUE, lwd = 1)# amount of haddock
#'  geopoints(tmp, pch = 16, csi = 0.05)
#' }
#' dev.off()
#'
#' # plot x, y data
#' geoplot(x$x, x$y, projection = "none", type = "n")
#'
#' geoplot(x, projection = "none", type = "n")
#' # does the same thing.
#'
#' # The packages maps and mapdata need to be installed
#' # worldHires is a very detailed database of coastlines from the
#' # package mapdata.  Could be problematic if used with fill = TRUE)
#' # Allowed.size is the maximum allowed size of polygons.
#' library(map) # world coastlines and programs
#' library(mapdata) # more detailed coastlines
#' geoplot(xlim = c(20, 70), ylim = c(15, 34))
#' geoworld(database = "worldHires", fill = TRUE, col = 30, allowed.size = 30000)
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
#' # Lambert projection, get the axis closer with the mgp command
#' par(mgp = c(2, 0, 0))
#' geoplot(xlim = c(-10, 70), ylim = c(71, 81),
#'   dlat = 2, dlon = 10, projection = "Lambert", cex = 1.1)
#' geoworld(database = "world", fill = TRUE, col = 30)
#'
#' # Example with capelin data.  (lodna meanns capelin).  lodna.2 is a
#' # data.frame with components lat,  lon and z.
#' geoplot(lodna.2, type = "l")
#' geopoints(lodna.2)
#' geosymbols(lodna.2, z = lodna.2$z, colplot = TRUE,
#'   parbars = 0.05, levels = vor.levels, label.location = labloc)
#'
#'
#' geoplot(lodna.2, type = "l")
#'  geosymbols(lodna.2, z = lodna.2$z, perbars = 0.1)
#'
#' geoplot(lodna.2, type = "l")
#'  geosymbols(lodna.2, z = log(1+lodna.2$z), perbars = 0.1)
#'
#'
#' limits <- list(lat = c(63, 68), lon = c(-30, -10))
#' geoplot(xlim = limits, type = "n", grid = FALSE, axlabels = TRUE, plot = FALSE)
#' tmp <- geoexpand(lodna.2.grd) # expand the grid
#' # has defined ther area vor.area and data outside it are set  to NA.
#' i <- geoinside(tmp, vor.area.new, option = 0)
#' zgr <- z.lodna.2;zgr[-i] <- NA
#' geocontour.fill(lodna.2.grd, z = zgr, white = TRUE,
#'   label.location = labloc, levels = vor.levels)
#' geoplot(xlim = limits, type = "n", grid = FALSE, axlabels = TRUE, new = TRUE)
#' #geolines(lodna.2, lwd = 1)
#' gbplot(c(200, 500)) # Depth contours.
#'
#' # make a plot of number within a square, calculate the total number of
#' #cod (torskur) within a square (reitur) and put the text number of
#' #square and total number of cod in the center of the square (number of
#' #cod below number of square).  Apply.shrink is similar to tapply
#' #returning the data in different form and is included with the geo library
#'
#' geoplot(island, r = 1.2, type = "n", reitur = TRUE)
#' x <- apply.shrink(data$torskur.stk, data$reitur, sum,
#'   names = c("reitur", "torskur.stk"))
#' x1 <- r2d(x$reitur)
#' geotext(x1, z = paste(x$reitur, round(x$torskur.stk, 1), sep = "\n"))
#'
#' # Plot filled circles.  The color scheme used is the same as described
#' # color 0 white, 1 black and 2 - 155 white-black see bwps
#' # in geosymbols the argument color means size (in inches)
#' # when the fill.circles = TRUE.  The data used  AfliBySquareMonthYear have
#' # the columns year, month , square and catch.
#' # the function r2d changes square (reitur in Icelandic) to position
#' # Text is put in the middle of the circles where catch exceeds 1000
#' # tonnes.
#'
#' my.colors = c(0.004, 0.04, 0.1, 0.15, 0.20, .25, 100)
#' lev <- c(0.2, 2, 7.5, 10, 20, 50)
#'
#' yy <- c(1932:1939)
#' tmp4 <- AfliBySquareMonthYear
#' tmp4$catch <- tmp4$catch/1000
#' for (ar in yy) {
#'   bwps(file = paste(ar, ".ps", sep = ""))
#'   par(omi = c(0, 0, 0, 2))
#'   par(mfrow = c(4, 3))
#'   par(mex = 0.01)
#'
#'   for(man in 1:12){
#'     tmp1 <- tmp4[tmp4$year == ar & tmp4$month == man, ]
#'     SMB.std.background(axlabels = FALSE, country = "none", plotit = FALSE)
#'     if(nrow(tmp1) > 0) {
#'       tmp2 <- apply.shrink(tmp1$catch, tmp1$square, sum,
#'         names = c("square", "catch"))
#'       tmp2 <- tmp2[order(-tmp2$catch), ]
#'
#'       tmp3 <- data.frame(r2d(tmp2$square))
#'       geosymbols(tmp3, z = tmp2$catch, fill.circles = TRUE, col = 60,
#'         levels = lev, colors = my.colors, bordercol = 0, border = TRUE)
#'       geopolygon(island, col = 30)
#'       geolines(eyjar, lwd = 3, col = 30)
#'       j <- tmp2$catch > 1
#'       if(any(j)) {
#'         tmp3 <- tmp3[j, ]
#'         tmp2 <- tmp2[j, ]
#'         geotext(lat = tmp3$lat, lon = tmp3$lon, z = tmp2$catch,
#'           angle = 45, csi = 0.1)
#'       }
#'       geotext(lat = c(65.2), lon = (-18), z = paste(month.abb[man],
#'         round(sum(tmp2$catch, na.rm = TRUE)), sep = "\n"), csi = 0.2)
#'     }
#'     else {geotext(lat = c(65.2), lon = (-18),
#'             z = paste(month.abb[man], "0", sep = "\n"), csi = 0.2)}
#'   }
#'   geotext(63, -10, ar, adj = 1, csi = 0.18)
#'   dev.off()
#' }
#' }
#' @export geoplot
geoplot <-
  function(
    lat = NULL,
    lon = 0,
    type = "p",
    pch = "*",
    xlim = c(0, 0),
    ylim = c(0, 0),
    b0 = 65,
    r = 1.05,
    country = "default",
    xlab = " ",
    ylab = " ",
    option = "cut",
    grid = TRUE,
    new = FALSE,
    cont = FALSE,
    cex = 0.9,
    col = 1,
    lcont = c(0.13, 0.21),
    plotit = TRUE,
    reitur = FALSE,
    smareitur = FALSE,
    reittext = FALSE,
    cexrt = 0.7,
    csirt = NULL,
    axratio = 1,
    lwd = 0,
    lwd1 = 0,
    locator = FALSE,
    axlabels = TRUE,
    projection = "Mercator",
    b1 = b0,
    dlat = 0,
    dlon = 0,
    jitter = 0,
    zoom,
    csi = NULL,
    xaxdist = 0.2,
    yaxdist = 0.3
  ) {
    geopar <- getOption("geopar")
    if (!is.null(csirt)) {
      cexrt <- cexrt * csirt / 0.12
    }
    if (!is.null(csi)) {
      cex <- cex * csi / 0.12
    }
    if (!plotit) {
      axlabels <- FALSE
    } # not plot axes if ther is no plot.
    if (!missing(zoom)) {
      xlim <- geolocator(n = 2)
    }
    oldpar.1 <- par(no.readonly = TRUE)
    # first version of old parameters
    command <- sys.call()
    if (
      (oldpar.1$fig[2] - oldpar.1$fig[1]) <= 0.6 ||
        (oldpar.1$fig[4] -
          oldpar.1$fig[3]) <=
          0.6
    ) {
      multfig <- TRUE
    } else {
      multfig <- FALSE
    }
    if (projection == "none") {
      if (is.list(xlim) && any(!is.na(match(c("x", "y"), names(xlim))))) {
        ylim <- xlim$y
        xlim <- xlim$x
      }
    } else {
      if (is.list(xlim) && any(!is.na(match(c("lat", "lon"), names(xlim))))) {
        ylim <- xlim$lat
        xlim <- xlim$lon
      }
    }
    if (is.null(lat) && xlim[2] == xlim[1] && ylim[2] == ylim[1] && !locator) {
      #std plot
      if (!multfig) {
        par(fig = geo::geopar.std$fig)
      }
      if (!multfig) {
        par(plt = geo::geopar.std$plt)
      }
      xlim <- geo::geopar.std$xlim
      ylim <- geo::geopar.std$ylim
      if (!multfig) {
        par(mex = geo::geopar.std$mex)
      }
    }
    if (is.null(lat)) {
      lat <- c(65, 66)
      lon <- c(-28, -27)
      type <- "n"
    }
    oldpar <- selectedpar()
    if (locator & missing(zoom)) {
      limits <- geolocator(n = 2)
      if (geopar$projection == "none") {
        xlim <- limits$x
        ylim <- limits$y
      } else {
        xlim <- limits$lon
        ylim <- limits$lat
      }
    }
    xlim <- sort(xlim)
    ylim <- c(ylim)
    if (projection == "none") {
      if (length(country) == 1) {
        if (country == "default") {
          country <- "none"
        }
      }
    } else {
      if (length(country) == 1) {
        if (country == "default") {
          eval(parse(text = paste("country <- ", geo::COUNTRY.DEFAULT)))
        }
      }
    }
    init(
      lat,
      lon = lon,
      type = type,
      pch = pch,
      xlim = xlim,
      ylim = ylim,
      b0 = b0,
      r = r,
      xlab = xlab,
      ylab = ylab,
      option = option,
      grid = grid,
      new = new,
      cont = cont,
      cex = cex,
      col = col,
      lcont = lcont,
      plotit = plotit,
      reitur = reitur,
      smareitur = smareitur,
      reittext = reittext,
      axratio = axratio,
      lwd = lwd,
      axlabels = axlabels,
      oldpar = oldpar,
      projection = projection,
      b1 = b1,
      dlat = dlat,
      dlon = dlon,
      command = command,
      jitter = jitter,
      xaxdist = xaxdist,
      yaxdist = yaxdist
    )
    oldpar.1 <- Elimcomp(oldpar.1)
    par(oldpar.1)
    #        par(new = TRUE)
    if (reittext) {
      plot_reitnr(cexrt, lwd = lwd)
    }
    # number of squares
    if (length(country) > 1 && plotit) {
      geolines(country, col = col, lwd = lwd1)
    }
    # plot country
    return(invisible())
  }

# ---- geopoints.R ----
#' Adds points on plots initialized by geoplot.
#'
#' Plot points on a graph initialized by geoplot. Data is stored as lat, lon or
#' x,y depending on the projection. The program plots the transformation of the
#' data. Parameters for the projection are stored in the list geopar. Similar
#' to the Splus function points.
#'
#'
#' @param lat,lon Plot points on a graph initialized by geoplot. Data is stored
#' as lat, lon or x,y depending on the projection. The program plots the
#' transformation of the data. Parameters for the projection are stored in the
#' list geopar. Similar to the Splus function points.
#' @param pch Type of symbol used options are for example. " ","*","+","." or
#' anything else, letter, digit, or symbol. Default is "*"
#' @param cex Relative size of character and symbols (see the help on the
#' parameter cex).  The size of plotted characeters is cex time the parameter
#' csi that can be seen by \code{par("csi")}.  In earlier versions of geoplot
#' the parameter csi was set but csi is a parameter that can not be set in R.
#' The parameter mkh should probably be used for symbols instead of cex, see
#' help on graphical parameters.
#' @param col Colour number used.  Default value is one.
#' @param lwd Linewidth used. Default is the value set when the program was
#' called.
#' @param outside If TRUE geopoints will plot points outside the specified
#' limits set by geoplot(). If FALSE, which is default, outside points will be
#' skipped.
#' @param jitter useful if many datapoints have the same coordinates, points
#' are jittered randomly to make common values look bigger.jitter=0.016 is
#' often about right but you may want to have jitter smaller or bigger varying
#' on plot.
#' @param mkh Size of symbol in inches.  If not given cex is used instead.
#' @param csi Size of character.  This parameter can not be set in R but for
#' compatibility with old Splus scripts the parameter cex is readjusted by
#' \code{cex = cex*csi/0.12}.  Use of this parameter is not recommended.
#' Default value is NULL i.e not used.
#' @seealso \code{\link{geoplot}}, \code{\link{geopolygon}},
#' \code{\link{geolines}}, \code{\link{points}}, \code{\link{geotext}},
#' \code{\link{geosymbols}}, \code{\link{geocontour.fill}},
#' \code{\link{geogrid}}, \code{\link{geocontour}}.
#' @examples
#'
#' \dontrun{       geopoints(deg)                  # Plots * in the points
#'                                                 # defined by deg$lat,deg$lon.
#'
#'        geopoints(deg$lat,deg$lon,pch="*",col=5) # Same but uses color 5.
#'
#'        geopoints(fd$x,fd$y)                     # Points in x,y when
#'                                                 # projection in geoplot
#'                                                 # was "none".
#' }
#' @export geopoints
geopoints <-
  function(
    lat,
    lon = 0,
    pch = "*",
    cex = 0.7,
    col = 1,
    lwd = 0,
    outside = FALSE,
    jitter = NULL,
    mkh = NULL,
    csi = NULL
  ) {
    geopar <- getOption("geopar")
    if (!is.null(csi)) {
      cex <- cex * csi / 0.12
    } # Compatibility with old program
    if (length(lon) == 1 && length(lat) > 1) {
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
    if (!is.null(jitter)) {
      lat <- lat + runif(length(lat), -1, 1) * jitter
      lon <- lon + runif(length(lon), -1, 1) * jitter * 2
    }
    oldpar <- selectedpar()
    par(geopar$gpar)
    if (lwd != 0) {
      par(lwd = lwd)
    }
    if (outside) {
      par(xpd = TRUE)
    } else {
      par(xpd = FALSE)
    }
    on.exit(par(oldpar))
    par(cex = cex)
    xx <- Proj(
      lat,
      lon,
      geopar$scale,
      geopar$b0,
      geopar$b1,
      geopar$l1,
      geopar$projection
    )
    if (!outside) {
      ind <- c(1:length(lat))
      ind <- ind[
        xx$x > geopar$limx[2] |
          xx$x < geopar$limx[1] |
          xx$y < geopar$limy[1] |
          xx$y > geopar$limy[2] |
          is.na(
            xx$x
          ) |
          is.na(xx$y)
      ]
      if (length(ind) > 0) {
        xx$x <- xx$x[-ind]
        xx$y <- xx$y[-ind]
      }
    }
    if (!is.null(mkh)) {
      points(xx$x, xx$y, pch = pch, col = col, mkh = mkh)
    } else {
      points(xx$x, xx$y, pch = pch, col = col)
    }
    return(invisible())
  }

# ---- geolines.R ----
#' Add lines to current plot initialized by geoplot.
#'
#' Add lines to a plot initialized by geoplot. Data is stored as lat, lon or
#' x,y. Lists are assumed to have the components \code{$x} and \code{$y} if
#' projection in geoplot was "none", else \code{$lat},\code{$lon}. The program
#' transforms the data as specified in geoplot. Similar to the Splus function
#' lies.
#'
#'
#' @param lat Latitude of data. ( or x coordinate)
#' @param lon Longitude of data. ( or y coordinate) Negative values mean
#' western longitudes. Default value is zero. If lon is zero then the data is
#' stored as \code{lat$lat} and \code{lat$lon}. (or \code{lat$x} and
#' \code{lat$y})
#' @param col Colour number used for plotting the lines, default value is 1.
#' @param lwd Line width. Default is to use the width set when the program was
#' called.
#' @param lty Line type. Default is to use the width set when the program was
#' called. See Splus manuals for numbers corresponding to different linetypes
#' and linewidths.
#' @param nx Parameter only used with Lambert transform when lines in lat,lon
#' are curves in x,y. If nx > 1, nx-1 points are put between each two
#' datapoints in lat, lon before projection is done. For example:
#'
#' \code{geolines(c(66, 66), c(-30, -10), nx = 50)}
#'
#' plots a line onto the 66 degree latitude from -30 to -10. The line is curved
#' because it is made of 50 segments.
#' @param outside Logical, should lines outside the plot region be drawn?
#' Default FALSE.
#' @param return.data Logical, should the data be returned? Default FALSE.
#' @return No values returned.
#' @section Side Effects: The projection is stored in geoparprojection and
#' parameters for the transform in \code{geopar$b0, geopar$b1 and geopar$l1}.
#' @seealso \code{\link{geoplot}}, \code{\link{geopolygon}},
#' \code{\link{geopoints}}, \code{\link{geotext}}, \code{\link{geosymbols}},
#' \code{\link{geocontour.fill}}, \code{\link{geogrid}},
#' \code{\link{geocontour}}.
#' @keywords aplot
#' @examples
#'
#'        geolines(island)                      # plot iceland.
#'        geolines(island$lat, island$lon, col = 1) # same.
#'
#'        #######################################################
#'
#'        geoplot(xlim=c(0, -50), ylim=c(60, 75), projection = "Lambert")
#'        # Set up a Lambert plot.
#'
#'        geolines(c(66, 66), c(-30, -10), nx = 50, col = 155, lwd = 2)
#'        # Draw a line with colour 155 and width 2.
#'
#'        geopolygon(island)
#'        geolines(island, col = 3, lwd = 3)
#'        geolines(eyjar, col = 40)
#'        geolines(faeroes, col = 40)
#'        geolines(greenland, col = 3, lwd = 3)
#' #       geolines(janmayen, col = 40)
#'        # Plot some more countries using geolines.
#'
#' @export geolines
geolines <-
  function(
    lat,
    lon = 0,
    col = 1,
    lwd = 0,
    lty = 0,
    nx = 1,
    outside = FALSE,
    return.data = FALSE
  ) {
    geopar <- getOption("geopar")
    if (length(lon) == 1) {
      # For polygon structures.
      if (!is.null(lat$length)) {
        n <- lat$length
      } else {
        n <- max(c(
          length(
            lat$y
          ),
          length(lat$lat)
        ))
      }
      if (geopar$projection == "none") {
        lon <- lat$y[1:n]
        lat <- lat$x[1:n]
      } else {
        lon <- lat$lon[1:n]
        lat <- lat$lat[1:n]
      }
    }
    if (geopar$projection != "none") {
      # degrees and minutes
      if (mean(lat, na.rm = TRUE) > 1000) {
        lat <- geoconvert(lat)
        lon <- -geoconvert(lon)
      }
    }
    if (outside) {
      par(xpd = TRUE)
    } else {
      par(xpd = FALSE)
    }
    if (nx > 1) {
      # fill in with points for lambert.
      x <- fill.points(lat, lon, nx, option = 2)
      lat <- x$x
      lon <- x$y
    }
    oldpar <- selectedpar()
    par(geopar$gpar)
    if (lwd != 0) {
      par(lwd = lwd)
    }
    if (lty != 0) {
      par(lty = lty)
    }
    on.exit(par(oldpar))
    xx <- Proj(
      lat,
      lon,
      geopar$scale,
      geopar$b0,
      geopar$b1,
      geopar$l1,
      geopar$projection
    )
    if (!outside) {
      gx <- geopar$limx
      gy <- geopar$limy
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
      xx <- findline(xx, border)
    } else {
      par(xpd = FALSE)
    }
    #c program not used
    lines(xx$x, xx$y, col = col)
    par(oldpar)
    if (return.data) {
      xx <- invProj(xx)
      xx <- data.frame(lat = xx$lat, lon = xx$lon)
      return(invisible(xx))
    } else {
      return(invisible())
    }
  }

# ---- geolines.with.arrows.R ----
#' Add arrowhead to plot
#'
#' Adds arrowhead at the start or the end of a list of coordinates on a
#' geoplot.
#'
#'
#' @param data Dataframe with coordinates in columns \code{lat, lon}.
#' @param start Start from beginning (i.e. arrow points at first coordinate),
#' default TRUE.
#' @param size Size of arrow
#' @param \dots Additional arguments to \code{Arrow}
#' @return Draws an Arrowhead at the start or the end of the coordinates given
#' in \code{data}, returns invisibly the outline as four coordinate pairs in a
#' dataframe.
#' @note May need further elaboration and/or detail.
#' @seealso Called by \code{\link{geocurve}}, calls \code{\link{findline}},
#' \code{\link{invProj}} and \code{\link{Arrow}}.
#' @keywords aplot
#' @export geolines.with.arrows
geolines.with.arrows <-
  function(data, start = T, size = 0.2, ...) {
    geopar <- getOption("geopar")
    if (!is.data.frame(data)) {
      data <- data.frame(data)
    }
    n <- nrow(data)
    if (start) {
      i <- c(1:n)
    } else {
      i <- seq(n, 1, by = -1)
    }
    tmpdata <- data[i, ]
    limits <- invProj(geopar$limx, geopar$limy)
    plt.size <- geopar$gpar$pin
    dlon <- size / plt.size[1] * diff(limits$lon)
    dlat <- size / plt.size[2] * diff(limits$lat)
    theta <- seq(0, 2 * pi, by = 0.1)
    lat <- tmpdata[1, "lat"] + dlat * sin(theta)
    lon <- tmpdata[1, "lon"] + dlon * cos(theta)
    circle <- data.frame(lat = lat, lon = lon)
    xr <- findline(tmpdata, circle, plot = F)
    i <- is.na(xr$lat)
    i1 <- c(1:length(i))
    i1 <- i1[i]
    n <- min(i1) - 1
    pos <- list(
      lat = c(xr$lat[n], tmpdata$lat[1]),
      lon = c(xr$lon[n], tmpdata$lon[1])
    )
    pos <- Arrow(pos, ...)
    return(invisible(pos))
  }

# ---- geopolygon.R ----
#' Fill an area.
#'
#' The program fills an area. The program is similar to the polygon function
#' except the data is in lat, lon and the transform of the data specified in
#' geoplot is used. Also there are some additional parameters. The graph has to
#' be initialized by geoplot.
#'
#'
#' @param lat,lon Latitude and longitude of data ( or x and y coordinates),
#' negative for southern latitudes and western longitudes. May be supplied as
#' two vectors or as a list lat (or x) including vectors latlat and latlon
#' (xx and xy if projection = none).
#' @param col Color number used.  Default value is 0 (often white).
#' @param border If TRUE borders around the polygon are drawn. Default value is
#' FALSE.
#' @param exterior If TRUE everything that is outside the polygon is painted ,
#' else everything inside. Default value is FALSE. If exterior = TRUE axes and
#' grid often need refreshing by calling geoplot again with new = TRUE.
#' @param nx See geolines for further details.
#' @param outside If TRUE what is outside of the polygon is colored else what
#' is inside. Default value is TRUE.
#' @param plot if TRUE the polygon is plotted. Default is TRUE.
#' @param save if TRUE the points plotted are returned. Default is FALSE.
#' @param rat the ratio of the plot to what is plotted. Default is 0.005
#' meaning that the plot is 0.5\% bigger than what is plotted.
#' @param density see polygon.
#' @param Projection the projection to be used. Default is the one defined by
#' current plot.
#' @param angle see polygon.
#' @param allowed.size printers are limited to printing polygons of certain
#' size, when the polygons size is actually too big for your printer you can
#' enter the tedious task of splitting up the polygon. Default is 4000.
#' @param option Some option. Default 1.
#' @return The points plotted are returned if save = TRUE.
#' @seealso \code{\link{polygon}}, \code{\link{geoplot}},
#' \code{\link{geolines}}, \code{\link{geopoints}}, \code{\link{geotext}},
#' \code{\link{geosymbols}}, \code{\link{geocontour.fill}},
#' \code{\link{geogrid}}, \code{\link{geocontour}}.
#' @examples
#'
#' \dontrun{     geopolygon(island)              # Paint iceland with
#'                                      # color #0 (often white).
#'
#'      geopolygon(island, col = 0, exterior = TRUE)
#'
#'      geopolygon(geolocator(), col = 1)  # Paints a region defined
#'                                      # by pointing on map black.
#'
#'      # Of the maps available island (iceland) is about the only that
#'      # is correctly defined as closed polygon so it is the only one that
#'      # can be painted by geopolygon.
#'
#'      geoplot(grid = FALSE, type = "n")
#'      # Star by setting up the plot.
#'      geopolygon(gbdypif.500, col = 4, exterior = FALSE, r = 0)
#'      # Use geopolygon to draw the 500 m area.
#'      geopolygon(gbdypif.100, col = 155, exterior = FALSE, r = 0)
#'      # Draw 100 m are over the 500 m.
#'      geolines(eyjar, col = 115)
#'      # Add islands around Iceland.
#'      gbplot(c(100, 500), depthlab = TRUE)
#'      # Draw the depth lines, labels on lines.
#'      geopolygon(island, col = 115, outside = TRUE, r = 0)
#'      # Draw Iceland over.
#'      geoplot(grid = FALSE, new = TRUE)
#'      # Draw lines around Iceland, could also use geolines.
#' }
#' @export geopolygon
geopolygon <-
  function(
    lat,
    lon = NULL,
    col = "white",
    border = FALSE,
    exterior = FALSE,
    nx = 1,
    outside = FALSE,
    plot = TRUE,
    save = FALSE,
    rat = 0.005,
    density = -1,
    Projection = NULL,
    angle = 45,
    allowed.size = 80000,
    option = 1
  ) {
    geopar <- getOption("geopar")
    if (is.null(Projection)) {
      Projection <- geopar$projection
    }
    # 	for structures too large for hardware
    index <- lat$index
    RANGE <- lat$range
    LENGTH <- lat$length
    if (exterior) {
      in.or.out <- 1
    } else {
      in.or.out <- 0
    }
    err <- FALSE
    if (is.null(lon)) {
      if (Projection == "none") {
        lon <- lat$y
        lat <- lat$x
      } else {
        lon <- lat$lon
        lat <- lat$lat
      }
    }
    if (Projection != "none") {
      # degrees and minutes
      if (mean(lat, na.rm = TRUE) > 1000) {
        lat <- geoconvert(lat)
        lon <- -geoconvert(lon)
      }
    }
    if (length(lat) == 2) {
      lat <- c(lat[1], lat[1], lat[2], lat[2], lat[1])
      lon <- c(lon[1], lon[2], lon[2], lon[1], lon[1])
    }
    if (nx > 1) {
      # fill in with points for lambert.
      x <- fill.points(lat, lon, nx, option = 2)
      lat <- x$x
      lon <- x$y
    }
    oldpar <- selectedpar()
    par(geopar$gpar)
    if (outside) {
      par(xpd = TRUE)
    } else {
      par(xpd = FALSE)
    }
    on.exit(par(oldpar))
    gx <- geopar$limx
    rx <- gx[2] - gx[1]
    gy <- geopar$limy
    ry <- gy[2] - gy[1]
    gx[1] <- gx[1] + rat * rx
    gx[2] <- gx[2] - rat * ry
    gy[1] <- gy[1] + rat * ry
    gy[2] <- gy[2] - rat * ry
    brd <- data.frame(
      x = c(gx[1], gx[2], gx[2], gx[1], gx[1]),
      y = c(
        gy[1],
        gy[1],
        gy[2],
        gy[2],
        gy[1]
      )
    )
    brd1 <- invProj(brd)
    brd1 <- data.frame(lat = brd1$lat, lon = brd1$lon)
    if (!is.null(index)) {
      limits <- invProj(geopar$limx, geopar$limy)
      for (i in 1:length(index)) {
        xx <- Proj(lat[index[[i]]], lon[index[[i]]])
        if (!outside) {
          xx <- cut_multipoly(xx, brd, in.or.out)
        }
        if (length(xx$x) > 0) {
          polygon(
            xx$x,
            xx$y,
            col = col,
            border = border,
            density = density,
            angle = angle
          )
        }
      }
      return(invisible())
    } else {
      if (exterior) {
        i1 <- geoinside(brd1, data.frame(lat = lat, lon = lon), option = 0)
        i <- 1:4
        i <- i[is.na(match(i, i1))]
        if (length(i) == 0) {
          return(invisible())
        } else {
          i1 <- i[1]
        }
        i <- geoinside(
          data.frame(lat = lat, lon = lon),
          brd1,
          na.rm = TRUE,
          robust = FALSE,
          option = 0
        )
        if (length(i) == length(lat) || option != 1) {
          lat <- lat[!is.na(lat)]
          lon <- lon[!is.na(lon)]
          dist <- (lat - brd1$lat[i1])^2 +
            (lon - brd1$lon[i1])^2 *
              cos(
                (mean(lat) * pi) /
                  180
              )^2
          o <- order(dist)
          lat <- c(
            lat[c(o[1]:length(lat), 1:o[1])],
            brd1$lat[c(i1:4, 1:i1)],
            lat[o[1]]
          )
          lon <- c(
            lon[c(o[1]:length(lon), 1:o[1])],
            brd1$lon[c(i1:4, 1:i1)],
            lon[o[1]]
          )
          xx <- Proj(
            lat,
            lon,
            geopar$scale,
            geopar$b0,
            geopar$b1,
            geopar$l1,
            Projection
          )
          if (plot) {
            polygon(
              xx$x,
              xx$y,
              col = col,
              border = border,
              density = density,
              angle = angle
            )
            return(invisible())
          } else {
            return(invisible(invProj(xx)))
          }
        }
      }
    }
    err <- FALSE
    xx <- Proj(
      lat,
      lon,
      geopar$scale,
      geopar$b0,
      geopar$b1,
      geopar$l1,
      Projection
    )
    if (!outside) {
      xx <- cut_multipoly(xx, brd, in.or.out)
    }
    if (length(xx$x) > allowed.size && plot) {
      ind <- seq(along = xx$x)
      ind <- ind[is.na(xx$x)]
      if (length(ind) == 0) {
        err <- TRUE
      } else {
        ind <- c(1, ind, length(xx$x))
        if (max(diff(ind)) > allowed.size) {
          err <- TRUE
        } else {
          err <- FALSE
        }
      }
    }
    if (plot) {
      if (!err) {
        polygon(
          xx$x,
          xx$y,
          col = col,
          border = border,
          density = density,
          angle = angle
        )
      } else {
        print("too large polygon, change parameter allowed.zize")
      }
    }
    if (save) {
      xx <- invProj(
        xx$x,
        xx$y,
        geopar$scale,
        geopar$b0,
        geopar$b1,
        geopar$l1,
        Projection
      )
      return(list(lat = xx$lat, lon = xx$lon))
    }
    return(invisible())
  }

# ---- geotext.R ----
#' Plots text on a drawing defined by geoplot.
#'
#' The function plots a text in each of the points defined by lat,lon.  (or
#' x,y) The value plotted at each point is defined by the numeric vector or
#' text vector z. Simular to text but allows lat and lon and a choice of digits
#' used.
#'
#'
#' @param lat,lon Latitude and longitude of data ( or x and y coordinates),
#' negative for southern latitudes and western longitudes.  May be supplied as
#' two vectors or as a list lat (or x) including vectors latlat and latlon
#' (xx and xy if projection = none).
#' @param z Vector with values that will be plotted at datapoints. Has to be of
#' the same length as lat. If z is of mode character it is written directly on
#' the screen.
#' @param cex Relative size of characters (see the help on the parameter cex).
#' The size of plotted characeters is cex time the parameter csi that can be
#' seen by par()csi.  In earlier versions of geoplot the parameter csi was
#' set but csi is a parameter that can not be set in R.
#' @param adj Location of the text relative to the point, 0 means text right of
#' point, 0.5 text centered at point and 1 text left of point.  Default value
#' is 0.5.
#' @param col Color number used. Default value is 1.
#' @param digits Number of digits used.
#' @param pretext Text put in front of all the text.  Default value is nothing.
#' @param lwd Linewidth used.
#' @param aftertext Text put after all the text.  Default value is nothing.
#' @param outside If outside is F no text is plotted outside the range defined
#' by xlim,ylim.  Else it is done.  Default value is F.
#' @param angle angle of text in degrees, default is 0.
#' @param jitter see jitter in geoplot.
#' @param csi Size of character.  This parameter can not be set in R but for
#' compatibility with old Splus scripts the parameter cex is readjusted by cex
#' = cex*csi/0.12.  Use of this parameter is not recommended.  Default value is
#' NULL i.e not used.
#' @return No values returned.
#' @seealso \code{\link{geoplot}}, \code{\link{geopolygon}},
#' \code{\link{geolines}}, \code{\link{geosymbols}}, \code{\link{geogrid}},
#' \code{\link{geopar}}, \code{\link{geocontour.fill}},
#' \code{\link{geolocator}}, \code{\link{geocontour}}.
#' @examples
#' geoplot()
#' deg <- data.frame(lon = rnorm(10,-27,1.3),lat = rnorm(10,65,0.6))
#' z <- letters[1:10]
#' geotext(deg,z=z)    # plot text at points deg$lat,deg$lon
#'
#'        geotext(deg$lat,deg$lon,z,csi=0.06) # Same, size of text 0.06".
#'
#'  x <- deg
#'  names(x) <- c('y','x')
#'  x$z <- z
#'        geotext(x$x,x$y,x$z,aftertext="km",pretext="distance")
#'        # If geopar$projection="none"
#'
#'        geotext(x$x,x$y,z=x$z,aftertext=" km",pretext="distance",angle = 90)
#'        # Same text written vertically.
#'
#'
#'        ###############################################################
#'        #  Example                                                    #
#'        ###############################################################
#'
#'        lon <- rnorm(10,-27,1.3)
#'        lat <- rnorm(10,65,0.6)
#'        # Make a normal dist. random set of 10 points.
#'
#'        geoplot(lat=lat,lon=lon,grid=FALSE,xlim=c(-22,-30),ylim=c(63,67))
#'        # Plot the random data points.
#'
#'        geopolygon(island,col=115,exterior=TRUE)
#'        geolines(island)
#'        # Color Iceland. Use litir(number) to see colour scheme.
#'        # Sharpen lines around Iceland.
#'
#'        num <- 1:10
#'        lab <- paste("Nr.",num,sep="")
#'        # Make string vector with "Nr.1".."Nr.10" for geotext.
#'
#'        geopoints(lat,lon,pch="*",col=5)
#'        # Redraw the data in a new color the * mark at points.
#'
#'        geotext(lon=lon,lat=lat,z=lab,col=155)
#'        # With geotext we put one element from lab at each data point.
#'        title(main="10 Random Data Point")
#'        # Add title
#'
#' @export geotext
geotext <-
  function(
    lat,
    lon = 0,
    z,
    cex = 0.7,
    adj = 0.5,
    col = 1,
    digits = 0,
    pretext = "",
    lwd = 0,
    aftertext = "",
    outside = F,
    angle = 0,
    jitter = NULL,
    csi = NULL
  ) {
    geopar <- getOption("geopar")
    if (!is.null(csi)) {
      cex <- cex * csi / 0.12
    } # For compatibility
    if (length(lon) == 1 && length(lat) > 1) {
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
      if (mean(lat, na.rm = T) > 1000) {
        lat <- geoconvert(lat)
        lon <- -geoconvert(lon)
      }
    }
    if (!is.null(jitter)) {
      lat <- lat + runif(length(lat), -1, 1) * jitter
      lon <- lon + runif(length(lon), -1, 1) * jitter * 2
    }

    oldpar <- selectedpar()
    par(geopar$gpar)
    if (outside) {
      par(xpd = T)
    } else {
      par(xpd = F)
    }
    if (lwd != 0) {
      par(lwd = lwd)
    }
    on.exit(par(oldpar))
    par(cex = cex)
    par(adj = adj)
    xx <- Proj(
      lat,
      lon,
      geopar$scale,
      geopar$b0,
      geopar$b1,
      geopar$l1,
      geopar$projection
    )
    ind <- c(1:length(xx$x))
    if (is.character(z)) {
      if (pretext == "") {
        txt <- z
      } else {
        txt <- paste(pretext, z, sep = "")
      }
      if (aftertext != "") {
        txt <- paste(txt, aftertext, sep = "")
      }
    } else {
      if (pretext == "") {
        txt <- format(round(z, digits = digits))
      } else {
        txt <- paste(pretext, format(round(z, digits = digits)), sep = "")
      }
      if (aftertext != "") {
        txt <- paste(txt, aftertext, sep = "")
      }
    }
    if (!outside) {
      ind <- c(1:length(xx$x))
      ind <- ind[
        (!is.na(xx$x)) &
          (xx$x < geopar$limx[1] |
            xx$x > geopar$limx[2] |
            xx$y < geopar$limy[1] |
            xx$y > geopar$limy[2])
      ]
      xx$x[ind] <- NA
      xx$y[ind] <- NA
    }
    if (length(angle) == length(xx$x) || length(col) == length(xx$x)) {
      if (length(angle) < length(xx$x)) {
        angle <- rep(angle[1], length(xx$x))
      }
      if (length(col) < length(xx$x)) {
        col <- rep(col[1], length(xx$x))
      }
      for (i in 1:length(xx$x)) {
        text(
          xx$x[i],
          xx$y[i],
          txt,
          col = col[i],
          srt = angle[
            i
          ]
        )
      }
    } else {
      text(xx$x, xx$y, txt, col = col, srt = angle)
    }
    return(invisible())
  }

# ---- geosymbols.R ----
#' Plot different kinds of symbols at the data points.
#'
#' The function plots different kinds of symbols at the data points defined by
#' lat, lon. There are four categories of symbols:
#'
#' \describe{
#'  \item{\strong{Default}}{Shapes whose size is proportional to z or sqrt(z).}
#'  \item{\strong{Categories}}{Shapes where certain color, shading or size
#'   represents certain range of z. Similar to contour program.}
#'  \item{\strong{Filled circles}}{Certain size represents certain range of z,
#'   specified with fill.circles = TRUE.}
#'  \item{\strong{Characters}}{Characters or character strings represent the
#'   different ranges of z, specified with characters = TRUE.}
#' }
#'
#' There are seven types of shapes: circles, squares,
#' rectangles, vbars (vertical bars), hbars(horisontal bars) , perbars
#' (perpendicular bars), parbars (parallel bars)
#'
#'
#' @param lat,lon latitude and longitude of data or a dataframe containing
#' latitude and longitude of data (or x and y coordinates), negative for
#' southern latitudes and western longitudes. Expected to contain \$lat and
#' \$lon if not otherwise specified in col.names.
#' @param z Matrix containing values at datapoints.
#' @param levels Values at contourlines. Default value is zero. If levels is
#' zero the program determines the contourlines from the data. If squares,
#' circles, hbars, vbars or perbars are being used levels corresponds to the
#' levels where labels are given.
#' @param reflevels i Some levels for reference?
#' @param labels.only if true only labels are plotted. Default is false.
#' @param cex Size expansion of digits.
#' @param chs Something to do with characters?
#' @param z1 Value 2 at data points. Only used in connection with rectangles.
#' @param circles Max size of circles plotted at data points. Default value
#' used if value <-0 or >100. Size is either proportional to z or sqrt(z).
#' @param squares Max size of squares plotted at data points. Default value
#' used if value <-0 or >100. Size is either proportional to z or sqrt(z).
#' @param rectangles Max size of rectangles plotted at datapoints in inches.
#' The first number gives max height and the second number max width. Values <
#' 0 or > 100 give default values.
#' @param vbars Max size of vertical bars at data points in inches. Values >100
#' give default values. Value <0 gives bars below points.
#' @param hbars Max size of horizontal bars at data points in inches. Values
#' >100 give default values. Value <0 gives bars left of points.
#' @param perbars Max size of bars perpendicular to transsect lines in inches.
#' Values >100 give default values. Value <0 gives different orientation.
#' @param parbars Same as perbars, except the bars are now parallel.
#' @param sqrt If sqrt = TRUE the size of symbol is proportional to sqrt(z)
#' else to z. Default value if FALSE.
#' @param col Color number used, default col = 0.
#' @param maxn If nonzero maxn is the base for the size of symbols, else max(z)
#' is used. Nonzero maxn is used if several plots are to be compared.
#' @param colplot if true range of z is specified by a colour and not size.
#' @param nlevels Number of contourlines. Used if the program has to determine
#' the contourlines. Default value is 10.
#' @param colors Color number for the contourlines. Runs from 0 to 155. A
#' vector one longer than the vector levels. Default is blue-green-yellow- red
#' from lowest to the highest values. Color 0 is white and 1 is black. On black
#' and white plots higher color number means darker color and also when
#' hatching. When hatching the useful range is 10 to 80. When plotting filled
#' circles of different sizes colors means sizes in inches. When levels are not
#' specified directly colors have to be found by the program because even
#' though nlevels = 5 the length of levels can be 7 due to characteristics of
#' the Splus pretty command.
#' @param n Number of vertices in each circle, default value is 25, this
#' parameter is rarely changed by the user.
#' @param maxcol Number of colors used (excluding #0). Default value is 155
#' @param only.positive Logical value. If FALSE then negative values are
#' allowed else negative values are set to zero. Default value is FALSE.
#' @param digits Number of digits used in labels. Default value is zero.
#' @param white If true the first color is white.
#' @param lwd Line width for symbols. Default value is the value when the
#' program was called.
#' @param label.location List with components \$lat and \$lon specifying
#' oppesite corners of a square where the label should be put. (or \$x, \$y)
#' Gives the lower left and upper right corner of the box where the labels are
#' put. Default value is 0 that means no labels are put on the drawing or if
#' geoplot was initialized with cont = TRUE, then labels are put on the left
#' side of the plot. label.location is best given by geolocator or directly by
#' specifying label.location = "locator".
#' @param labels Type of labels 1 or 2. One is default and is usually used
#' except in color with very many colors (more than 10-20) .
#' @param fill.circles If TRUE filled circles of different sizes are plotted.
#' Size of the circles is given directly by the parameter color or found from
#' the data. (maxcol corresponds to the size of the largest circle in this case
#' and is 0.1 by default (changing maxcol to 0.4 makes all the circles 4 times
#' larger.)
#' @param density If density is 1 (or not zero) circles are hatched instead of
#' having different color. Only available with circles. Color does in this case
#' specify the density of hatching. Higher number means denser hatching. The
#' range is from zero to maxcol (155). But the effective range is ca. 10 - 80.
#' @param angle Angle of hatching, default is 45 degrees.
#' @param rotate Rotation of hatching from one level to the next. Default value
#' is 0 but 45 or 90 can be good to better distinquish between different
#' levels.
#' @param outside If TRUE geosymbols will plot outside the specified limits set
#' by geoplot(). If FALSE, which is default, outside points will be skipped.
#' @param minsym Minimum symbol, default is "<", meaning that if levels = c(1,
#' 2), labels will be presented as < 1, 1-2, 2 <, but if minsym = " " labels
#' will be presented as 1, 1-2, 2. See also labels.resolution.
#' @param boundcheck If boundcheck != 0 those points which are out of bounds
#' are returned to the user, if boundcheck = 2 the points are also not plotted,
#' default is boundcheck = 0.
#' @param na.rm If true NA's are removed, default is true.
#' @param label.resolution the resolution (precision) of the label numbers,
#' default is 0, meaning that if levels = c(1, 2), labels will be presented <
#' 1, 1-2, 2 <, if label.resolution = 0.1 labels will be presented < 1, 1.1-2,
#' 2.1<, see also minsym.  If label.resolution = "none", the labels will
#' present the lowest number of the interval with each color.
#' @param characters A boolean variable determing whether characters are to be
#' plotted.
#' @param pch Type of symbols for each level.
#' @param marks Type of symbols for each level. The difference between marks
#' and pch is becae when making points on a plot the user can either give pch =
#' 17 or pch = "A". The former type is called marks here but the latter pch.
#' Marks have to be given for each level and set to -1 where pch is to be used.
#' The length of the vector
#' @param charcol The color of the charchters, default is the same as col.
#' @param open.circles Should open.circles be plotted. Default FALSE. NEEDS
#' CHECKING.
#' @param col.names Column names with positions. Default \code{lat, lon}.
#' @param border Should border be plotted? Default FALSE. NEEDS CHECKING.
#' @param bordercol Color of border. Default 0. NEEDS CHECKING.
#' @return No values are returned
#' @seealso \code{\link{geoplot}}, \code{\link{geopolygon}},
#' \code{\link{points}}, \code{\link{geotext}}, \code{\link{geopoints}},
#' \code{\link{geocontour.fill}}, \code{\link{geogrid}},
#' \code{\link{geocontour}}.
#' @keywords aplot
#' @examples
#'
#'  \dontrun{     # lodna.2 composes of echo measurements for capelin on the
#'       # norther- and easternshores of Iceland. [lat, lon, z]
#'
#'       # Show points.
#'
#'       geoplot(lodna.2, type = "l", grid = FALSE)   # Begin by plotting Iceland.
#'       geopoints(lodna.2, pch = "*", col = 150)     # See where the points are.
#'
#'       ####################################
#'       # Example 1, color parbars plot.   #
#'       ####################################
#'
#'       geoplot(lodna.2, type = "l", grid = TRUE)     # Begin by plotting Iceland.
#'       levels = c(0, 20, 50, 100, 500, 1000)
#'
#'       geosymbols(lodna.2, z = lodna.2$z, colplot = TRUE, colors = seven.col,
#'                  levels = levels, parbars = 0.05, colors = seven.col,
#'                  label.location = "locator")
#'
#'       # "locator" click twice on the map where you want the contour index.
#'       # Indicate firstly the upper left corner position then lower right.
#'
#'       #######################################
#'       # Example 2, black/white perbars plot.#
#'       #######################################
#'
#'       geoplot(lodna.2, type = "l", grid = FALSE)
#'
#'       geosymbols(lodna.2, z = lodna.2$z, perbars = 0.1)
#'
#'       # Bars perpendicular to measurement direction
#'
#'       #######################################
#'       # Example 3, Color Dots.              #
#'       #######################################
#'
#'       # Set up data.
#'       attach("/usr/local/reikn/SplusNamskeid")
#'       i<-utbrteg$ar == 2004
#'
#'       # Set up the plot.
#'       geoplot()
#'       levels = c(10, 100, 500)
#'       colors = c(13, 55, 111, 153)
#'       labloc<-list(lat = c(63.95, 65.4), lon = c(-19.8, -17.3))
#'
#'       geosymbols(utbrteg[i, ], z = utbrteg[i, "torskur.kg"], circles = 0.05,
#'                  sqrt = TRUE, colplot = TRUE, levels = levels, colors = colors,
#'                  label.location = labloc)
#'
#'
#'       #######################################
#'       # Example 4, Rings around points.     #
#'       #######################################
#'
#'       # Having done the set up data and plot in Example 3.
#'
#'       geoplot(utbrteg$lat, utbrteg$lon, pch = ".")
#'       geosymbols(utbrteg[i, ], z = utbrteg[i, "torskur.kg"], circles = 0.2,
#'                  sqrt = TRUE, label.location = labloc)
#'
#'       # Circles can be replaced with squares, rectangles, vbars, hbars or
#'       # perbars or more than one used simultanuously.
#' }
#' @export geosymbols
geosymbols <-
  function(
    lat,
    lon = 0,
    z,
    levels = NULL,
    reflevels = NULL,
    labels.only = FALSE,
    cex = 0.6,
    chs = 0.8,
    z1 = 0,
    circles = 0,
    squares = 0,
    rectangles = c(
      0,
      0
    ),
    vbars = 0,
    hbars = 0,
    perbars = 0,
    parbars = 0,
    sqrt = FALSE,
    col = 1,
    maxn = 0,
    colplot = FALSE,
    nlevels = 10,
    colors = 0,
    n = 25,
    maxcol = 155,
    only.positive = FALSE,
    digits = 0,
    white = FALSE,
    lwd = 1,
    label.location = NULL,
    labels = 1,
    fill.circles = FALSE,
    density = 0,
    angle = 45,
    rotate = 0,
    outside = FALSE,
    minsym = "<",
    boundcheck = 0,
    na.rm = TRUE,
    label.resolution = 0,
    characters = FALSE,
    pch,
    marks,
    charcol = 0,
    open.circles = FALSE,
    col.names = c("lat", "lon"),
    border = FALSE,
    bordercol = 0
  ) {
    geopar <- getOption("geopar")
    options(warn = -1)
    if (!is.null(label.location)) {
      if (is.list(label.location)) {
        label.location <- as.data.frame(label.location)
      }
    }
    if (is.data.frame(lat)) {
      i <- match(col.names, names(lat))
      data <- data.frame(lat = lat[, i[1]], lon = lat[, i[2]])
    } else {
      data <- data.frame(lat = lat, lon = lon)
    }
    if (na.rm) {
      # delete na.
      ind <- c(1:length(data$lat))
      ind <- ind[is.na(data$lat) | is.na(data$lon)]
      if (length(ind) > 0) {
        data$lat <- data$lat[-ind]
        data$lon <- data$lon[-ind]
        z <- z[-ind]
      }
    }
    ind <- c(1:length(data$lat))
    ind <- ind[is.na(z)]
    if (length(ind) > 0) {
      data$lat[ind] <- NA
      data$lon[ind] <- NA
      z[ind] <- mean(z, na.rm = TRUE)
    }
    if (fill.circles) {
      colplot <- TRUE
    }
    if (open.circles) {
      colplot <- TRUE
    }
    if (density > 0) {
      colplot <- TRUE
    }
    if (maxn == 0) {
      maxn <- max(abs(z))
    }
    if (only.positive) {
      ind <- c(1:length(z))
      ind <- ind[z < 0]
      z[ind] <- 0
    }
    if (boundcheck != 0) {
      dataprj <- Proj(data$lat, data$lon)
      ind <- c(1:length(data$lat))
      ind <- ind[
        dataprj$x < geopar$limx[1] |
          dataprj$x > geopar$limx[2] |
          dataprj$y < geopar$limy[1] |
          dataprj$y > geopar$limy[2]
      ]
      if (length(ind) > 0) {
        ind1 <- paste(ind, collapse = ",")
        print(paste("points", ind1, "out of bounds"))
      }
      if (boundcheck == 2) {
        if (length(ind) > 0) {
          data$lat <- data$lat[-ind]
          data$lon <- data$lon[-ind]
          z <- z[-ind]
        }
      }
    }
    oldpar <- selectedpar()
    par(geopar$gpar)
    on.exit(par(oldpar))
    if (outside) {
      par(xpd = TRUE)
    } else {
      par(xpd = FALSE)
    }
    if (colplot) {
      if (labels.only) {
        if (cex != 0) {
          par(cex = cex)
        }
        colsymbol(
          data$lat,
          data$lon,
          z,
          circles,
          squares,
          rectangles,
          hbars,
          vbars,
          perbars,
          parbars,
          levels,
          nlevels,
          colors,
          white,
          n,
          maxcol,
          digits,
          label.location,
          labels,
          fill.circles,
          density,
          angle,
          rotate,
          minsym,
          label.resolution,
          col,
          labels.only = TRUE,
          open.circles = open.circles,
          lwd = lwd,
          border = border,
          bordercol = bordercol
        )
      } else {
        if (cex != 0) {
          par(cex = cex)
        }
        colsymbol(
          data$lat,
          data$lon,
          z,
          circles,
          squares,
          rectangles,
          hbars,
          vbars,
          perbars,
          parbars,
          levels,
          nlevels,
          colors,
          white,
          n,
          maxcol,
          digits,
          label.location,
          labels,
          fill.circles,
          density,
          angle,
          rotate,
          minsym,
          label.resolution,
          col,
          open.circles = open.circles,
          lwd = lwd,
          border = border,
          bordercol = bordercol
        )
      }
    } else {
      x <- Proj(
        data$lat,
        data$lon,
        geopar$scale,
        geopar$b0,
        geopar$b1,
        geopar$l1,
        geopar$projection
      )
      y <- x$y
      x <- x$x
      ein.pr.in <- (geopar$limy[2] - geopar$limy[1]) / geopar$gpar$pin[2]
      if (!is.null(label.location)) {
        if (label.location == "locator" || label.location == 0) {
          label.location <- geolocator(n = 2)
        }
        limits <- Proj(label.location)
        xlim <- limits$x
        ylim <- limits$y
        if (xlim[1] > xlim[2]) {
          temp <- xlim[1]
          xlim[1] <- xlim[2]
          xlim[2] <- temp
        }
        if (ylim[1] > ylim[2]) {
          temp <- ylim[1]
          ylim[1] <- ylim[2]
          ylim[2] <- temp
        }
        if (is.null(levels)) {
          rg <- range(z)
          lrg <- rg[2] - rg[1]
          levels <- signif(
            seq(
              rg[1] + lrg / 10,
              rg[2] -
                lrg / 10,
              length = nlevels
            ),
            2
          )
        }
        lbox <- length(levels)
        boxy <- c(1:lbox)
        boxy <- -boxy / lbox + 1
        boxy1 <- boxy + 1 / (1.2 * lbox)
        yloc <- (boxy + boxy1) / 2
        xloc <- matrix(0.85, length(yloc))
        par(adj = 0)
        textx <- as.character(levels)
        boxx <- c(matrix(0.1, 1, length(boxy)))
        boxx <- xlim[1] + abs((xlim[2] - xlim[1])) * boxx
        xloc <- xlim[1] + abs((xlim[2] - xlim[1])) * xloc
        yloc <- ylim[1] + abs((ylim[2] - ylim[1])) * yloc
        boxy <- ylim[1] + (ylim[2] - ylim[1]) * boxy
        ll <- (ylim[2] - ylim[1]) * 0.05
        if (
          circles != 0 | squares != 0 | hbars != 0 | vbars != 0 | perbars != 0
        ) {
          text(boxx, boxy + ll, textx, cex = chs)
        }
      }
      if (circles != 0) {
        # plot circles.
        rg <- range(circles)
        rglen <- rg[2] - rg[1]
        lev <- seq(rg[1] + rglen / 10, rg[2] - rglen / 10, length = 5)
        if ((circles > 100) | (circles < 0)) {
          circles <- 0.2
        }
        #default value.
        circles <- ein.pr.in * circles
        # size in units
        if (sqrt) {
          if (!labels.only) {
            symbols(
              x,
              y,
              circles = circles *
                sqrt(
                  abs(z) / maxn
                ),
              inches = FALSE,
              add = TRUE,
              fg = col,
              lwd = lwd
            )
          }
          if (!is.null(label.location)) {
            symbols(
              c(xloc),
              c(yloc),
              circles = circles *
                sqrt(
                  abs(levels) /
                    maxn
                ),
              add = TRUE,
              inches = FALSE,
              lwd = lwd,
              fg = col
            )
          }
        } else {
          if (!labels.only) {
            symbols(
              x,
              y,
              circles = circles * (abs(z) / maxn),
              add = TRUE,
              inches = FALSE,
              fg = col,
              lwd = lwd
            )
          }
          if (!is.null(label.location)) {
            symbols(
              c(xloc),
              c(yloc),
              circles = (circles * abs(levels)) / maxn,
              add = TRUE,
              inches = FALSE,
              lwd = lwd,
              fg = col
            )
          }
        }
      }
      if (squares != 0) {
        #plot squares.
        if ((squares > 100) | (squares < 0)) {
          squares <- 0.2
        }
        #default value.
        squares <- ein.pr.in * squares
        # size in units
        if (sqrt) {
          if (!labels.only) {
            symbols(
              x,
              y,
              squares = squares *
                sqrt(
                  abs(z) / maxn
                ),
              add = TRUE,
              inches = FALSE,
              fg = col,
              lwd = lwd
            )
          }
          symbols(
            c(xloc),
            c(yloc),
            squares = squares *
              sqrt(abs(levels) / maxn),
            add = TRUE,
            inches = FALSE,
            lwd = lwd,
            fg = col
          )
        } else {
          if (!labels.only) {
            symbols(
              x,
              y,
              squares = squares * (abs(z) / maxn),
              add = TRUE,
              inches = FALSE,
              fg = col,
              lwd = lwd
            )
          }
          symbols(
            c(xloc),
            c(yloc),
            squares = (squares *
              abs(levels)) /
              maxn,
            add = TRUE,
            inches = FALSE,
            fg = col,
            lwd = lwd
          )
        }
      }
      if ((rectangles[1] != 0) | (rectangles[2] != 0)) {
        # plot rectangles
        if ((rectangles[1] > 100) | (rectangles[1] < 0)) {
          rectangles[1] <- 0.2
        }
        # thickness
        if ((rectangles[2] > 100) | (rectangles[2] < 0)) {
          rectangles[2] <- 0.2
        }
        # length
        rectangles[1] <- ein.pr.in * rectangles[1]
        # size in units
        rectangles[2] <- ein.pr.in * rectangles[2]
        # size in units
        m <- matrix(rectangles[1], length(z), 2)
        if (sqrt) {
          m[, 1] <- rectangles[1] * sqrt(abs(z) / maxn)
        } else {
          m[, 1] <- (rectangles[1] * abs(z)) / maxn
        }
        if (length(z1) > 1) {
          if (sqrt) {
            m[, 2] <- rectangles[2] *
              sqrt(
                abs(
                  z1
                ) /
                  max(abs(z1))
              )
          } else {
            m[, 2] <- (rectangles[2] * abs(z1)) /
              max(
                abs(z1)
              )
          }
        }
        symbols(
          x,
          y,
          rectangles = m,
          add = TRUE,
          inches = FALSE,
          fg = col,
          lwd = lwd
        )
      }
      if (vbars != 0) {
        # plot vertical bars
        if (vbars > 100) {
          vbars <- 0.4
        }
        mx <- matrix(NA, 3, length(x))
        my <- mx
        mx[1, ] <- x
        my[1, ] <- y
        mx[2, ] <- x
        #      mlocx<- matrix(NA, 3, length(levels)); mlocy<-mlocx
        #      mlocx[1, ]<-c(xloc) ; mlocy[1, ]<-c(yloc); mlocx[2, ]<-c(xloc)
        r <- ein.pr.in * vbars
        # size in units
        if (sqrt) {
          my[2, ] <- my[1, ] + r * sqrt(abs(z) / maxn)
        } else {
          my[2, ] <- my[1, ] + (r * abs(z)) / maxn
        }
        if (!labels.only) {
          lines(mx, my, col = col, lwd = lwd)
        }
      }
      if (hbars != 0) {
        # plot horizontal bars
        if (hbars > 100) {
          hbars <- 0.4
        }
        mx <- matrix(NA, 3, length(x))
        my <- mx
        mx[1, ] <- x
        my[1, ] <- y
        my[2, ] <- y
        #      mlocx<- matrix(NA, 3, length(levels)); mlocy<-mlocx
        #      mlocx[1, ]<-c(xloc) ; mlocy[1, ]<-c(yloc); mlocy[2, ]<-c(yloc)
        r <- ein.pr.in * hbars
        # size in units
        if (sqrt) {
          mx[2, ] <- mx[1, ] + r * sqrt(abs(z) / maxn)
        } else {
          mx[2, ] <- mx[1, ] + (r * abs(z)) / maxn
        }
        if (!labels.only) {
          lines(mx, my, col = col, lwd = lwd)
        }
      }
      if (perbars != 0) {
        # plot bars perpendicular to cruiselines
        if (perbars > 100) {
          perbars <- 0.4
        }
        mx <- matrix(NA, 3, length(x))
        my <- mx
        mx[1, ] <- x
        my[1, ] <- y
        #      mlocx<- matrix(NA, 3, length(levels)); mlocy<-mlocx
        #      mlocx[1, ]<-c(xloc) ; mlocy[1, ]<-c(yloc); mlocy[2, ]<-c(yloc)
        r <- ein.pr.in * perbars
        # size in units
        dx <- c(1:length(x))
        dx[1] <- x[2] - x[1]
        dx[2:(length(x) - 1)] <- x[3:(length(x))] -
          x[
            1:(length(
              x
            ) -
              2)
          ]
        dx[length(x)] <- x[length(x)] - x[length(x) - 1]
        dy <- c(1:length(y))
        dy[1] <- y[2] - y[1]
        dy[2:(length(y) - 1)] <- y[3:length(y)] -
          y[
            1:(length(
              y
            ) -
              2)
          ]
        dy[length(y)] <- y[length(x)] - y[length(y) - 1]
        dxy <- sqrt(dx * dx + dy * dy)
        dx <- dx / dxy
        dy <- dy / dxy
        if (sqrt) {
          mx[2, ] <- mx[1, ] -
            dy *
              r *
              sqrt(
                abs(z) /
                  maxn
              )
        } else {
          mx[2, ] <- mx[1, ] - (dy * r * abs(z)) / maxn
        }
        if (sqrt) {
          my[2, ] <- my[1, ] +
            dx *
              r *
              sqrt(
                abs(z) /
                  maxn
              )
        } else {
          my[2, ] <- my[1, ] + (dx * r * abs(z)) / maxn
        }
        #      if(sqrt)  mlocx[2, ]<-mlocx[1, ]+r*sqrt(abs(levels)/maxn)
        #      else  mlocx[2, ]<-mlocx[1, ]+r*abs(z)/maxn
        if (!labels.only) lines(mx, my, col = col)
      }
    }
    par(oldpar)
    if (characters) {
      if (missing(marks)) {
        marks <- rep(-1, length(pch))
      }
      if (missing(pch)) {
        pch <- rep(" ", length(marks))
      }
      if (!is.numeric(levels)) {
        if (!is.numeric(z)) {
          ind <- match(z, levels)
        } else {
          if (is.null(reflevels)) {
            print("Error")
            return()
          }
          ind <- match(z, reflevels)
        }
        n <- length(levels)
      } else {
        if (charcol != 0) {
          col <- charcol
        }
        n <- length(levels) + 1
        levels <- c(-1000000., levels, 1000000.)
        ind <- cut(z, levels, labels = FALSE)
      }
      if (length(col) == 1) {
        col <- rep(col, n)
      }
      if (length(cex) == 1) {
        cex <- rep(cex, n)
      }
      if (!labels.only) {
        for (i in 1:n) {
          tmp <- data[ind == i, ]
          if (nrow(tmp) > 0) {
            if (marks[i] < 0) {
              geopoints(
                tmp,
                pch = pch[i],
                cex = cex[i],
                col = col[
                  i
                ]
              )
            } else {
              geopoints(
                tmp,
                pch = marks[i],
                cex = cex[i],
                col = col[
                  i
                ]
              )
            }
          }
        }
      }
      if (!is.null(label.location)) {
        ########
        if (!is.list(label.location)) {
          if (label.location == "locator") {
            label.location <- geolocator(n = 2)
          }
        }
        oldpar <- selectedpar()
        on.exit(par(oldpar))
        par(geopar$gpar)
        paint.window(label.location)
        label.location <- Proj(label.location)
        ## if(is.numeric(levels))
        ## 	Pointlabel(levels[2:(length(levels) - 1)],
        ## 		digits, label.location$x,
        ## 		label.location$y, minsym,
        ## 		label.resolution, marks, pch, col,
        ## 		cex, chs)
        ## else Charlabel(levels, label.location$x, label.location$
        ## 		y, label, marks, pch, col, cex, chs)
      }
    }
    options(warn = 0)
    return(invisible())
  }
