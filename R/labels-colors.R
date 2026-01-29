# Auto-generated grouping file: labels-colors.R
# Original function definitions were moved here for maintainability.

# ---- labels1.R ----
#' Label plots
#'
#' Label plots with categories.
#'
#'
#' @param cont Contour ?
#' @param digits Number of digits to use in labels
#' @param colors Colors ?
#' @param xlim,ylim Limits ?
#' @param fill Fill with colors?
#' @param minsym Minimum symbol (for lowest category?)?
#' @param label.resolution Label resolution ?
#' @param labtxt Label text ?
#' @param first.color.trans Should first color be transparent? Default TRUE
#' @param mai Margins in inches?
#' @param leftrat Left ratio (giving space for labels??)??
#' @return No value, labels added to current plot.
#' @note Needs elaboration, merge documentation with \code{labels2}, and
#' possibly others?
#' @seealso Called by \code{\link{colsymbol}}, \code{\link{geocontour.fill}}
#' and \code{\link{reitaplott}}.
#' @keywords aplot
#' @export labels1
labels1 <-
  function(
    cont,
    digits,
    colors,
    xlim = c(0, 1),
    ylim = c(0, 1),
    fill = F,
    minsym = "<",
    label.resolution = 0,
    labtxt = NULL,
    first.color.trans = T,
    mai = c(0, 1, 0, 1),
    leftrat = 0.1
  ) {
    labels_impl(
      cont,
      digits,
      colors,
      xlim = xlim,
      ylim = ylim,
      fill = fill,
      minsym = minsym,
      label.resolution = label.resolution,
      labtxt = labtxt,
      first.color.trans = first.color.trans,
      mai = mai,
      leftrat = leftrat,
      mode = "labels1"
    )
  }

# ---- labels2.R ----
#' Label plots
#'
#' Label plots with categories.
#'
#'
#' @param cont Contour ?
#' @param digits Number of digits to use in labels
#' @param colors Colors ?
#' @param xlim,ylim Limits ?
#' @param nx ??. Default 4
#' @param fill Fill ?
#' @return No value, labels added to current plot.
#' @note Needs elaboration, merge documentation with \code{labels1}, and
#' possibly others?
#' @seealso alled by \code{\link{colsymbol}} and \code{\link{geocontour.fill}}.
#' @keywords aplot
#' @export labels2
labels2 <-
  function(
    cont,
    digits,
    colors,
    xlim = c(0, 1),
    ylim = c(0, 1),
    nx = 4,
    fill = F
  ) {
    labels_impl(
      cont,
      digits,
      colors,
      xlim = xlim,
      ylim = ylim,
      nx = nx,
      fill = fill,
      mode = "labels2"
    )
  }

labels_impl <-
  function(
    cont,
    digits,
    colors,
    xlim = c(0, 1),
    ylim = c(0, 1),
    fill = F,
    minsym = "<",
    label.resolution = 0,
    labtxt = NULL,
    first.color.trans = T,
    mai = c(0, 1, 0, 1),
    leftrat = 0.1,
    nx = 4,
    mode = "labels1"
  ) {
    xlim <- sort(xlim)
    ylim <- sort(ylim)
    if (mode == "labels1") {
      dx <- (xlim[2] - xlim[1])
      dy <- (ylim[2] - ylim[1])
      xlim[2] <- xlim[1] + mai[2] * dx
      xlim[1] <- xlim[1] + mai[1] * dx
      ylim[2] <- ylim[1] + mai[4] * dy
      ylim[1] <- ylim[1] + mai[3] * dy
      ncont <- length(cont)
      if (label.resolution == "none") {
        lbox <- ncont
      } else {
        lbox <- ncont + 1
      }
      if (fill) {
        lbox <- max(lbox, 20)
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
      xmat[1, ] <- 0.7
      xmat[2, ] <- 0.95
      xmat[3, ] <- 0.95
      xmat[4, ] <- 0.7
      xmat[5, ] <- NA
      #	put  text in figure
      par(adj = 0)
      cont <- round(cont, digits = digits)
      if (!(label.resolution == "none")) {
        textx <- c(1:(length(cont) - 1))
        textx1 <- textx
        textx <- format(round(
          cont[1:(length(cont) - 1)] +
            label.resolution,
          digits = digits
        ))
        textx1 <- format(round(cont[2:length(cont)], digits = digits))
        textx <- paste(textx, "-", textx1)
        tmp1 <- paste(minsym, format(round(cont[1], digits = digits)))
        tmp2 <- paste(">", format(round(cont[ncont], digits = digits)))
        textx <- c(tmp1, textx, tmp2)
      } else {
        print(cont)
        textx <- c(1:length(cont))
        testx <- format(round(cont), digits = digits)
      }
      print(1)
      boxx <- c(matrix(leftrat, 1, length(boxy)))
      boxx <- xlim[1] + abs((xlim[2] - xlim[1])) * boxx
      boxy <- ylim[1] + (ylim[2] - ylim[1]) * boxy
      ll <- (ylim[2] - ylim[1]) * 0.05
      if (!is.null(labtxt)) {
        textx <- labtxt
      }
      # put the labels.
      if (fill) {
        text(boxx, boxy + ll / 2, textx)
      } else {
        text(boxx, boxy + ll, textx)
      }
      # put the labels.
      xmat <- xlim[1] + abs((xlim[2] - xlim[1])) * xmat
      ymat <- ylim[1] + (ylim[2] - ylim[1]) * ymat
      if (label.resolution == "none") {
        colors <- colors[2:length(colors)]
      }
      polygon(xmat, ymat, border = T, col = colors)
      if (colors[1] == 0 || first.color.trans) {
        xmat <- c(xmat[1:4], xmat[1])
        # if white color.
        ymat <- c(ymat[1:4], ymat[1])
        lines(xmat, ymat)
      }
      return(invisible())
    }
    ncont <- length(cont)
    lbox <- ncont + 1
    if (fill) {
      lbox <- max(lbox, 20)
    }
    boxy <- c(1:lbox)
    boxy <- -boxy / (lbox + 2) + 1
    dy <- 1 / lbox
    boxy <- boxy - dy / 2
    boxy1 <- boxy + 1 / lbox
    ymat <- matrix(0, 5, length(boxy))
    ymat[1, ] <- boxy
    ymat[2, ] <- boxy
    ymat[3, ] <- boxy1
    ymat[4, ] <- boxy1
    ymat[5, ] <- NA
    xmat <- matrix(0, 5, length(boxy))
    xmat[1, ] <- 0.6
    xmat[2, ] <- 0.9
    xmat[3, ] <- 0.9
    xmat[4, ] <- 0.6
    xmat[5, ] <- NA
    #	put  text in figure
    ind <- c(1, c(1:floor((length(cont)) / nx)) * nx)
    if (ind[length(ind)] == (length(cont))) {
      ind <- c(ind, (length(cont)))
    }
    par(adj = 0)
    cont <- round(cont, digits = digits)
    textx <- format(round(cont[ind], digits = digits))
    boxx <- c(matrix(0.1, 1, length(boxy)))
    boxx <- xlim[1] + (xlim[2] - xlim[1]) * boxx
    boxy <- ylim[1] + (ylim[2] - ylim[1]) * boxy
    text(boxx[ind], boxy[ind], textx)
    # put the lables.
    xmat <- xlim[1] + abs((xlim[2] - xlim[1])) * xmat
    ymat <- ylim[1] + (ylim[2] - ylim[1]) * ymat
    polygon(xmat, ymat, border = F, col = colors)
    if (colors[1] == 0) {
      xmat <- c(xmat[1:4], xmat[1])
      # if white color.
      ymat <- c(ymat[1:4], ymat[1])
      lines(xmat, ymat)
    }
  }

# ---- labels_line.R ----
#' Labels line ?
#'
#' Labels line ?.
#'
#'
#' @param cont Contours?
#' @param digits Number of digits
#' @param colors Colors
#' @param lty Line types
#' @param lwd Line widths
#' @param xlim,ylim Limit
#' @param linew Linewidth for some reason not lwd?
#' @return No value, labels added to current plot.
#' @note Needs elaboration, possibly merge documentation with others label
#' functions?
#' @seealso Called by \code{\link{geocontour}}.
#' @keywords aplot
#' @export labels_line
labels_line <-
  function(
    cont,
    digits,
    colors,
    lty,
    lwd,
    xlim = c(0, 1),
    ylim = c(0, 1),
    linew = F
  ) {
    xlim <- sort(xlim)
    ylim <- sort(ylim)
    ncont <- length(cont)
    if (length(lty) == ncont) {
      linetypes <- T
    } else {
      linetypes <- F
    }
    lbox <- ncont
    boxy <- c(1:lbox)
    boxy <- -boxy / (lbox + 1) + 1
    boxy1 <- boxy + 1 / (1.2 * lbox)
    ymat <- matrix(0, 2, length(boxy))
    ymat[1, ] <- boxy
    ymat[2, ] <- boxy
    xmat <- matrix(0, 2, length(boxy))
    xmat[1, ] <- 0.7
    xmat[2, ] <- 0.95
    #	put  text in figure
    par(adj = 0)
    cont <- round(cont, digits = digits)
    textx <- format(cont)
    boxx <- c(matrix(0.1, 1, length(boxy)))
    boxx <- xlim[1] + abs((xlim[2] - xlim[1])) * boxx
    boxy <- ylim[1] + (ylim[2] - ylim[1]) * boxy
    ll <- (ylim[2] - ylim[1]) * 0.04
    text(boxx, boxy + ll, textx, col = 1)
    # put the lables.
    xmat <- xlim[1] + abs((xlim[2] - xlim[1])) * xmat
    ymat <- ylim[1] + (ylim[2] - ylim[1]) * ymat
    for (i in 1:ncont) {
      if (linew) {
        par(lwd = lwd[i])
      }
      if (linetypes) {
        par(lty = lty[i])
      }
      lines(xmat[, i], ymat[, i] + ll, col = colors[i])
    }
  }

# ---- labels_size.R ----
#' Label symbols of given size
#'
#' Labels of given size.
#'
#'
#' @param cont Contours
#' @param digits Number of digits to use in labels
#' @param sizes Sizes (of what?)?
#' @param xlim,ylim Limits
#' @param fill Fill? Default FALSE
#' @param n Number of ??
#' @param rat Ratio of ??
#' @param minsym Minimum symbol for lowest category in labels
#' @param label.resolution Label resolution ?
#' @param open Open legend/label, default FALSE
#' @param lwd Line width
#' @param col Color
#' @return No value, labels added to current plot.
#' @note Needs further elaboration, document with other labelling functions??
#' @seealso Called by \code{\link{colsymbol}}.
#' @keywords aplot
#' @export labels_size
labels_size <-
  function(
    cont,
    digits,
    sizes,
    xlim = c(0, 1),
    ylim = c(0, 1),
    fill = F,
    n,
    rat,
    minsym = "<",
    label.resolution = 0,
    open = F,
    lwd = 1,
    col = 1
  ) {
    xlim <- sort(xlim)
    ylim <- sort(ylim)
    ncont <- length(cont)
    lbox <- ncont + 1
    if (fill) {
      lbox <- max(lbox, 20)
    }
    boxy <- c(1:lbox)
    boxy <- -boxy / lbox + 1
    boxy1 <- boxy + 1 / (1.2 * lbox)
    if (fill) {
      boxy <- boxy[1:(ncont + 1)]
      boxy1 <- boxy1[1:(ncont + 1)]
    }
    yloc <- (boxy + boxy1) / 2
    xloc <- matrix(0.85, length(yloc))
    theta <- (c(0:n) * 2 * pi) / n
    theta <- c(theta, NA)
    theta <- c(matrix(theta, n + 2, length(yloc)))
    par(adj = 0)
    cont <- round(cont, digits = digits)
    textx <- c(1:(length(cont) - 1))
    textx1 <- textx
    textx <- format(round(
      cont[1:(length(cont) - 1)] + label.resolution,
      digits = digits
    ))
    textx1 <- format(round(cont[2:length(cont)], digits = digits))
    textx <- paste(textx, "-", textx1)
    minsym <- paste(minsym, " ", sep = "")
    tmp1 <- paste(minsym, format(round(cont[1], digits = digits)))
    tmp2 <- paste("> ", format(round(cont[ncont], digits = digits)))
    textx <- c(tmp1, textx, tmp2)
    boxx <- c(matrix(0.1, 1, length(boxy)))
    boxx <- xlim[1] + abs((xlim[2] - xlim[1])) * boxx
    xloc <- xlim[1] + abs((xlim[2] - xlim[1])) * xloc
    yloc <- ylim[1] + abs((ylim[2] - ylim[1])) * yloc
    boxy <- ylim[1] + (ylim[2] - ylim[1]) * boxy
    ll <- (ylim[2] - ylim[1]) * 0.05
    # put the labels.
    if (fill) {
      text(boxx, boxy + ll / 2, textx)
    } else {
      text(boxx, boxy + ll, textx)
    }
    # put the labels.
    theta <- (c(0:n) * 2 * pi) / n
    theta <- c(theta, NA)
    theta <- c(matrix(theta, n + 2, length(boxy)))
    y <- c(t(matrix(yloc, length(yloc), n + 2)))
    x <- c(t(matrix(xloc, length(xloc), n + 2)))
    sizes <- c(t(matrix(sizes, length(boxx), n + 2)))
    y <- y + sizes * rat * sin(theta)
    x <- x + sizes * rat * cos(theta)
    if (!open) {
      polygon(x, y, col = col, border = T)
    } else {
      lines(x, y, col = col, lwd = lwd)
    }
  }

# ---- colsymbol.R ----
#' Plot colored symbols
#'
#' Adds colored symbols in a variety of shapes to a geo-plot.
#'
#'
#' @param lat Latitude
#' @param lon Longitude
#' @param z Value
#' @param circles If not zero, use circles of this size.
#' @param squares If not zero, use circles of this size
#' @param rectangles If not zero, use circles of this size
#' @param hbars If not zero, use circles of this size
#' @param vbars If not zero, use circles of this size
#' @param perbars If not zero, use circles of this size
#' @param parbars If not zero, use circles of this size
#' @param levels Levels used for determining symbols size
#' @param nlevels Number of levels
#' @param colors Colors to use
#' @param white Logical, use white for lowest level if TRUE
#' @param n Number of points used to make a circle (?)
#' @param maxcol maxcolor?
#' @param digits ??
#' @param label.location Where to put legend
#' @param labels Labels for legend
#' @param fill.circles Should circles be filled?
#' @param density Density of shading when applicable
#' @param angle Slant of shading
#' @param rotate Should text (??) be rotated?
#' @param minsym minimum value for a symbol to be drawn?
#' @param label.resolution Number of digits in label???
#' @param col Colors to use
#' @param labels.only TRUE when labels/legend is added in a sperate call
#' @param open.circles Should circles be open??
#' @param lwd Line width of symbols
#' @param border Should a border be drawn on the symbol
#' @param bordercol Color for border if drawn
#' @return No value returned, utility lies in side effect off adding colored
#' symbols to existing plot, generally used as internal function in geosymbols.
#' @note Needs further elaboration, see documentation for \code{geosymbols}.
#' @seealso Called by \code{\link{geosymbols}}, calls \code{\link{Proj}},
#' \code{\link{geolocator}}, \code{\link{labels_size}}, \code{\link{labels1}},
#' \code{\link{labels2}}, \code{\link{shading1}}, \code{\link{paint.window}}
#' @keywords aplot
#' @export colsymbol
colsymbol <-
  function(
    lat,
    lon,
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
    minsym = "<",
    label.resolution = 0,
    col = 1,
    labels.only = F,
    open.circles,
    lwd,
    border = F,
    bordercol = 0
  ) {
    geopar <- getOption("geopar")
    cont <- levels
    ncont <- nlevels
    z <- z + 1e-07
    # because of zeros.
    if (length(cont) == 1 && cont[1] == -99999) {
      if (ncont == 0) {
        ncont <- 10
      }
      cont <- pretty(c(min(z), max(z)), ncont)
      cont <- cont[2:(length(cont) - 1)]
    }
    ncont <- length(cont)
    mcont <- mean(-cont[1:(ncont - 1)] + cont[2:(ncont)])
    cont1 <- cont
    cont <- c(cont, max(z) + mcont * 5)
    cont <- c(min(z) - mcont * 5, cont)
    if (cont[1] >= cont[2]) {
      cont[1] <- cont[2] - 1
    }
    if (cont[ncont + 2] <= cont[ncont + 1]) {
      cont[ncont + 2] <- cont[ncont + 1] + 1
    }
    ncont <- ncont + 2
    #	Set colors if needed
    if (length(colors) < 2) {
      if (fill.circles || open.circles) {
        # different size of circles filled
        colors <- c(1:(ncont - 1))
        if (maxcol > 3) {
          maxcol <- 0.1
        }
        colors <- (colors * maxcol) / (ncont - 1)
      } else {
        if (density > 0 && maxcol > 70) {
          maxcol <- 70
        }
        if (density > 0) {
          mincol <- 8
        } else {
          mincol <- 2
        }
        if (white) {
          # lowest values white.
          colors <- c(1:(ncont - 2))
          colors <- floor(
            mincol +
              ((colors - 1) * (maxcol - mincol)) /
                (length(colors) -
                  1)
          )
          colors <- c(0, colors)
        } else {
          colors <- c(1:(ncont - 1))
          colors <- floor(
            mincol +
              ((colors - 1) * (maxcol - mincol)) /
                (length(colors) -
                  1)
          )
        }
      }
    }
    #	Define color for each point.
    ind <- cut(z, cont, labels = FALSE) # labels=FALSE R ver.
    ind <- colors[ind]
    # number of color.
    ein.pr.in <- (geopar$limy[2] - geopar$limy[1]) / geopar$gpar$pin[2]
    if (fill.circles || open.circles) {
      # different sizes of circles
      theta <- (c(0:n) * 2 * pi) / n
      theta <- c(theta, NA)
      x <- Proj(
        lat,
        lon,
        geopar$scale,
        geopar$b0,
        geopar$b1,
        geopar$l1,
        geopar$projection
      )
      theta <- c(matrix(theta, n + 2, length(z)))
      y <- c(t(matrix(x$y, length(lat), n + 2)))
      x <- c(t(matrix(x$x, length(lon), n + 2)))
      ind1 <- c(t(matrix(ind, length(lon), n + 2)))
      y <- y + ein.pr.in * ind1 * sin(theta)
      x <- x + ein.pr.in * ind1 * cos(theta)
      if (!labels.only) {
        if (fill.circles) {
          polygon(x, y, col = col, border = F)
          if (border) {
            lines(x, y, col = bordercol)
          }
        }
        if (open.circles) {
          lines(x, y, lwd = lwd, col = col)
        }
      }
    }
    if (circles != 0 && !fill.circles) {
      if ((circles > 100) | (circles < 0)) {
        circles <- 0.05
      }
      #default value.
      circles <- ein.pr.in * circles
      theta <- (c(0:n) * 2 * pi) / n
      theta <- c(theta, NA)
      theta <- c(matrix(theta, n + 2, length(z)))
      x <- Proj(
        lat,
        lon,
        geopar$scale,
        geopar$b0,
        geopar$b1,
        geopar$l1,
        geopar$projection
      )
      if (density > 0) {
        angle1 <- angle
        theta <- (c(0:n) * 2 * pi) / n
        for (i in 1:length(ind)) {
          angle1 <- angle1 + rotate
          y1 <- c(matrix(x$y[i], 1, n + 1))
          x1 <- c(matrix(x$x[i], 1, n + 1))
          x1 <- x1 + circles * cos(theta)
          y1 <- y1 + circles * sin(theta)
          if (!labels.only) {
            polygon(
              x1,
              y1,
              density = ind[i],
              border = F,
              angle = angle1,
              col = col
            )
            if (border && ind[i] == 0) {
              lines(x1, y1, col = 1)
            }
          }
        }
      } else {
        y <- c(t(matrix(x$y, length(lat), n + 2)))
        x <- c(t(matrix(x$x, length(lon), n + 2)))
        y <- y + circles * sin(theta)
        x <- x + circles * cos(theta)
        if (!labels.only) {
          polygon(x, y, col = ind, border = F)
          if (border) {
            lines(x, y, col = 1)
          }
        }
      }
    }
    if (squares != 0 && !fill.circles) {
      if ((squares > 100) | (squares < 0)) {
        squares <- 0.05
      }
      #default value.
      squares <- ein.pr.in * squares
      theta <- (c(-45, 45, 135, 225) * pi) / 180
      theta <- c(theta, NA)
      theta <- c(matrix(theta, 5, length(z)))
      x <- Proj(
        lat,
        lon,
        geopar$scale,
        geopar$b0,
        geopar$b1,
        geopar$l1,
        geopar$projection
      )
      y <- c(t(matrix(x$y, length(lat), 5)))
      x <- c(t(matrix(x$x, length(lon), 5)))
      y <- y + squares * sqrt(2) * sin(theta)
      x <- x + squares * sqrt(2) * cos(theta)
      if (!labels.only) {
        polygon(x, y, col = ind, border = F)
        if (border) {
          lines(x, y, col = 1)
        }
      }
    }
    if ((rectangles[1] != 0 && !fill.circles) | (rectangles[2] != 0)) {
      # plot rectangles
      th <- atan2(rectangles[2], rectangles[1])
      th <- c(th, 2 * (pi / 2 - th) + th)
      theta <- c(th, -th)
      theta <- c(theta, NA)
      theta <- c(matrix(theta, 5, length(z)))
      x <- Proj(
        lat,
        lon,
        geopar$scale,
        geopar$b0,
        geopar$b1,
        geopar$l1,
        geopar$projection
      )
      y <- c(t(matrix(x$y, length(lat), 5)))
      x <- c(t(matrix(x$x, length(lon), 5)))
      y <- y + squares * sqrt(2) * sin(theta)
      x <- x + squares * sqrt(2) * cos(theta)
      polygon(x, y, col = ind, border = F)
      if (border) {
        lines(x, y, col = 1)
      }
    }
    if (vbars != 0 && !fill.circles) {
      # plot vertical bars
      x <- Proj(
        lat,
        lon,
        geopar$scale,
        geopar$b0,
        geopar$b1,
        geopar$l1,
        geopar$projection
      )
      y <- x$y
      x <- x$x
      if (vbars > 100) {
        vbars <- 0.2
      }
      mx <- matrix(0, 2, length(x))
      my <- mx
      mx[1, ] <- x
      my[1, ] <- y
      mx[2, ] <- x
      my[2, ] <- my[1, ] + r
      for (i in 1:ncol(mx)) {
        lines(mx[, i], my[, i], col = ind[i])
      }
    }
    if (hbars != 0 && !fill.circles) {
      # plot horizontal bars
      x <- Proj(
        lat,
        lon,
        geopar$scale,
        geopar$b0,
        geopar$b1,
        geopar$l1,
        geopar$projection
      )
      y <- x$y
      x <- x$x
      if (hbars > 100) {
        hbars <- 0.2
      }
      mx <- matrix(0, 2, length(x))
      my <- mx
      mx[1, ] <- x
      my[1, ] <- y
      my[2, ] <- y
      r <- ein.pr.in * hbars
      # size in units
      mx[2, ] <- mx[1, ] + r
      for (i in 1:ncol(mx)) {
        lines(mx[, i], my[, i], col = ind[i])
      }
    }
    if (perbars != 0 && !fill.circles) {
      # plot bars perpendicular to cruiselines
      x <- Proj(
        lat,
        lon,
        geopar$scale,
        geopar$b0,
        geopar$b1,
        geopar$l1,
        geopar$projection
      )
      y <- x$y
      x <- x$x
      if (perbars > 100) {
        perbars <- 0.2
      }
      mx <- matrix(0, 2, length(x))
      my <- mx
      mx[1, ] <- x
      my[1, ] <- y
      r <- ein.pr.in * perbars
      # size in units
      dx <- c(1:length(x))
      dx[1] <- x[2] - x[1]
      dx[2:(length(x) - 1)] <- x[3:(length(x))] -
        x[
          1:(length(x) -
            2)
        ]
      dx[length(x)] <- x[length(x)] - x[length(x) - 1]
      dy <- c(1:length(y))
      dy[1] <- y[2] - y[1]
      dy[2:(length(y) - 1)] <- y[3:length(y)] - y[1:(length(y) - 2)]
      dy[length(y)] <- y[length(x)] - y[length(y) - 1]
      dxy <- sqrt(dx * dx + dy * dy)
      dx <- dx / dxy
      dy <- dy / dxy
      mx[2, ] <- mx[1, ] - dy * r
      my[2, ] <- my[1, ] + dx * r
      if (!labels.only) {
        for (i in 1:ncol(mx)) {
          lines(mx[, i], my[, i], col = ind[i])
        }
      }
    }
    if (parbars != 0 && !fill.circles) {
      # colors along transsect lines.
      x <- Proj(
        lat,
        lon,
        geopar$scale,
        geopar$b0,
        geopar$b1,
        geopar$l1,
        geopar$projection
      )
      y <- x$y
      x <- x$x
      nx <- length(x)
      x1 <- x[1:(nx - 1)]
      x2 <- x[2:nx]
      y1 <- y[1:(nx - 1)]
      y2 <- y[2:nx]
      dy1 <- (y2 - y1)
      dx1 <- (x2 - x1)
      x11 <- x1
      y11 <- y1
      r <- ein.pr.in * parbars
      # size in units
      if (parbars > 100) {
        parbars <- 0.1
      }
      mx <- matrix(NA, 5, length(x1))
      my <- mx
      p1x <- x11 + dx1 / 2
      p1y <- y11 + dy1 / 2
      p2x <- x11 - (0 * dx1) / 2
      p2y <- y11 - (0 * dy1) / 2
      dxy <- sqrt(dx1 * dx1 + dy1 * dy1)
      dx <- dx1 / dxy
      dy <- dy1 / dxy
      mx[1, ] <- p1x - (dy * r) / 2
      mx[2, ] <- p1x + (dy * r) / 2
      mx[3, ] <- p2x + (dy * r) / 2
      mx[4, ] <- p2x - (dy * r) / 2
      my[1, ] <- p1y + (dx * r) / 2
      my[2, ] <- p1y - (dx * r) / 2
      my[3, ] <- p2y - (dx * r) / 2
      my[4, ] <- p2y + (dx * r) / 2
      if (!labels.only) {
        polygon(mx, my, border = F, col = ind)
        if (border) {
          lines(mx, my, col = 1)
        }
      }
      x11 <- x2
      y11 <- y2
      r <- ein.pr.in * parbars
      # size in units
      if (parbars > 100) {
        parbars <- 0.1
      }
      mx <- matrix(NA, 5, length(x1))
      my <- mx
      p1x <- x11 + (0 * dx1) / 2
      p1y <- y11 + (0 * dy1) / 2
      p2x <- x11 - dx1 / 2
      p2y <- y11 - dy1 / 2
      dxy <- sqrt(dx1 * dx1 + dy1 * dy1)
      dx <- dx1 / dxy
      dy <- dy1 / dxy
      mx[1, ] <- p1x - (dy * r) / 2
      mx[2, ] <- p1x + (dy * r) / 2
      mx[3, ] <- p2x + (dy * r) / 2
      mx[4, ] <- p2x - (dy * r) / 2
      my[1, ] <- p1y + (dx * r) / 2
      my[2, ] <- p1y - (dx * r) / 2
      my[3, ] <- p2y - (dx * r) / 2
      my[4, ] <- p2y + (dx * r) / 2
      if (!labels.only) {
        polygon(mx, my, border = F, col = ind[2:length(ind)])
      }
    }
    # 	Add  labels around plot
    if (length(label.location) == 1) {
      if (label.location == "locator") {
        label.location <- geolocator(n = 2)
      }
    }
    # use the locator.
    if (length(label.location) > 1) {
      #label located somewhere in drawing
      paint.window(label.location)
      label.location <- Proj(
        label.location$lat,
        label.location$lon,
        geopar$scale,
        geopar$b0,
        geopar$b1,
        geopar$l1,
        geopar$projection
      )
      if (fill.circles || open.circles) {
        if (fill.circles) {
          open <- F
        }
        if (open.circles) {
          open <- T
        }
        labels_size(
          cont1,
          digits,
          colors,
          xlim = label.location$x,
          ylim = label.location$y,
          n = n,
          rat = ein.pr.in,
          minsym = minsym,
          label.resolution = label.resolution,
          open = open,
          lwd = lwd,
          col = col
        )
      } else if (density > 0) {
        shading1(
          cont1,
          digits,
          colors,
          angle = angle,
          rotate = rotate,
          cex = par()$cex,
          xlim = label.location$x,
          ylim = label.location$y
        )
      } else {
        if (labels == 1) {
          # labels for each contour line.
          labels1(
            cont1,
            digits,
            colors,
            xlim = label.location$x,
            ylim = label.location$y
          )
        } else {
          #more of a constant label.
          labels2(
            cont1,
            digits,
            colors,
            xlim = label.location$x,
            ylim = label.location$y
          )
        }
      }
    }
    if (geopar$cont && labels != 0) {
      # if labels needed.
      par(plt = geopar$contlab)
      par(new = T)
      plot(
        c(0, 1, 1, 0, 0),
        c(0, 0, 1, 1, 0),
        type = "l",
        axes = F,
        xlab = " ",
        ylab = " "
      )
      if (density > 0) {
        shading1(
          cont1,
          digits,
          colors,
          angle = angle,
          rotate = rotate,
          cex = par()$cex,
          fill = geopar$cont
        )
      } else {
        if (labels == 1) {
          # labels for each contour line.
          labels1(cont1, digits, colors, fill = geopar$cont)
        } else {
          #more of a constant label.
          labels2(cont1, digits, colors, fill = geopar$cont)
        }
      }
    }
    return(invisible())
  }

# ---- colps.R ----
#' Open a postscript device with the color scheme given by geoplotpalette.
#'
#' The function starts a postscript device and the arguments are the same as
#' the arguments to postscript (height, width, file, bg etc).
#'
#' <!--explain details here-->
#'
#' @param ... The arguments to postscript are optional. See help postscript.
#' @return No value returned.
#' @section Side Effects: A graphics device is opened (often a file).  It must
#' be closed again by dev.off()
#' @seealso postscript, geoplotpalette,litir
#' @keywords <!--Put one or more s-keyword tags here-->
#' @examples
#'
#' \dontrun{
#' colps(file="map1.ps",height=6,width=5)
#' geoplot(xlim=c(-28,-10),ylim=c(64,69))
#' geosymbols(data,z=data$value,circles=0.2,sqrt=T)
#' geopolygon(island,col="white")# paint white over the symbols
#' geolines(island) # that are inside the country.  (island)
#' dev.off()
#'
#' # same example in a different way.
#' colps(file="map1.ps",height=6,width=5,bg="white")
#' geoplot(xlim=c(-28,-10),ylim=c(64,69))
#' geosymbols(data,z=data$value,circles=0.2,sqrt=T)
#' geopolygon(island,col=0)#col 0 is now white
#' geolines(island) # was transparent earlier
#' dev.off()
#' }
#' @export colps
colps <-
  function(...) {
    postscript(...)
    geoplotpalette()
  }

# ---- bwps.R ----
#' Open a postscript device with the color scheme given by geoplotbwpalette.
#' (black and white)
#'
#' The function starts a postscript device and the arguments are the same as
#' the arguments to postscript (height, width, file, bg etc) . The color scheme
#' is 1 black, 2-155 white to black in even steps.
#'
#' <!--explain details here-->
#'
#' @param ... The arguments to postscript are optional. See help postscript.
#' @return No value returned.
#' @section Side Effects: A graphics device is opened (often a file).  It must
#' be closed again by dev.off()
#' @seealso postscript, geoplotbwpalette,litir
#' @keywords devices
#' @examples
#'
#' \dontrun{
#' bwps(file="map1.ps",height=6,width=5)
#' geoplot(xlim=c(-28,-10),ylim=c(64,69))
#' geosymbols(data,z=data$value,circles=0.2,sqrt=T)
#' geopolygon(island,col="white")# paint white over the symbols
#' geolines(island) # that are inside the country.  (island)
#' dev.off()
#'
#' # same example in a different way.
#' bwps(file="map1.ps",height=6,width=5,bg="white")
#' geoplot(xlim=c(-28,-10),ylim=c(64,69))
#' geosymbols(data,z=data$value,circles=0.2,sqrt=T)
#' geopolygon(island,col=0)#col 0 is now white
#' geolines(island) # was transparent earlier
#' dev.off() }
#'
#' @export bwps
bwps <-
  function(...) {
    postscript(...)
    geoplotbwpalette()
  }

# ---- Rlitir.R ----
#' Display colors.
#'
#' A grid of colors is plotted.
#'
#'
#' @param n Number of columns and rows of colors to display
#' @param col A vector of colors
#' @return No value returned, plots an \code{n} by \code{n} grid of colors.
#' @seealso \code{\link{colorRampPalette}}
#' @keywords color
#' @examples
#'
#' # simple, perhaps not so useful application with default palette:
#'
#' Rlitir(12, 1:144)
#'
#' # Define a palette with some colors:
#'
#' ramp <- colorRampPalette(c("khaki1", "gold", "orange",
#'   "darkorange2", "red", "darkred", "black"))
#'
#' # number of columns and rows to display
#'
#' n <- 10
#'
#' Rlitir(n, ramp(n^2))
#'
#' @export Rlitir
Rlitir <-
  function(n, col) {
    x <- c(1:(n + 1))
    plot(x, x)
    y <- x
    for (j in 1:(n - 1)) {
      for (i in 1:(n + 1)) {
        polygon(
          c(x[i], x[i + 1], x[i + 1], x[i]),
          c(y[j], y[j], y[j + 1], y[j + 1]),
          col = col[
            ((j - 1) *
              n +
              i -
              1)
          ]
        )
        lines(
          c(x[i], x[i + 1], x[i + 1], x[i], x[i]),
          c(
            y[
              j
            ],
            y[j],
            y[j + 1],
            y[j + 1],
            y[j]
          ),
          col = 1
        )
        text(
          (x[i] + x[i + 1]) / 2,
          (y[j] + y[j + 1]) / 2,
          as.character((j - 1) * n + i - 1)
        )
      }
    }
    return(invisible())
  }

# ---- litir.R ----
#' Display palette in effect
#'
#' A grid of colors is plotted.
#'
#' Palette in effect gets repeated for \code{n} greater than
#' \code{length(palette())}.
#'
#' @param n Number of columns and rows of colors to display
#' @return No value returned, plots an \code{n} by \code{n} grid of colors.
#' @note Simpler version of \code{\link{Rlitir}}, one of those should do,
#' possibly with a name change.
#' @seealso \code{\link{Rlitir}}
#' @keywords colors
#' @export litir
litir <-
  function(n) {
    x <- c(1:(n + 1))
    plot(x, x)
    y <- x
    for (j in 1:(n - 1)) {
      for (i in 1:(n + 1)) {
        polygon(
          c(x[i], x[i + 1], x[i + 1], x[i]),
          c(y[j], y[j], y[j + 1], y[j + 1]),
          col = ((j - 1) *
            n +
            i -
            1)
        )
        lines(
          c(x[i], x[i + 1], x[i + 1], x[i], x[i]),
          c(
            y[
              j
            ],
            y[j],
            y[j + 1],
            y[j + 1],
            y[j]
          ),
          col = 1
        )
        text(
          (x[i] + x[i + 1]) / 2,
          (y[j] + y[j + 1]) / 2,
          as.character((j - 1) * n + i - 1)
        )
      }
    }
    return(invisible())
  }
