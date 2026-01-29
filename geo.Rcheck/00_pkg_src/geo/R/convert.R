# Auto-generated grouping file: convert.R
# Original function definitions were moved here for maintainability.

# ---- geoconvert.R ----
#' Convert latitude and longitude
#'
#' Convert between different representations of latitude and longitude, namely
#' degrees-minutes-decimal minutes and decimal degrees.
#'
#'
#' @param data Dataframe with coordinates in two columns
#' @param inverse Which conversion should be undertaken, default from
#' degrees-minutes-decimal minutes (DDMMmm) to decimal degrees (DD.dd)
#' @param col.names Colnames in \code{data} with coordinates to convert,
#' default \code{lat, lon}
#' @return Returns \code{data} with converted values in the coordinate columns.
#' @note Functions calling \code{geoconvert} do so in a branch that is probably
#' rarely used. Implement conversion from other representations of lat and lon
#' in future?
#' @seealso Called by a number of functions, i.e. \code{\link{d2mr}},
#' \code{\link{mr2d}}, \code{\link{geogrid}}, \code{\link{geoidentify}},
#' \code{\link{geolines}}, \code{\link{geopoints}}, \code{\link{geopolygon}}
#' and \code{\link{geotext}}, perhaps unncessarily in some. Wraps around
#' functions \code{\link{geoconvert.1}} and \code{\link{geoconvert.2}},
#' depending on which conversion to undertake.
#' @keywords manip
#' @export geoconvert
geoconvert <-
  function(data, inverse = F, col.names = c("lat", "lon")) {
    if (!inverse) {
      if (is.data.frame(data)) {
        if (any(is.na(match(col.names, names(data))))) {
          cat(paste("Columns", col.names, "do not exist"))
          return(invisible())
        }
        data[, col.names[1]] <- geoconvert.1(data[, col.names[
          1
        ]])
        data[, col.names[2]] <- geoconvert.1(data[, col.names[
          2
        ]])
      } else {
        data <- geoconvert.1(data)
      }
    } else {
      # Convert to write out.
      if (is.data.frame(data)) {
        if (any(is.na(match(col.names, names(data))))) {
          cat(paste("Columns", col.names, "do not exist"))
          return(invisible())
        }
        data[, col.names[1]] <- geoconvert.2(data[, col.names[
          1
        ]])
        data[, col.names[2]] <- geoconvert.2(data[, col.names[
          2
        ]])
      } else {
        data <- geoconvert.2(data)
      }
    }
    return(data)
  }

geoconvert_impl <-
  function(x, direction = c("to-decimal", "from-decimal")) {
    direction <- match.arg(direction)
    if (direction == "to-decimal") {
      i <- sign(x)
      x <- abs(x)
      # x <- ifelse(abs(x) < 10000, x * 100, x) # This can not be allowed.
      # Check for minutes > 60
      x1 <- x %% 10000
      k <- c(1:length(x1))
      k <- k[x1 > 5999 & !is.na(x1)]
      if (length(k) > 0) {
        print(paste("error > 60 min nr", k, x[k]))
      }
      min <- (x / 100) - trunc(x / 10000) * 100
      return((i * (x + (200 / 3) * min)) / 10000)
    }
    i <- sign(x)
    x <- abs(x)
    p1 <- floor(x)
    p2 <- floor((x - p1) * 60)
    p3 <- round((x - p1 - p2 / 60) * 100 * 60)
    return(i * (p1 * 10000 + p2 * 100 + p3))
  }

# ---- geoconvert.1.R ----
#' Convert to decimal degrees
#'
#' Convert to decimal degrees.
#'
#'
#' @param x Vector of decimal-minute-decimal minutes
#' @return Returns converted value in decimal degrees.
#' @seealso Called by \code{\link{geoconvert}}
#' @keywords manip
#' @export geoconvert.1
geoconvert.1 <-
  function(x) {
    geoconvert_impl(x, "to-decimal")
  }

# ---- geoconvert.2.R ----
#' Convert from decimal degrees
#'
#' Convert from decimal degrees to degrees, minutes and fractional minutes
#' representation (DDMMmm) of lat or lon.
#'
#'
#' @param lat Vector of latitude or longitudes
#' @return Returns a vector of six digit values with degrees, minutes and
#' fractions of minutes, with two decimal values, concatenated.
#' @seealso Called by \code{\link{geoconvert}}, when \code{inverse = TRUE}.
#' @keywords manip
#' @export geoconvert.2
geoconvert.2 <-
  function(lat) {
    geoconvert_impl(lat, "from-decimal")
  }

# ---- deg2rect.R ----
#' Given position return rectangle code.
#'
#'
#' Functions that convert positions in decimal degrees latitude and longitude
#' to rectangle codes for statistical rectangles, their subrectangles or
#' rectangle codes in systems of various resolutions as described below and
#' relating to (see \code{\link{rect2deg}}).
#'
#'
#' \itemize{
#'
#' \item \code{r2d} with a resolution of 30 min latitue and 1 deg longitude
#' (the Icelandic numbering system, 'tilkynningaskyldureitir').
#'
#' \item \code{sr2d} with a resolution of 15 min latitude by 30 min longitude
#' in the Icelandic numbering system for statistical rectangles which starts
#' counting at 60 deg N latitude, with sub-rectangles of 30 min lat by 1 deg
#' lon coded 1, 2, 3 and 4 for the NW, NA, SW and SA quadrants respectively
#'
#' }
#'
#' A small number (1e-06) is added to latitude and subtracted from longitude to
#' ensure rectangle membership of positions on border are \dQuote{logical} on
#' the nw-hempisphere.
#'
#' @name deg2rect
#' @aliases d2r d2sr d2mr d2dr
#' @param lat,lon Position(s) as decimal degrees latitude and longitude.  If
#' \code{lat} is \code{list} its components \code{lat$lat} and \code{lat$lon}
#' are used for \code{lat} and \code{lon}.
#' @param dlat,dlon Rectangle height and width in degrees and minutes latitude
#' and longitude for \code{d2dr} and \code{d2mr} respectively.
#' @param startLat Starting latitude used in coding the rectangles.
#' @return Vector of rectangle codes in the chosen coding system.
#' @note These functions could be made hemisphere-aware, and no attention has
#' been given to making the functions work in the southern hemisphere, possibly
#' with the option of specifying starting latitudes.
#' @author
#'
#' HB (\code{d2r, d2sr}, STJ (\code{d2mr, d2dr}).
#' @seealso
#'
#' \code{\link{rect2deg}}
#' @keywords manip arith
#' @examples
#'
#'
#' ## tally positions in rectangles in object \code{\link{island}} giving
#' ## Iceland's coastline
#'
#' data(island)
#' rects <- d2r(island)
#' table(rects)
#'
#'

#' @export d2r
#' @rdname deg2rect
d2r <-
  function(lat, lon = NULL) {
    if (is.null(lon)) {
      lon <- lat$lon
      lat <- lat$lat
    }
    lat <- lat + 1e-06
    lon <- lon - 1e-06
    lon <- -lon
    r <- (floor(lat) - 60) * 100 + floor(lon)
    ifelse(lat - floor(lat) > 0.5, r + 50, r)
  }

#' @export d2sr
#' @rdname deg2rect
d2sr <-
  function(lat, lon = NULL) {
    if (is.null(lon)) {
      lon <- lat$lon
      lat <- lat$lat
    }
    lat <- lat + 1e-06
    lon <- lon - 1e-06
    lon <- -lon
    r <- (floor(lat) - 60) * 100 + floor(lon)
    r <- ifelse(lat - floor(lat) > 0.5, r + 50, r)
    deg <- r2d(r)
    lon <- -lon
    dlat <- -(lat - deg$lat)
    dlon <- -(lon - deg$lon)
    dl <- sign(dlat + 1e-07) +
      2 *
        sign(
          dlon +
            1e-07
        ) +
      4
    sr <- c(2, 0, 4, 0, 1, 0, 3)
    sr <- sr[dl]
    floor(r * 10 + sr)
  }

#' @export d2mr
#' @rdname deg2rect
d2mr <-
  function(lat, lon = NULL, dlat = 5, dlon = 10) {
    if (is.null(lon)) {
      lon <- lat$lon
      lat <- lat$lat
    }
    lat <- lat + 1e-06
    lon <- lon - 1e-06
    lat <- geoconvert(lat, inverse = TRUE)
    lon <- -geoconvert(lon, inverse = TRUE)
    mlat <- lat %% 10000 %/% 100
    mlon <- lon %% 10000 %/% 100
    mlat <- mlat %/% dlat
    mlon <- mlon %/% dlon
    lat <- lat %/% 10000
    lon <- lon %/% 10000
    lat * 1000000 + mlat * 10000 + lon * 100 + mlon
  }

#' @export d2dr
#' @rdname deg2rect
d2dr <-
  function(lat, lon = NULL, dlat = 1, dlon = 2, startLat = 50) {
    if (is.null(lon)) {
      lon <- lat$lon
      lat <- lat$lat
    }
    lat <- lat + 1e-06
    lon <- lon - 1e-06
    hemi <- sign(lon)
    lat <- floor(lat) %% startLat
    lon <- floor(lon)
    hemi * (100 * lat %/% dlat + hemi * floor(lon / dlon))
  }

# ---- rect2deg.R ----
#' Given rectangle code return its center position.
#'
#' Functions that convert statistical rectangle codes under: 1) a traditional
#' Icelandic system ('tilkynningaskyldurreitakerfid') (see \code{\link{d2r}}
#' and \code{\link{d2sr}}) and 2) set up in systems based on minutes and
#' degrees (see \code{\link{d2mr}} and \code{\link{d2dr}}) to decimal
#' representation of rectangles center positions in degreees latitude and
#' longitude.
#'
#' \itemize{
#'
#' \item \code{r2d} with a resolution of 30 min latitue and 1 deg longitude
#' (the Icelandic numbering system, 'tilkynningaskyldureitir').
#'
#' \item \code{sr2d} with a resolution of 15 min latitude by 30 min longitude
#' in the Icelandic numbering system for statistical rectangles which starts
#' counting at 60 deg N latitude, with sub-rectangles of 30 min lat by 1 deg
#' lon coded 1, 2, 3 and 4 for the NW, NA, SW and SA quadrants respectively,
#'
#' \item \code{mr2d} with resolution given in \code{dlat} by \code{dlon}
#' minutes lat and lon,
#'
#' \item \code{dr2d} for rectangles with resolution given in \code{dlat} by
#' \code{dlon} degrees lat and lon, code system starting at latitude
#' \code{startLat}.
#'
#' }
#'
#' @name rect2deg
#' @aliases r2d sr2d mr2d dr2d
#' @param r Rectangle code \code{r} in the 'tillkynningaskyldu-system', e.g
#' from \code{\link{deg2rect}}.
#' @param sr Rectangle code \code{sr} for subrectangle in
#' 'tilkynningaskyldu-system', e.g. from \code{\link{deg2rect}}.
#' @param mr Rectangle code \code{mr} based on minutes, e.g. from
#' \code{\link{deg2rect}}.
#' @param dr Rectangle code \code{dr} based on degrees, e.g. from
#' \code{\link{deg2rect}}.
#' @param dlat Rectangle height in minutes or degrees latitude for \code{mr2d}
#' and \code{dr2d} respectively.
#' @param dlon As \code{dlat} except now width in longitude.
#' @param startLat Starting latitude for coding the rectangles.
#' @return dataframe of center positions (latitude \code{lat} and longitude
#' \code{lon}) of rectangles in one of the coding systems
#' @note Mostly used for plotting.
#' @author
#'
#' HB (for \code{r, sr}), STJ (for \code{mr, dr}).
#' @seealso \code{\link{deg2rect}}
#' @keywords arith manip
#' @examples
#'
#'   r2d(d2r(lat = 65 + 1/4, lon = -19 - 1/2))
#'   d2r(r2d(519))
#'

#' @export r2d
#' @rdname rect2deg
r2d <-
  function(r) {
    lat <- floor(r / 100)
    lon <- (r - lat * 100) %% 50
    halfb <- (r - 100 * lat - lon) / 100
    lon <- -(lon + 0.5)
    lat <- lat + 60 + halfb + 0.25
    data.frame(lat = lat, lon = lon)
  }

#' @export sr2d
#' @rdname rect2deg
sr2d <-
  function(sr) {
    r <- floor(sr / 10)
    sr <- sr - r * 10
    lat <- floor(r / 100)
    lon <- (r - lat * 100) %% 50
    halfb <- (r - 100 * lat - lon) / 100
    lon <- -(lon + 0.5)
    lat <- lat + 60 + halfb + 0.25
    l1.lat <- c(0, 0.125, 0.125, -0.125, -0.125)
    l1.lon <- c(0, -0.25, 0.25, -0.25, 0.25)
    lat <- lat + l1.lat[sr + 1]
    lon <- lon + l1.lon[sr + 1]
    data.frame(lat = lat, lon = lon)
  }

#' @export mr2d
#' @rdname rect2deg
mr2d <-
  function(mr, dlat = 5, dlon = 10) {
    lat <- mr %/% 1000000
    mr <- mr %% 1000000
    mlat <- mr %/% 10000
    mr <- mr %% 10000
    lon <- mr %/% 100
    mlon <- mr %% 100
    lat <- 10000 * lat + 100 * (dlat * mlat + dlat / 2)
    lon <- 10000 * lon + 100 * (dlon * mlon + dlon / 2)
    data.frame(lat = geoconvert(lat), lon = -geoconvert(lon))
  }

#' @export dr2d
#' @rdname rect2deg
dr2d <-
  function(dr, dlat = 1, dlon = 2, startLat = 50) {
    hemi <- sign(dr + 1e-06)
    lat <- startLat + dlat * (abs(dr) %/% 100)
    lon <- dlon * (dr %% (hemi * 100))
    data.frame(lat = lat + dlat / 2, lon = lon + dlon / 2)
  }

# ---- s2pre.R ----
#' Writes out data.frame or matrix to a prelude-file.
#'
#' Data.frame or matrix object is written to a prelude-file, that inherits
#' names/dimnames attributes from the object.
#'
#'
#' @param data Data.frame or matrix object.
#' @param file Name of the output file ("Splus.pre" by default).
#' @param na.replace A character to replace NA with in the output file ("" by
#' default).
#' @return A prelude-file representation of the data-object is written to a
#' file.
#' @section Side Effects: No warning is given if the filename "file" already
#' exists -- it is simply over-written.
#' @seealso \code{\link{cat}}, \code{\link{write}}.
#' @examples
#'
#' \dontrun{Within Splus:
#'        > tmp.test.frame
#'           tolur1     tolur2 stafir1
#'         1     11 0.04625551       a
#'         2     12 0.04845815       a
#'         3     13 0.05066079      NA
#'         4     14 0.05286344       a
#'         5     15 0.05506608       a
#'         6     16 0.05726872       b
#'         7     17 0.05947137       b
#'         8     18         NA       b
#'         9     19 0.06387665       b
#'        10     20 0.06607930       b
#'        > s2pre(tmp.test.frame,file="prufa.pre",na.replace="-1")
#'        >
#'
#'        From UNIX:
#'
#'        hafbitur/home/reikn/gardar/Papers/Methods95 [435] cat prufa.pre
#'        linu_nofn       tolur1  tolur2  stafir1
#'        ---------       ------  ------  -------
#'        1       11      0.04625551      a
#'        2       12      0.04845815      a
#'        3       13      0.05066079      -1
#'        4       14      0.05286344      a
#'        5       15      0.05506608      a
#'        6       16      0.05726872      b
#'        7       17      0.05947137      b
#'        8       18      -1      b
#'        9       19      0.06387665      b
#'        10      20      0.06607930      b
#'        hafbitur/home/reikn/gardar/Papers/Methods95 [436]
#' }
#' @export s2pre
s2pre <-
  function(data, file = "splus.pre", na.replace = "") {
    # data       :matrix or data.frame.
    # na.replace :a character to replace NA with.
    #
    # VALUE      :a prelude file, named "Splus.pre" by default.
    if (is.data.frame(data)) {
      data <- as.matrix.data.frame(data)
    }
    data[is.na(data) | data == "NA"] <- na.replace
    col.names <- dimnames(data)[[2]]
    if (is.null(col.names) || length(col.names) == 0) {
      col.names <- paste("dalkur", 1:ncol(data), sep = "")
    }
    row.names <- dimnames(data)[[1]]
    if (!is.null(row.names) && length(row.names) > 0) {
      col.names <- c("linu_nofn", col.names)
      data <- cbind(row.names, data)
    }
    n.of.col <- length(col.names)
    # Write out rownames:
    cat(col.names, sep = c(rep("\t", n.of.col - 1), "\n"), file = file)
    strika.lina <- rep("", n.of.col)
    for (i in 1:n.of.col) {
      strika.lina[i] <- paste(rep("-", nchar(col.names[i])), collapse = "")
    }
    # Write out the ------ line:
    cat(
      strika.lina,
      sep = c(rep("\t", n.of.col - 1), "\n"),
      file = file,
      append = T
    )
    # Write out the data:
    cat(
      t(data),
      sep = c(rep("\t", n.of.col - 1), "\n"),
      file = file,
      append = T
    )
    return(invisible(NULL))
  }

# ---- pre2s.R ----
#' Read prelude files
#'
#' Read data files in prelude format, which has 2 line headers and column names
#' seperated from data with dashes.
#'
#'
#' @param skr Prelude file name
#' @param rownames Should first column be used as row names? Default FALSE
#' @param dots.in.text Should underscores in column names be replaced with "."?
#' Default TRUE
#' @return A data frame (\code{\link{data.frame}}) containing a representation
#' of the data in the file.
#' @note Call to \code{skipta.texta} could be replaced with a call to
#' \code{\link{chartr}} (as in ROracleUI sql).
#' @seealso Calls \code{\link{skipta.texta}}
#' @export pre2s
pre2s <-
  function(skr, rownames = F, dots.in.text = T) {
    fields <- count.fields(skr, sep = "\t")
    nrec <- length(fields)
    if (nrec == 2) {
      return(NULL)
    }
    collab <- scan(file = skr, what = character(), sep = "\t", n = fields[1])
    outp <- read.table(
      skr,
      sep = "\t",
      skip = 2,
      as.is = T,
      row.names = NULL,
      na.strings = ""
    )
    names(outp) <- collab
    if (rownames) {
      row.names(outp) <- outp[, 1]
      outp <- outp[, 2:ncol(outp)]
    }
    # change _ in names to .
    if (dots.in.text) {
      names(outp) <- skipta.texta(names(outp))
    }
    return(outp)
  }
