% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/setgrid.R
\name{setgrid}
\alias{setgrid}
\title{Produce a grid over an area}
\usage{
setgrid(
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
)
}
\arguments{
\item{lat}{Latitude}

\item{lon}{Longitude, if not included in \code{lat}}

\item{type}{Plot type}

\item{pch}{Plot character}

\item{xlim, ylim}{Limits for plot}

\item{b0}{Base latitude}

\item{r}{Range expansion}

\item{country}{Country plotted}

\item{xlab, ylab}{Labels for x and y axes}

\item{option}{Method for determining plotted area extent, default "cut" (to
the range of the data)}

\item{reg}{Region to be gridded, can be set interactively}

\item{dx}{Resolution in each direction (?)}

\item{nx}{Number of gridpoints in each direction (?)}

\item{grpkt}{Gridpoints can also be supplied to the function for plotting
(??????????)}

\item{scale}{Projection scale (general \code{geo} default is "km")}

\item{find}{Should the gridpoints within \code{reg} be determined?}

\item{new}{Plot control argument ?}

\item{grid}{Draw grid (which grid?)}

\item{projection}{Projection to use}

\item{n}{Number of gridpoints (?)}

\item{b1}{Second latitude for the Lambert projection}

\item{nholes}{number of holes to be sent to \code{geodefine} when setting
out the region to be gridded}
}
\value{
List of components: \item{grpt}{Gridpoints} \item{reg}{Region over
which the grid was laid} \item{find}{Was \code{find = TRUE}?} \item{xgr}{If
\code{find = TRUE} the gridpoints within region \code{reg} is also
returned.}
}
\description{
Produce a grid over an area, possibly interactively.
}
\note{
Needs elaboration, check use of \code{find = TRUE}
}
\seealso{
Calls a number of functions, i.e. \code{\link{geodefine}},
\code{\link{geoplot}}, \code{\link{geopoints}}, \code{\link{gridpoints}},
\code{\link{inside}}, \code{\link{selectedpar}}
}
\keyword{aplot}
\keyword{iplot}
