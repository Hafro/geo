# Auto-generated grouping file: contours.R
# Original function definitions were moved here for maintainability.

# ---- geocontour.R ----
#' Plots contour lines.
#'
#' The function plots contour lines. It is based on the Splus function
#' "contour" with some changes and extensions.  The main change is that
#' coordinates are in lat, lon instead of x, y. There are two additions : 1.
#' Possibility to have many colors.  2.  Possibility to only plot lines within
#' certain borders.  3.  Possibility to have labels in a box on the plot.
#' Note: to plot contour plots with fill between lines you use geocontour.fill
#'
#'
#' @param grd List with components \code{lat} and \code{lon} (or
#' \code{x},\code{y}) defining the grid values.  Can be made for example by lat
#' <- list(lat = seq(60,65,length = 100), lon = seq(-30,- 10,length = 200)).
#' Also lat can be the output of the program grid and then the components
#' \code{lat$grpt$lat}, \code{lat$grpt$lon} and \code{lat$reg} are used. See
#' geocontour.fill.
#' @param z Matrix or vector of values.  Length nlat*nlon except when lat is a
#' list with components \code{lat$grpt} and \code{lat$xgr}.  Then the length of
#' z is the same as the length of \code{lat$xgr$lat} and \code{lat$xgr$lon}.
#' @param nlevels Number of contourlines.  Used if the program has to determine
#' the contourlines.  Default value is 10. nlevels = 10 does not always mean 10
#' due to characteristic of the pretty command
#' @param levels Ratio of textsize to current size.  1 means same size, 0.5
#' half size , 0 no text etc.  Default value 1.
#' @param labcex Character expansion of letters indicating the z value on the
#' contour lines. Maybe used instead of a legend.
#' @param triangles If TRUE the program makes 4 triangles from each element in
#' the grid.  In fact it makes the number of grid points approximately twice as
#' many as before which means smoother contourlines.  Default value TRUE.
#' Triangles = TRUE is nessecary if the area was plotted with geocontour.fill.
#' It fits with geocontour.fill.
#' @param reg List with two components, \code{reg$lat} and \code{reg$lon}.
#' Region of interest. Contourlines are only plotted inside the region.  Holes
#' in the region of interest begin with NA.  If the region consists only of
#' holes then \code{reg$lat} and \code{reg$lon} begin with NA.
#' @param fill If fill is one the matrix is filled with zeros.  If two it is
#' filled with mean(z).  Default is fill = 1.  ( not an important parameter)
#' @param colors If colors is TRUE the contour lines are plotted in many
#' colors.  Else only in one.  The lines can also be in one color using many
#' linetypes.
#' @param col Number of color (colors) used to plot contourlines.  Default
#' value is 1 if colors is FALSE.  If colors is TRUE the default value is found
#' from the number of contour lines.
#' @param only.positive Logical value.  If FALSE then negative values are
#' allowed else negative values are set to zero.  Default value is FALSE.
#' @param maxcol Maximum color number in the Splus graphics, default value 155.
#' @param cex Character expansion of digits, default value is 0.7.
#' @param save If true the contour lines are saved in a list so they can later
#' be plotted with geolines.  Default value is false.
#' @param plotit If TRUE the lines are plotted on the graphics device else not.
#' Default value is true.
#' @param label.location List with components \code{lat} and \code{lon} (or
#' \code{x},\code{y}) Gives the lower left and upper right corner of the box
#' where the labels are put.  Default value is 0 that means no labels are put
#' on the drawing (except when \code{geopar$cont = TRUE}).  l1 is best given by
#' geolocator or directly by specifying label.location = "locator".
#' @param lwd Line with.  Default value is the value set when the program was
#' called.
#' @param lty ine type.  If lty is a vector of the same length of levels it
#' specifies the linetype for each contour line.  Default value is the same as
#' when the program was called.
#' @param labels.only If true only the labels are drawn.  Default is false.
#' @param digits Number of digits in labels.  Default value is one.
#' @param paint if true borders of regions will be painted.
#' @param set Set something.
#' @param col.names the names of the vectors containing the data in grd.
#' Default is col.names = c("lon","lat").
#' @param csi Size of character.  This parameter can not be set in R but for
#' compatibility with old Splus scripts the parameter cex is readjusted by cex
#' = cex*csi/0.12.  Use of this parameter is not recommended.  Default value is
#' NULL i.e not used.
#' @param drawlabels Draw labels on the contour lines? Default FALSE.
#' @return No values returned.
#' @section Side Effects: No side effects.
#' @seealso \code{\link{contour}}, \code{\link{geocontour.fill}},
#' \code{\link{geolocator}}, \code{\link{geopolygon}}, \code{\link{geotext}},
#' \code{\link{geosymbols}}, \code{\link{geogrid}}, \code{\link{geopar}},
#' \code{\link{geolines}}.
#' @examples
#'
#'      ###################################################
#'      # Example l                                       #
#'      ###################################################
#' \dontrun{
#'      geoplot(deg, cont = TRUE)                        # Plot initialized.
#'      geocontour(grd$lat,grd$lon,z,nlevels = 10,
#'                 neg = FALSE,reg = reg,colors = TRUE)          # Contour plot.
#'      geoplot(deg,pch = " ",cont = TRUE,new = TRUE)           # Plot over contourplot.
#' }
#'      ###################################################
#'      # Example 2 Sea Tempeture.                        #
#'      ###################################################
#'
#'      # The following data names used are in Icelandic, stodvar means
#'      # stations and botnhiti means temperature.
#'
#'      geoplot()
#'      gbplot(500)
#'      grd <- list(lat = seq(63,67,length = 30),
#'                  lon = seq(-28,-10,length = 50))
#'      labloc <- list(lat = c(63.95,65.4),lon = c(-19.8,-17.3))
#'
#'      grd1 <- geoexpand(grd)                       # Make grid.
#'      grd2 <- geoinside(grd1,gbdypif.500)
#'      grd2 <- geoinside(grd2,island,robust = FALSE,option = 2)
#'      # Use only the points where depth < 500 and outside Iceland.
#' \dontrun{
#'      #xx <- loess(botnhiti~ lat*lon,degree = 2,spaALSEn = 0.25,
#'      #            data = stodvar, na.action = na.omit)
#'      # Use loess for interpolating.
#'
#'      #grd2$temp <- predict(xx,grd2)
#'      #geocontour(grd2,z = grd2$temp,levels = c(0,1,2,3,4,5,6,7),
#'      #           label.location = labloc)
#'
#'      ######################################################
#'      # Example 3 example of gam() and indexes.            #
#'      ######################################################
#'
#'      stations<-data.frame(lat = stodvar$lat,lon = stodvar$lon,
#'                           temp = stodvar$botnhiti)
#'      # Making a partial data.frame from a big one called stodvar,
#'      # which means stations in Icelandic.
#'
#'      stations[1:5,]             # Show first 5 lines all columns
#'                                 # in stations.
#'      dim(stations)              # Length of (lines,colums).
#'      dim(stations[!is.na(stations$temp),])      # Without NAs.
#'      my.data <- stations[!is.na(stations$temp),]
#'      my.data <- my.data[!is.na(my.data$lat),]
#'      my.data <- my.data[!is.na(my.data$lon),]
#'      # my.data is now same as stations but witout NAs in lat,
#'      # lon and temp.
#'
#'      pred.grid <- list(lat = seq(63.25,67.25,length = round((67.25-63.25+1)*8)),
#'                        lon = seq(-27,-11.5,length = round((27-11.5+1)*4)))
#'      pred.grid <- geoexpand(pred.grid)
#'      # Making a grid to fit our area of interest.
#'      pred.grid <- geoinside(pred.grid,gbdypif.500)
#'      # Points within 500m.
#'      pred.grid <- geoinside(pred.grid,island,robust = FALSE,option = 2)
#'      # Points outside  of Iceland.
#'
#'      geoplot(grid = FALSE)
#'      my.data <- geoinside(my.data,island,robust = FALSE,option = 2)
#'      geopoints(my.data,pch = ".")
#'
#'      fit <- gam(temp~lo(lat,lon,span = 0.1),data = my.data)
#'      # see help(gam)
#'      # can also do:
#'      # fit <- loess(temp~lon*lat,data = my.data,span = 0.1)
#'      # fit <- gam(temp~ns(lon,df = 7)*ns(lat,df = 5),data = my.data)
#'
#'      pred.grid$pred.temp <- predict(fit,newdata = pred.grid)
#'      geocontour(pred.grid,z = pred.grid$pred.temp,levels = 0:7,
#'                 label.location = labloc)
#' }
#' @export geocontour
geocontour <-
  function(
    grd,
    z,
    nlevels = 10,
    levels = NULL,
    labcex = 1,
    triangles = TRUE,
    reg = 0,
    fill = 1,
    colors = TRUE,
    col = 1,
    only.positive = FALSE,
    maxcol = 155,
    cex = 0.7,
    save = FALSE,
    plotit = TRUE,
    label.location = 0,
    lwd = 1,
    lty = 1,
    labels.only = FALSE,
    digits = 1,
    paint = FALSE,
    set = NA,
    col.names = c("lon", "lat"),
    csi = NULL,
    drawlabels = FALSE
  ) {
    geopar <- getOption("geopar")
    if (!is.null(csi)) {
      cex <- cex * csi / 0.12
    }
    if (!is.null(attributes(grd)$grid)) {
      z <- grd
      grd <- attributes(grd)$grid
    }
    limits <- NULL
    maxn <- 10000
    grd <- Set.grd.and.z(grd, z, NULL, set, col.names)
    z <- grd$z
    z <- z + rnorm(length(z)) * 1e-09
    grd <- grd$grd
    grd <- extract(grd, z, maxn, limits, col.names = col.names)
    z <- grd$z
    grd <- grd$grd1
    ind <- c(1:length(z))
    ind <- ind[is.na(z)]
    if (length(ind) > 0) {
      if (fill == 0) {
        z[ind] <- -99999
      }
      if (fill == 1) {
        z[ind] <- 0
      }
      if (fill == 2) {
        z[ind] <- mean(z)
      }
    }
    lon <- grd[[col.names[1]]]
    lat <- grd[[col.names[2]]]
    if (only.positive) {
      ind <- c(1:length(z))
      ind <- ind[z < mean(z[z > 0]) / 1000 & z != -99999]
      z[ind] <- mean(z[z > 0]) / 1000
    }
    cond1 <- col.names[1] == "lon" && col.names[2] == "lat"
    cond2 <- col.names[1] == "x" &&
      col.names[2] == "y" &&
      geopar$projection == "none"
    if (cond1 || cond2) {
      oldpar <- selectedpar()
      on.exit(par(oldpar))
      par(geopar$gpar)
      if (geopar$cont) {
        par(plt = geopar$contlines)
      }
    }
    if (cex != 0) {
      par(cex = cex)
    }
    nx <- length(lon)
    ny <- length(lat)
    lon1 <- matrix(lon, nx, ny)
    lat1 <- t(matrix(lat, ny, nx))
    if (!labels.only) {
      if (geopar$projection == "Mercator" && col.names[1] == "lon") {
        z <- matrix(z, nrow = length(lon), ncol = length(lat))
        lon2 <- c(matrix(lon[1], length(lat), 1))
        lat2 <- c(matrix(lat[1], length(lon), 1))
        xlat <- Proj(
          lat,
          lon2,
          geopar$scale,
          geopar$b0,
          geopar$b1,
          geopar$l1,
          geopar$projection
        )
        xlon <- Proj(
          lat2,
          lon,
          geopar$scale,
          geopar$b0,
          geopar$b1,
          geopar$l1,
          geopar$projection
        )
      } else {
        z <- matrix(z, nrow = length(lon), ncol = length(lat))
        xlon <- list(x = lon)
        xlat <- list(y = lat)
      }
    }
    if (colors) {
      if (is.null(levels)) {
        if (nlevels == 0) {
          nlevels <- 10
        }
        levels <- pretty(z, nlevels)
      }
      nlevels <- length(levels)
      if (length(lty) == length(levels) && length(levels) > 1) {
        linetypes <- TRUE
      } else {
        linetypes <- FALSE
        lty <- rep(lty, length(levels))
      }
      if (length(lwd) == length(levels) && length(levels) > 1) {
        linew <- TRUE
      } else {
        linew <- FALSE
        lwd <- rep(lwd, length(levels))
      }
      if (length(col) == 1) {
        if (length(lty) == length(levels)) {
          color <- rep(1, nlevels)
        } else {
          mincol <- 2
          color <- c(1:nlevels)
          color <- round(2 + ((color - 1) * maxcol) / (nlevels))
        }
      } else {
        color <- col
      }
      if (!labels.only) {
        if (length(ind) > 1) {
          z[ind] <- NA
        }
        if (geopar$projection == "Lambert") {
          lev <- contourLines(lon + 400, lat, z, levels = levels)
          for (i in 1:length(lev)) {
            j <- match(lev[[i]]$level, levels)
            if (linew) {
              lw <- lwd[j]
            } else {
              lw <- 0
            }
            if (linetypes) {
              lt <- lty[j]
            } else {
              lt <- 0
            }
            geolines(
              lev[[i]]$y,
              lev[[i]]$x - 400,
              col = color[j],
              lty = lt,
              lwd = lw
            )
          }
        } else {
          for (i in 1:nlevels) {
            lev <- contour(
              xlon$x,
              xlat$y,
              z,
              axes = FALSE,
              drawlabels = drawlabels,
              levels = c(levels[i], levels[i]),
              add = TRUE,
              triangles = triangles,
              labcex = labcex,
              xlim = geopar$limx,
              ylim = geopar$limy,
              col = color[i],
              xlab = " ",
              ylab = " ",
              save = FALSE,
              plotit = TRUE,
              lwd = lwd[i],
              lty = lty[i]
            )
          }
        }
      }
    } else {
      if (length(ind) > 1) {
        z[ind] <- NA
      }
      if (geopar$projection == "Lambert") {
        if (length(levels) == 1) {
          lev <- contourLines(lon + 400, lat, z, nlevels = nlevels)
        } else {
          lev <- contourLines(lon + 400, lat, z, levels = levels)
          for (i in 1:length(lev)) {
            geolines(lev[[i]]$y, lev[[i]]$x - 400, col = col)
          }
        }
      } else {
        if (length(levels) == 1) {
          lev <- contour(
            xlon$x,
            xlat$y,
            z,
            nlevels = nlevels,
            triangles = triangles,
            labcex = labcex,
            add = TRUE,
            xlim = geopar$limx,
            ylim = geopar$limy,
            axes = FALSE,
            col = col,
            xlab = " ",
            ylab = " ",
            save = save,
            plotit = plotit,
            drawlabels = drawlabels
          )
        } else {
          lev <- contour(
            xlon$x,
            xlat$y,
            z,
            axes = FALSE,
            levels = levels,
            triangles = triangles,
            add = TRUE,
            labcex = labcex,
            xlim = geopar$limx,
            ylim = geopar$limy,
            col = col,
            xlab = " ",
            ylab = " ",
            save = save,
            plotit = plotit,
            drawlabels = drawlabels
          )
        }
      }
    }
    if (save && geopar$projection == "Mercator") {
      lev <- contourLines(xlon$x, xlat$y, z, levels = levels)
      tmpdata <- data.frame(lat = 0, lon = 0, level = -99)
      res <- NULL
      for (i in 1:length(lev)) {
        tmp <- invProj(lev[[i]])
        tmp <- data.frame(lat = tmp$lat, lon = tmp$lon)
        tmp$level <- rep(lev[[i]]$level, nrow(tmp))
        res <- rbind(res, tmp)
        res <- rbind(res, tmpdata)
      }
      i <- res$lat == 0
      if (any(i)) {
        res$lat[i] <- res$lon[i] <- NA
      }
      lev <- res
    }
    if (save && geopar$projection == "Lambert") {
      tmpdata <- data.frame(lat = 0, lon = 0, level = -99)
      res <- NULL
      for (i in 1:length(lev)) {
        tmp <- lev[[i]]
        tmp <- data.frame(lat = tmp$y, lon = tmp$x - 400)
        tmp$level <- rep(lev[[i]]$level, nrow(tmp))
        res <- rbind(res, tmp)
        res <- rbind(res, tmpdata)
      }
      i <- res$lat == 0
      if (any(i)) {
        res$lat[i] <- res$lon[i] <- NA
      }
      lev <- res
    }

    if (geopar$projection == "Lambert") {
      par(geopar$gpar)
    }
    if (length(label.location) == 1) {
      if (label.location == "locator") {
        label.location <- geolocator(n = 2)
      }
    }
    if (length(label.location) > 1) {
      label.location <- Proj(
        label.location,
        scale = geopar$scale,
        b0 = geopar$b0,
        b1 = geopar$b1,
        l1 = geopar$l1,
        projection = geopar$projection
      )
      if (geopar$projection == "none") {
        paint.window.x(label.location, border = TRUE)
      } else {
        paint.window(label.location, border = TRUE)
      }
      labels_line(
        levels,
        digits,
        color,
        lty,
        lwd,
        xlim = label.location$x,
        ylim = label.location$y,
        linew
      )
    }
    if (geopar$cont && colors) {
      par(plt = geopar$contlab)
      par(new = TRUE)
      plot(
        c(0, 1, 1, 0, 0),
        c(0, 0, 1, 1, 0),
        type = "l",
        axes = FALSE,
        xlab = " ",
        ylab = " "
      )
      labels_line(levels, digits, color, lty, linew)
    }
    if (length(reg) > 1 && paint) {
      nx <- length(lon)
      ny <- length(lat)
      lon <- matrix(lon, nx, ny)
      lat <- t(matrix(lat, ny, nx))
      shadeborder(reg, lat, lon)
    }
    if (cond1 || cond2) {
      par(oldpar)
    }
    if (save) {
      return(invisible(lev))
    } else {
      return(invisible())
    }
  }

# ---- geocontour.fill.R ----
#' geocontour.fill plots colored or black and white contours on a graph made by
#' geoplot.
#'
#' The program accepts data on a rectangular grid.  Irregular data can be
#' interpolated on the grid in a number of ways, using kriging, the Splus
#' function interp, etc.  NA's are allowed in the matrix but they are changed
#' to 0 or the average value of z early in the program. The geo package
#' contains two different contour plot programs, geocontour and
#' geocontour.fill.  Geocontour draws contour lines and geocontour.fill fills
#' in between the lines.  Hardcopy of the plot can be done on a color
#' postscript printer or on a black and white postscript printer.  In all cases
#' the "postscript" driver included with Splus has to be used.  There is
#' another postscript driver included with Splus called "pscript".  That driver
#' is used when a plot is on the screen and the print button is pressed.  That
#' can not be done when the postscript driver is used as described here after.
#'
#'
#' @param grd List with components lat and lon (or x, y) defining the
#' grid values.  Can be made for example by lat <- list(lat = seq(60, 65,
#' length = 100), lon = seq(-30, - 10, length = 200)).  Also lat can be the
#' outcome of the program grid and then the components latgrptlat,
#' latgrptlon and latreg are used.
#' @param z Matrix or vector of values.  Length(z) = nlat*nlon except when lat
#' is a list with components latgrpt and latxgr.  Then the length of z is
#' the same as the length of latxgrlat and latxgrlon.  This is the case
#' if the output of the grid program is used as input lat.
#' @param levels Values at contourlines.  Default value is zero.  If levels is
#' zero the program determines the contourlines from the data.  If levels is of
#' length 3 with levels = c(0, 1, 2) then there are 4 groups each with special
#' color i.e. <0, 0-1, 1-2 and > 2.
#' @param nlevels Number of contourlines.  Used if the program has to determine
#' the contourlines.  Default value is 10.  nlevels = 10 does not always mean
#' 10 due to characteristic of the pretty command.
#' @param cex Character size expansion.  Size of letters in labels.  Default
#' value is 0.7.
#' @param digits Number of digits in the labels.  Default value is 1.
#' @param col Color number for the contourlines.  A vector one longer than the
#' vector levels Default is blue-green- yellow-red from lowest to the highest
#' values.  The program assumes certain setup of the splus colors that is
#' described later. Colors should not be specified explicitly except the
#' contour lines are.
#' @param working.space Size of working space.  The program determines it from
#' data and prints on the screen.  If mysterious errors occur then it is likely
#' that the program has not reserved enough working space.  The program writes
#' the used work space on the screen for use in similar situations. (saves
#' time.)
#' @param labels Type of labels, either 1 or 2 <s-example>
#'
#' labels = 1 means type of label used with few contourlines <20.  labels = 2
#' means type of label used with many contourlines >20.  can also use labels =
#' 3 means only labels, no contour plot.
#'
#' </s-example> Labels can be inserted in two ways, by calling geoplot with
#' cont = TRUE or by specifying label.location.  In the first case the left
#' part of the plot is reserved for labels while in the latter case the label
#' is put in a place specified by the user.  The latter method is recommended
#' in most cases.
#' @param ratio Factor used to avoid numerical problems.  Default value 100.
#' Lower values decrease numerical problems but can introduce bias.
#' @param only.positive Logical value.  If TRUE then negative values are not
#' allowed else negative values are set to zero.  Default value is FALSE.
#' @param fill Determines whether NA's should be replaced with zeros (fill = 1)
#' or mean(z) (fill = 2).  Default value is fill = 1.  Used when lat is a list
#' with components latxgrlat, latxgrlon, latgrptlat and
#' latgrptlon.  Only used in special cases.
#' @param maxcol Number of colors used (excluding #0).  Default value 155.
#' @param white If true the the first class is represented with white (color
#' 0). Default value is FALSE but white = TRUE is also often used.
#' @param label.location List with components lat and lon.  (or x, y)
#' Gives the lower left and upper right corner of the box where the labels are
#' put.  Default value is 0 that means no labels are put on the drawing (except
#' when geoparcont = TRUE).  l1 is best given by geolocator or directly by
#' specifying label.location = "locator".
#' @param labels.only If labels.only is true no contours are drawn but only
#' labels.  Default value is false.  Order of the commands could be:
#' <s-example> > geoplot(deg, plot = FALSE) > geocontour.fill(lat, z = z,
#' levels = lev, reg = area) # Draw contours.  > geocontour(lat, z = z, levels
#' = lev, colors = FALSE, reg = area) # Only used with black and white printers
#' to make distinction # between different levels clearer.  (not used with
#' color # printers).  > geoplot(deg, new = TRUE) # Refresh gridlines.  >
#' geocontour.fill(lat, z = z, levels = lev, labels.only = TRUE, label.location
#' = l1) # Add labels.  </s-example>
#' @param bordercheck if true the program checks if plot is outside border and
#' does not plot what is outside border.
#' @param maxn a parameter determing the resolution of the plot, unimportant.
#' @param bcrat bordercheck ratio, how much outside the border we will allow to
#' be plotted, default is bcrat = 0.05 meaning that we will allow the plot to
#' go 5\% off the border.
#' @param limits To be described.
#' @param col.names the names of the columns in grid, the first argument will
#' be plotted on the x-axes and the second on the y-axes.  Default is col.names
#' = c("lat", "lon").
#' @param minsym minimum symbol, default is "<", meaning that if levels = c(1,
#' 2), labels will be presented as < 1, 1-2, 2 <, but if minsym = " " labels
#' will be presented as 1, 1-2, 2.  See also labels.resolution.
#' @param label.resolution the resolution (precision) of the label numbers,
#' default is 0, meaning that if levels = c(1, 2), labels will be presented <
#' 1, 1-2, 2 <, if label.resolution = 0.1 labels will be presented < 1, 1.1-2,
#' 2.1<, see also minsym.  If label.resolution = "none", the labels will
#' present the lowest number of the interval with each color.
#' @param labtxt To be described.
#' @param boxcol Colour of box around labels (legend?).
#' @param first.color.trans To be described.
#' @param mai \code{par} argument 'margin in inches'?
#' @param leftrat To be described.
#' @param labbox should a box be drawn around labels (legend?).
#' @param csi Size of character.  This parameter can not be set in R but for
#' compatibility with old Splus scripts the parameter cex is readjusted by cex
#' = cex*csi/0.12.  Use of this parameter is not recommended.  Default value is
#' NULL i.e not used.
#' @section Details: <s-example>
#'
#' The program is based on making triangles out of a matrix of data nx * ny.
#' The number of triangles is (nx-1)*(ny- 1)*4 and linear interpolation is used
#' inside each triangle.  The factor 4 comes from the fact that the number of
#' points is doubled by interpolation. </s-example> <s-example>
#'
#' Most of the calculations in the program are done by a program written in C.
#' The Splus part of the program prepares the data for the C program, reserves
#' memory and the user interface is in Splus.  The C program is loaded
#' automatically. </s-example> <s-example>
#'
#' The program is currently based on the following color setup in Splus.
#' </s-example> <s-example>
#'
#' splus*color : white black blue 50 green 50 yellow 50 red </s-example>
#' <s-example>
#'
#' This gives 155 colors with color#0 white, #1 black, #2 blue, #53 green, #104
#' yellow, and #155 red.  The parameter maxcol is set to 155 based on this
#' setup but it can be changed if another setup is used.  The vector postcol
#' stores the mapping from the colors on the terminal to color postscript based
#' on this setup. </s-example> <s-example>
#'
#' If the openlook() or motif() windowmanager is used in Splus the colors can
#' be changed inside Splus.  In openlook it is best to make a colorscheme
#' called geoplot: black blue 50 green 50 yellow 50 red.  The background color,
#' i.e. white is not in the definition here. </s-example> <s-example>
#'
#' The maximum number of contourlines that can be used is currently 60.
#' </s-example> <s-example>
#'
#' The program requires that geoplot is called before to set up the drawing.
#' geoplot is called by the parameter cont = TRUE. This is to reserve space for
#' labels on the drawing. </s-example> <s-example>
#'
#' If the drawing is written to a file geoplot should be called with plot =
#' FALSE.  Then it only sets up the drawing but does not plot anything so the
#' size of the file will be reduced. </s-example> <s-example>
#'
#' If the labels do not fit the relative space taken by labels and picture can
#' be changed by the parameter lcont in geoplot.  After geocontour.fill is
#' called geoplot is called again with new = TRUE to get all kind of lines back
#' but they were painted over by the program. </s-example> <s-example>
#'
#' The program treats borders in a special way.  It begins by making
#' contour-lines over the hole area as if the borders did not exist.  When that
#' is finished the area outside the borders is painted white. </s-example>
#' <s-example>
#'
#' If good picture is needed geocontour should be used between levels to get
#' sharper pictures. </s-example> <s-example>
#'
#' If the matrix z is not full the program should be called by a list
#' latxgrlat, latxgrlon, latgrptlat and latgrptlon.  Then the
#' length of the vectors z, latxgrlat and latxgrlon is the same.
#' latgrptlat and latgrptlon is on the other hand the coordinates of
#' the rows and columns of the matrix. The program grid makes a list with
#' components with these names. </s-example> <s-example>
#'
#' The functions geolines, geopoint, geopolygon, geotext & geosymbols can be
#' used to add things to the contourplot. </s-example>
#' @seealso \code{\link{geoplot}}, \code{\link{geolines}},
#' \code{\link{geopolygon}}, \code{\link{geotext}}, \code{\link{geosymbols}},
#' \code{\link{geogrid}}, \code{\link{geopar}}, \code{\link{geolocator}},
#' \code{\link{geocontour}}, \code{\link{reitaplott}}, \code{\link{geodefine}}.
#' @examples
#'
#' \dontrun{  ######################################################
#'   # Example 1.                                         #
#'   ######################################################
#'
#'   # Need the data.frame botnv.2004 to be able to compile this
#'   # example, if not attached use:
#'   # >attach("/usr/local/reikn/Splus5/Aflaskyrslur/Data")
#'
#'   codgrd <-list(lat = seq(62, 68, by = 0.1), lon = seq(-30, -9, by = 0.25))
#'   # A grid is made.
#'   lab.loc<-list(lat = c(63.9, 65.6), lon = c(-20.75, -16.5))
#'   # Location of the label.
#'
#'   tmp <- combine.rt(botnv.2004$lat, botnv.2004$lon,
#'                     botnv.2004$torskur, codgrd, fun = "sum", fill = TRUE)
#'   # The data is read into the grid with combine.rt.
#'
#'   tmp$z <- tmp$z/(cos(tmp$lat*pi/180)*0.1*60*0.25*60)
#'   # Data changed.(from being in
#'   # kilos per box to kilos per square mile).
#'
#'   vg <- list(nugget = 0.1, sill = 1, range = 50)
#'   # Parameters for the variogram
#'
#'   z <- pointkriging(tmp$lat, tmp$lon, tmp$z, codgrd, vg,
#'                     maxnumber = 80, maxdist = 30, set = -1)
#'   # Dataset smoothened with pointkriging.
#'
#'   geoplot(lat = c(63, 67.5), lon = c(-27, -11), grid = FALSE, axlabels = TRUE, type = "n")
#'   # Plot initialized
#'   level = c(160, 200, 320, 500, 700, 1000, 2000, 3000, 4000, 5000, 6000)
#'   # Levels for geocontour.fill
#'
#'   geocontour.fill(codgrd, z, levels = level, white = TRUE      # Plot the data.
#'                 , working.space = 300000)
#'
#'   geopolygon(island)
#'   # Contourlines inside Iceland overwritten.
#'   geolines(island)
#'   # Iceland redrawn with geolines.
#'
#'   geocontour.fill(codgrd, z, levels = level, white = TRUE,
#'                   label.location = lab.loc, labels.only = TRUE)
#'   # Call geocontour.fill again only to plot the labels.
#'
#'   #########################################################
#'   # Example 2.                                            #
#'   #########################################################
#'
#'
#'   # Preperation for pointkriging
#'   # th4.2002 is the data used here, dataframe [lon, lat, mat].
#'   # >attach(?????)
#'
#'
#'   grd.smb <-list(lat = seq(62.8, 67.5, length = 80),   # Set up the grid.
#'                  lon = seq(-28, -10, length = 130))
#'   m.lev<-c(0, 0.1, 0.2, 0.3, 0.5)
#'   # Levels for the geocontour.fill.
#'   m.col<-c(0, 14, 59, 104, 119, 149)
#'   # Colors for the levels.
#'   lab.in.island<-list(lat = c(63.9, 65.6), lon = c(-20.75, -16.5))
#'   # Location of the Label
#'
#'   vg <- list(nugget = 0.3, sill = 1, range = 50)
#'   # Initialize variogram parameters.
#'
#'   zfj<-pointkriging(th4.2002$lat, th4.2002$lon, z = th4.2002$mat,
#'                   grd.smb, vg, maxnumber = 80, maxdist = 30, set = -1)
#'   # Smooth the data with pointkriging.
#'
#'   #
#'   # Plotting
#'   #
#'
#'   par(mfrow = c(1, 1),  mai = rep(0, 4))
#'   # Set up graphic parameters.
#'   geoplot(lat = c(63, 67.5), lon = c(-27, -11), grid = FALSE, axlabels = FALSE, type = "n")
#'   # Draw a background with Iceland with geoplot.
#'
#'   geocontour.fill(zfj, levels = m.lev, col = m.col, working.space = 300000)
#'   # Plot the data with geocontour.fill.
#'
#'   geopolygon(gbdypif.500, col = 0, exterior = TRUE, r = 0)
#'   # Remove contours outside gbdypif.500.
#'   geoplot(lat = c(63, 67.5), lon = c(-27, -11), grid = FALSE,          # Replot.
#'           axlabels = FALSE, type = "n", new = TRUE)
#'
#'   geopolygon(island, col = 43)
#'   # Remove contours inside Iceland and color Iceland.
#'   geocontour.fill(zfj, levels = m.lev, label.location = lab.in.island,
#'                   labels.only = TRUE, csi = 0.1, col = m.col, working.space = 300000)
#'   # Call geocontour.fill to plot labels.
#'   geolines(island)
#'   # Redraw the lines of Iceland.
#' }
#' @export geocontour.fill
geocontour.fill <-
  function(
    grd,
    z,
    levels = NULL,
    nlevels = 0,
    cex = 0.7,
    digits = 1,
    col = NULL,
    working.space = 0,
    labels = 1,
    ratio = 1000,
    only.positive = FALSE,
    fill = 0,
    maxcol = 155,
    white = FALSE,
    label.location = 0,
    labels.only = FALSE,
    bordercheck = FALSE,
    maxn = 10000,
    bcrat = 0.05,
    limits = NULL,
    col.names = c("lon", "lat"),
    minsym = "<",
    label.resolution = 0,
    labtxt = NULL,
    boxcol = 0,
    first.color.trans = TRUE,
    mai = c(0, 1, 0, 1),
    leftrat = 0.1,
    labbox = TRUE,
    csi = NULL
  ) {
    geopar <- getOption("geopar")
    if (!is.null(csi)) {
      cex <- cex * csi / 0.12
    } # Compatibility
    if (!is.null(attributes(grd)$grid)) {
      z <- grd
      grd <- attributes(grd)$grid
    }
    set <- NA
    fact <- 2
    grd <- Set.grd.and.z(grd, z, NULL, set, col.names)
    # Set data on correct form.
    z <- grd$z
    # Perturb z a little
    z <- z + rnorm(length(z)) * 1e-09
    grd <- grd$grd
    if (is.null(levels)) {
      # changed before cont < 2
      if (nlevels == 0) {
        nlevels <- 10
      }
      levels <- pretty(range(z, na.rm = TRUE), nlevels)
      levels <- levels[2:(length(levels) - 1)]
    }
    ncont <- length(levels)
    #	Set colors if needed
    if (is.null(col)) {
      if (white) {
        # lowest values white.
        mincol <- 2
        colors <- c(1:(ncont))
        colors <- floor(
          mincol +
            ((colors - 1) *
              (maxcol -
                mincol)) /
              (length(colors) - 1)
        )
        colors <- c(0, colors)
      } else {
        mincol <- 2
        colors <- c(1:(ncont + 1))
        colors <- floor(
          mincol +
            ((colors - 1) *
              (maxcol -
                mincol)) /
              (length(colors) - 1)
        )
      }
    } else {
      colors <- col
    }
    levels.1 <- levels
    colors.1 <- colors
    m <- max(z[!is.na(z)])
    if (!is.null(levels)) {
      i <- c(1:length(levels))
      i <- i[levels > max(z[!is.na(z)])]
      if (length(i) > 0) {
        levels <- levels[-i]
        if (length(colors) > 1) {
          i <- i + 1
          colors <- colors[-i]
        }
      }
    }
    ncont <- nlevels <- length(levels)
    cont <- levels
    # change names of variables
    grd <- extract(grd, z, maxn, limits, col.names = col.names)
    # extract.
    z <- grd$z
    grd <- grd$grd1
    ind <- c(1:length(z))
    ind <- ind[is.na(z)]
    if (length(ind) > 0) {
      if (fill == 0) {
        z[ind] <- -99999
      }
      if (fill == 1) {
        z[ind] <- 0
      }
      if (fill == 2) {
        z[ind] <- mean(z)
      }
    }
    lon <- grd[[col.names[1]]]
    lat <- grd[[col.names[2]]]
    if (only.positive) {
      # put z<0 to 0
      ind <- c(1:length(z))
      ind <- ind[z < mean(z[z > 0]) / 1000 & z != -99999]
      z[ind] <- mean(z[z > 0]) / 1000
    }
    # Check if a setup from geoplot is to be used.
    cond1 <- col.names[1] == "lon" && col.names[2] == "lat"
    cond2 <- col.names[1] == "x" &&
      col.names[2] == "y" &&
      geopar$projection == "none"
    if (cond1 || cond2) {
      oldpar <- selectedpar()
      on.exit(par(oldpar))
      par(geopar$gpar)
      if (geopar$cont) {
        par(plt = geopar$contlines)
      }
    }
    if (cex != 0) {
      par(cex = cex)
    }
    nx <- length(lon)
    ny <- length(lat)
    mcont <- mean(-cont[1:(ncont - 1)] + cont[2:(ncont)])
    lon1 <- matrix(lon, nx, ny)
    lat1 <- t(matrix(lat, ny, nx))
    # Transform the matrices if lat,lon.  Proj only transforms if col.names=0
    if (col.names[1] == "lon" & col.names[2] == "lat") {
      x1 <- Proj(
        lat1,
        lon1,
        geopar$scale,
        geopar$b0,
        geopar$b1,
        geopar$l1,
        geopar$projection,
        col.names
      )
      y1 <- x1$y
      x1 <- x1$x
    } else {
      # no projection.
      x1 <- lon1
      y1 <- lat1
    }
    # Check what is inside borders if given.
    cutreg <- FALSE
    lx <- length(x1)
    x1 <- x1 + rnorm(lx) / 1000000
    inni <- 0
    indd <- c(0, 1, 4, 1, 2, 4, 2, 3, 4, 3, 0, 4)
    cont <- c(cont, max(c(max(abs(cont)) * 1.1, max(z) * 1.1)))
    # change.
    cont <- c(min(c(min(z[z != -99999]) - 1, cont[1] - 1)), cont)
    if (cont[2] - cont[1] < 1) {
      cont[1] <- cont[2] - 1
    }
    ncont <- ncont + 2
    if (!labels.only) {
      zmat <- matrix(z, nx, ny)
      # isoband expects z as (length(y) x length(x)); our grid is lon x lat.
      zmat_iso <- t(zmat)
      x_vec <- lon
      y_vec <- lat
      breaks <- c(min(z, na.rm = TRUE), levels, max(z, na.rm = TRUE))
      bands <- isoband::isobands(
        x_vec,
        y_vec,
        zmat_iso,
        breaks[-length(breaks)],
        breaks[-1]
      )
      for (i in seq_along(bands)) {
        band <- bands[[i]]
        if (length(band$x) == 0) {
          next
        }
        ids <- unique(band$id)
        for (pid in ids) {
          px <- band$x[band$id == pid]
          py <- band$y[band$id == pid]
          if (length(px) < 3) {
            next
          }
          if (
            col.names[1] == "lon" &
              col.names[2] == "lat" &&
              geopar$projection != "none"
          ) {
            pp <- Proj(
              py,
              px,
              geopar$scale,
              geopar$b0,
              geopar$b1,
              geopar$l1,
              geopar$projection,
              col.names
            )
            px <- pp$x
            py <- pp$y
          }
          graphics::polygon(px, py, col = colors[i], border = FALSE)
        }
      }
    }
    # 	Add  labels around plot
    if (length(label.location) == 1) {
      if (label.location == "locator") {
        # use the locator.
        if (cond1 | cond2) {
          label.location <- geolocator(n = 2)
        } else {
          label.location <- locator(n = 2)
        }
      }
    }
    if (length(label.location) > 1) {
      #label located somewhere in drawing
      if (labbox) {
        paint.window(
          Proj(label.location, col.names = col.names),
          border = TRUE,
          col.names = c("y", "x"),
          col = boxcol
        )
      }
      label.location <- Proj(
        label.location,
        scale = geopar$scale,
        b0 = geopar$b0,
        b1 = geopar$b1,
        l1 = geopar$l1,
        projection = geopar$projection,
        col.names = col.names
      )
      if (labels == 1) {
        # labels for each contour line.
        labels1(
          levels.1,
          digits,
          colors.1,
          xlim = label.location$x,
          ylim = label.location$y,
          minsym = minsym,
          label.resolution = label.resolution,
          labtxt = labtxt,
          first.color.trans = first.color.trans,
          mai = mai,
          leftrat = leftrat
        )
      } else {
        #more of a constant label.
        labels2(
          levels.1,
          digits,
          colors.1,
          xlim = label.location$x,
          ylim = label.location$y
        )
      }
    }
    if (geopar$cont && labels != 0) {
      # if labels needed.
      par(plt = geopar$contlab)
      par(new = TRUE)
      plot(
        c(0, 1, 1, 0, 0),
        c(0, 0, 1, 1, 0),
        type = "l",
        axes = FALSE,
        xlab = " ",
        ylab = " "
      )
      if (labels == 1) {
        # labels for each contour line.
        labels1(
          levels.1,
          digits,
          colors.1,
          fill = geopar$cont,
          minsym = minsym,
          label.resolution = label.resolution,
          labtxt = labtxt,
          first.color.trans = first.color.trans,
          mai = mai,
          leftrat = leftrat
        )
      } else {
        #more of a constant label.
        labels2(levels.1, digits, colors.1, fill = geopar$cont)
      }
    }
    return(invisible())
  }

# ---- shadeborder.R ----
#' Shade border ?
#'
#' Shade border ?
#'
#'
#' @param reg Region
#' @param lat Latitude ?
#' @param lon Longitude ?
#' @param col Color, not used ?
#' @param col.names Column names containing coordinates, default \code{lat} and
#' \code{lon}.
#' @return No value, addes shadedborder (with call to \code{\link{lines}}) to
#' contoured geoplot.
#' @note Needs elaboration. Color argument not used, but fixed values given to
#' 2 calls to \code{lines}.
#' @seealso Called by \code{\link{geocontour}}, calls \code{\link{Proj}}.
#' @keywords aplot
#' @export shadeborder
shadeborder <-
  function(reg, lat, lon, col = 0, col.names = c("lon", "lat")) {
    geopar <- getOption("geopar")
    ind <- c(1:length(reg[[col.names[2]]]))
    ind1 <- ind[is.na(reg[[col.names[2]]])]
    if (length(ind1) == 0 || ind1[1] != 1) {
      #external border does not begin with NA
      if (length(ind1) < 1) {
        ind2 <- length(reg[[col.names[2]]])
      } else {
        ind2 <- ind1[1] - 1
      }
      reg.lat <- reg[[col.names[2]]][1:ind2]
      reg.lon <- reg[[col.names[1]]][1:ind2]
      lonx <- c(min(lon), min(lon), max(lon), max(lon), min(lon), min(lon))
      latx <- c(mean(lat), min(lat), min(lat), max(lat), max(lat), mean(lat))
      ind2 <- ind[reg.lon == min(reg.lon)][1]
      ind3 <- ind[reg.lon == max(reg.lon)][1]
      ind6 <- ind[reg.lat == min(reg.lat)][1]
      ind7 <- ind[reg.lat == max(reg.lat)][1]
      i <- 0
      if (ind6 > ind2) {
        i <- i + 1
      }
      if (ind3 > ind6) {
        i <- i + 1
      }
      if (ind7 > ind3) {
        i <- i + 1
      }
      if (ind2 > ind7) {
        i <- i + 1
      }
      if (i > 1) {
        ccw <- T
      } else {
        ccw <- F
      }
      if (ccw) {
        #counterclockwise
        if (ind3 > ind2) {
          ind4 <- c(ind3:ind2)
          ind5 <- c(ind3:length(reg.lat), 1:ind2)
        } else {
          ind4 <- c(ind3:1, length(reg.lat):ind2)
          ind5 <- c(ind3:ind2)
        }
      } else {
        #clockwise
        if (ind3 > ind2) {
          ind4 <- c(ind3:length(reg.lat), 1:ind2)
          ind5 <- c(ind3:ind2)
        } else {
          ind4 <- c(ind3:ind2)
          ind5 <- c(ind3:1, length(reg.lat):ind2)
        }
      }
      mil <- min(min(lon), min(reg.lon) - 1)
      mal <- max(max(lon), max(reg.lon) + 1)
      rlat <- c(mean(lat), min(lat), min(lat), mean(lat))
      rlon <- c(mil, mil, mal, mal)
      rlon <- c(reg.lon[ind4], rlon)
      rlat <- c(reg.lat[ind4], rlat)
      rx <- Proj(
        rlat,
        rlon,
        geopar$scale,
        geopar$b0,
        geopar$b1,
        geopar$l1,
        geopar$projection,
        col.names = col.names
      )
      lines(rx, lwd = 2)
      #    polygon(rx$x, rx$y, border = F, col = col)
      rlat <- c(mean(lat), max(lat), max(lat), mean(lat))
      rlon <- c(mil, mil, mal, mal)
      rlon <- c(reg.lon[ind5], rlon)
      rlat <- c(reg.lat[ind5], rlat)
      rx <- Proj(
        rlat,
        rlon,
        geopar$scale,
        geopar$b0,
        geopar$b1,
        geopar$l1,
        geopar$projection,
        col.names = col.names
      )
      lines(rx, lwd = 2, col = 70)
      #    polygon(rx$x, rx$y, border = F, col = col)
      if (length(ind1) > 0) {
        if (geopar$projection == "none") {
          if (length(reg$x) - ind1[length(ind1)] < 3) {
            return(invisible())
          }
          reg$x <- reg$x[(ind1[1] + 1):length(reg$x)]
          reg$y <- reg$y[(ind1[1] + 1):length(reg$y)]
        } else {
          if (
            length(reg[[col.names[2]]]) -
              ind1[length(
                ind1
              )] <
              3
          ) {
            return(invisible())
          }
          reg[[col.names[2]]] <- reg[[col.names[2]]][
            (ind1[1] + 1):length(reg[[col.names[
              2
            ]]])
          ]
          reg[[col.names[1]]] <- reg[[col.names[1]]][
            (ind1[1] + 1):length(reg[[col.names[
              1
            ]]])
          ]
        }
        rx <- Proj(
          reg,
          scale = geopar$scale,
          b0 = geopar$b0,
          b1 = geopar$b1,
          l1 = geopar$l1,
          projection = geopar$projection,
          col.names = col.names
        )
        lines(rx, lwd = 2, col = 2)
      }
    } else {
      rx <- Proj(
        reg,
        scale = geopar$scale,
        b0 = geopar$b0,
        b1 = geopar$b1,
        l1 = geopar$l1,
        projection = geopar$projection,
        col.names
      )
      lines(rx, lwd = 2, col = 150)
    }
  }

# ---- shading1.R ----
#' Shading of geoplots?
#'
#' Shading of geoplots?
#'
#'
#' @param cont Contours?
#' @param digits Number of digits?
#' @param colors Colors?
#' @param xlim,ylim Limits?
#' @param fill Fill?
#' @param angle Angle?
#' @param rotate Rotate?
#' @param cex Character expansion?
#' @param rat Ratio?
#' @param minsym Minimum symbol on label?
#' @return No value, shades current geoplot (label?) in some way?
#' @note Needs elaboration.
#' @seealso Called by \code{\link{colsymbol}} and \code{\link{reitaplott}}.
#' @keywords aplot
#' @export shading1
shading1 <-
  function(
    cont,
    digits,
    colors,
    xlim = c(0, 1),
    ylim = c(0, 1),
    fill = F,
    angle,
    rotate,
    cex,
    rat,
    minsym = "<"
  ) {
    xlim <- sort(xlim)
    ylim <- sort(ylim)
    if (cex != 0) {
      par(cex = cex)
    }
    ncont <- length(cont)
    if (fill) {
      lbox <- max(ncont + 1, 20)
    } else {
      lbox <- ncont + 1
    }
    boxy <- c(1:lbox)
    boxy <- -boxy / lbox + 1
    boxy1 <- boxy + 1 / (1.2 * lbox)
    if (fill) {
      boxy <- boxy[1:(ncont + 1)]
      boxy1 <- boxy1[1:(ncont + 1)]
    }
    ymat <- matrix(0, 5, length(boxy))
    ymat[1, ] <- boxy
    ymat[2, ] <- boxy
    ymat[3, ] <- boxy1
    ymat[4, ] <- boxy1
    ymat[5, ] <- NA
    xmat <- matrix(0, 5, length(boxy))
    xmat[1, ] <- 0.75
    xmat[2, ] <- 0.97
    xmat[3, ] <- 0.97
    xmat[4, ] <- 0.75
    xmat[5, ] <- NA
    #       put  text in figure
    par(adj = 0)
    cont <- round(cont, digits = digits)
    textx <- c(1:(length(cont) - 1))
    textx1 <- textx
    textx <- as.character(round(cont[1:(length(cont) - 1)], digits = digits))
    textx1 <- as.character(round(cont[2:length(cont)], digits = digits))
    textx <- paste(textx, "-", textx1)
    minsym <- paste(minsym, " ", sep = "")
    textx <- c(
      paste(minsym, as.character(round(cont[1], digits = digits))),
      textx
    )
    textx[ncont + 1] <- paste(
      "> ",
      as.character(round(cont[ncont], digits = digits))
    )
    boxx <- c(matrix(0.1, 1, length(boxy)))
    boxx <- xlim[1] + (xlim[2] - xlim[1]) * boxx
    boxy <- ylim[1] + (ylim[2] - ylim[1]) * boxy
    ll <- (ylim[2] - ylim[1]) * 0.05
    if (fill) {
      text(boxx, boxy + ll / 2, textx)
    } else {
      text(boxx, boxy + ll, textx)
    }
    xmat <- xlim[1] + (xlim[2] - xlim[1]) * xmat
    ymat <- ylim[1] + (ylim[2] - ylim[1]) * ymat
    for (i in 1:length(colors)) {
      polygon(
        xmat[1:4, i],
        ymat[1:4, i],
        border = T,
        density = colors[i],
        angle = angle
      )
      angle <- angle + rotate
    }
  }

# ---- fill.matrix.R ----
#' Relace elements of a matrix
#'
#' Replace (fill) elements of a matrix (or data.frame) with a value for given
#' pairs of row and column indices.
#'
#'
#' @param outcome Input matrix/data.frame
#' @param x Value or values to replace/fill with
#' @param rownr Row index/indices
#' @param dalknr Column index/indices
#' @return Matrix or data.frame with given values replaced.
#' @note Probably redundant, not called by any geo-function, the same effect
#' could be achieved with an assignment to a matrix with an index-matrix of the
#' values in rownr and dalknr: \code{mat[matrix(c(rownr, dalknr), ncol = 2)] <-
#' x}
#' @keywords manip
#' @export fill.matrix
fill.matrix <-
  function(outcome, x, rownr, dalknr) {
    ind <- nrow(outcome) * (dalknr - 1) + rownr
    outcome[ind] <- x
    return(outcome)
  }

# ---- fill.points.R ----
#' Fill points (thicken)
#'
#' Fill points (thicken) for drawing continous lines in Lambert projection.
#'
#'
#' @param x,y Coordinates
#' @param nx Thickening factor
#' @param option Deals with NAs in the coordinates when not 1, the default
#' @return List of thickened values with components: \item{x, y}{of
#' coordinates}
#' @note Internal, needs elaboration.
#' @seealso The function is called by \code{\link{geopolygon}},
#' \code{\link{geolines}}, \code{\link{reitaplott}} and
#' \code{\link{gridaxes.Lambert}}
#' @keywords manip
#' @export fill.points
fill.points <-
  function(x, y, nx, option = 1) {
    n <- length(x)
    ny <- nx
    if (option != 1) {
      naind <- c(1:length(x))
      naind <- naind[is.na(x)]
    }
    dx <- (x[2:n] - x[1:(n - 1)]) / (ny)
    dy <- (y[2:n] - y[1:(n - 1)]) / (ny)
    x1 <- matrix(x[1:(n - 1)], n - 1, nx)
    y1 <- matrix(y[1:(n - 1)], n - 1, nx)
    ind <- c(0:(nx - 1))
    ind <- matrix(ind, n - 1, nx, byrow = T)
    dx <- matrix(dx, n - 1, nx)
    dy <- matrix(dy, n - 1, nx)
    x1 <- t(x1 + ind * dx)
    y1 <- t(y1 + ind * dy)
    ind <- c(1:length(y1))
    ind <- ind[is.na(y1) & row(y1) != 1]
    if (length(ind) != 0) {
      x1 <- x1[-ind]
      y1 <- y1[-ind]
    }
    if (is.na(x1[length(x1)])) {
      x1 <- c(x1, NA)
      y1 <- c(y1, NA)
    }
    ind <- c(1:length(x1))
    ind <- ind[is.na(x1)]
    if (length(ind) > 0) {
      ind <- matrix(ind, , 2, byrow = T)
      if (option == 1) {
        ind <- ind[, 1]
        x1 <- x1[-ind]
        y1 <- y1[-ind]
      } else {
        ind <- ind[, 1]
        x1[ind] <- x[naind - 1]
        y1[ind] <- y[naind - 1]
      }
    }
    if (option != 1) {
      x1 <- c(x1, x[n])
      y1 <- c(y1, y[n])
    }
    return(list(x = x1, y = y1))
  }

# ---- fill.outside.border.R ----
#' Fills space outside the border of a plot.
#'
#' When programs like geopolygon are used they sometimes fills space outside
#' the border of their plots, to refill that space white we use
#' fill.outside.border.
#'
#'
#' @param col The color of the fill, default is 0 (usually white).
#' @param rat Ratio between the size of the current plot and the size of the
#' fill, if you want to allow the program to draw 5\% outside the plot you set
#' rat =1.05.  Default rat = 1.
#' @return No Value.
#' @section Side Effects: Fill outside of the border of the current plot.
#' @seealso \code{\link{geoworld}}, \code{\link{geopolygon}}.
#' @keywords <!--Put one or more s-keyword tags here-->
#' @examples
#'
#'        \dontrun{
#' 	geoplot(xlim=c(-50,20),ylim=c(50,70))       # Initialize plot.
#'        geoworld(fill=T,color=120)                  # Colour countries.
#'        fill.outside.border()                       # Clear outside of border.
#'        geoplot(xlim=c(-50,20),ylim=c(50,70),new=T) # Relabel.
#' }
#' @export fill.outside.border
fill.outside.border <-
  function(col = 0, rat = 1) {
    geopar <- getOption("geopar")
    gx <- geopar$limx
    gy <- geopar$limy
    gx <- mean(gx) + rat * (gx - mean(gx))
    gy <- mean(gy) + rat * (gy - mean(gy))
    dx <- gx[2] - gx[1]
    dy <- gy[2] - gy[1]
    x1 <- gx[1] - dx
    x2 <- gx[2] + dx
    y1 <- gy[1] - dy
    y2 <- gy[2] + dy
    b1 <- list(
      x = c(x1, x2, x2, x1, x1),
      y = c(
        gy[2],
        gy[2],
        y2,
        y2,
        gy[
          2
        ]
      )
    )
    b2 <- list(
      x = c(x1, x2, x2, x1, x1),
      y = c(
        gy[1],
        gy[1],
        y1,
        y1,
        gy[
          1
        ]
      )
    )
    b3 <- list(
      x = c(gx[2], x2, x2, gx[2], gx[2]),
      y = c(gy[1], gy[1], gy[2], gy[2], gy[1])
    )
    b4 <- list(
      x = c(gx[1], x1, x1, gx[1], gx[1]),
      y = c(gy[1], gy[1], gy[2], gy[2], gy[1])
    )
    oldpar <- selectedpar()
    par(geopar$gpar)
    polygon(b1, col = 0)
    polygon(b2, col = 0)
    polygon(b3, col = 0)
    polygon(b4, col = 0)
    par(oldpar)
    return(invisible())
  }

# ---- paint.window.R ----
#' Paint window for label?
#'
#' Paint window for label based on lat and lon?.
#'
#'
#' @param listi Label location ?
#' @param col Color, not used ?
#' @param border Should border be drawn?
#' @param poly Should label be opaque ?
#' @param col.names Column names containing label coordinates ?
#' @return No value, lines and/or polygon added to current geoplot.
#' @note Needs elaboration and possibly merging with paint.window doc-file.
#' Argument \code{col} has no effect.
#' @seealso Called by \code{\link{colsymbol}}, \code{\link{geocontour}},
#' \code{\link{geocontour.fill}}, \code{\link{geosymbols}} and
#' \code{\link{reitaplott}}; calls \code{\link{Proj}}.
#' @keywords aplot
#' @export paint.window
paint.window <-
  function(listi, col = 0, border = T, poly = T, col.names = c("lon", "lat")) {
    geopar <- getOption("geopar")
    lat <- c(
      listi[[col.names[2]]][1],
      listi[[col.names[2]]][1],
      listi[[
        col.names[2]
      ]][2],
      listi[[col.names[2]]][2],
      listi[[col.names[
        2
      ]]][1]
    )
    lon <- c(
      listi[[col.names[1]]][1],
      listi[[col.names[1]]][2],
      listi[[
        col.names[1]
      ]][2],
      listi[[col.names[1]]][1],
      listi[[col.names[
        1
      ]]][1]
    )
    x <- Proj(
      lat,
      lon,
      geopar$scale,
      geopar$b0,
      geopar$b1,
      geopar$l1,
      geopar$projection,
      col.names = col.names
    )
    paint_window_impl(
      x$x,
      x$y,
      border = border,
      poly = poly,
      border_first = FALSE
    )
  }

paint_window_impl <-
  function(x, y, border = T, poly = T, border_first = FALSE) {
    rx <- range(x)
    ry <- range(y)
    t1 <- c(rx[1], rx[2], rx[2], rx[1], rx[1])
    t2 <- c(ry[1], ry[1], ry[2], ry[2], ry[1])
    if (border && border_first) {
      mx <- mean(t1[1:4])
      my <- mean(t2[1:4])
      t11 <- t1 + 0.02 * (t1 - mx)
      t22 <- t2 + 0.02 * (t2 - my)
      lines(t11, t22, lwd = 1.5, col = 1)
    }
    if (poly) {
      polygon(t1, t2, col = 0)
    }
    if (border && !border_first) {
      mx <- mean(t1[1:4])
      my <- mean(t2[1:4])
      t11 <- t1 + 0.02 * (t1 - mx)
      t22 <- t2 + 0.02 * (t2 - my)
      lines(t11, t22, lwd = 1.5, col = 1)
    }
  }

# ---- paint.window.x.R ----
#' Paint window for label ?
#'
#' Paint window for label based on projected coordinates?.
#'
#'
#' @param listi Label location ?
#' @param col Color, not used ?
#' @param border Should border be drawn?
#' @param poly Should label be opaque ?
#' @return No value, lines and/or polygon for label added to current geoplot.
#' @note Needs elaboration and possibly merging with paint.window doc-file.
#' Argument \code{col} has no effect.
#' @seealso Called by \code{\link{geocontour}}.
#' @keywords aplot
#' @export paint.window.x
paint.window.x <-
  function(listi, col = 0., border = T, poly = T) {
    x <- c(listi$x[1.], listi$x[2.], listi$x[2.], listi$x[1.], listi$x[1.])
    y <- c(listi$y[1.], listi$y[1.], listi$y[2.], listi$y[2.], listi$y[1.])
    paint_window_impl(x, y, border = border, poly = poly, border_first = TRUE)
  }
