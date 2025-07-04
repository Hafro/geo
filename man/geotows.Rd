% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/geotows.R
\name{geotows}
\alias{geotows}
\title{Plot tows as line segments}
\usage{
geotows(
  lat,
  lon,
  lat1,
  lon1,
  col = 1,
  col.names = c("kastad.n.breidd", "kastad.v.lengd", "hift.n.breidd", "hift.v.lengd"),
  ...
)
}
\arguments{
\item{lat}{Vector of start position latitudes, dataframe of start positions 
given in columns \code{lat} and \code{lon} or dataframe with start and end 
positions given as columns \code{col.names}.}

\item{lon}{When given, vector of start position longitudes.}

\item{lat1}{When given, vector of end position latitudes or a data frame 
of end positions given in columns \code{lat} and \code{lon}.}

\item{lon1}{When given, vector of end position longitudes.}

\item{col}{Color of line segments.}

\item{col.names}{Column names of start lat and lon and end lat and lon 
when  \code{tows} are given in a single dataframe. Defaults to column
names in the Hafro/MRI database table \code{fiskar.stodvar}.}

\item{\dots}{Additional arguments to \code{geolines}.}
}
\description{
The function gets 4 arguments i.e position of begininning and end of
segments.  If the first argument is given col.names gives the column names
in the data frame describing the position.
}
\seealso{
\code{\link{geolines}}
}
\keyword{aplot}
