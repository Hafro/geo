% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ices.R
\name{ices}
\alias{ices}
\title{ICES Areas}
\usage{
ices(
  labels = "roman",
  diagrams = FALSE,
  col = "black",
  lwd = 3,
  col.lines = "grey80",
  font = 2,
  col.text = "orangered",
  cex = 1
)
}
\arguments{
\item{labels}{is how to annotate areas: \code{"roman"} (I--XIV),
\code{FALSE} (no labels), vector (custom), otherwise 1--14.}

\item{diagrams}{is whether to show diagrams on console.}

\item{col}{is passed to \code{map}.}

\item{lwd}{is passed to \code{lines}.}

\item{col.lines}{is passed to \code{lines}.}

\item{font}{is passed to \code{text}.}

\item{col.text}{is passed to \code{text}.}

\item{cex}{is passed to \code{text}.}
}
\value{
Invisible data frame with coordinates.
}
\description{
Draw a map showing ICES areas 1--14.
}
\note{
The coordinates were inferred from official ICES maps.
}
\examples{

ices()

}
\author{
Arni Magnusson.
}
\keyword{hplot}
\keyword{spatial}
\keyword{utilities}
