% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/geoarea.R
\name{geoarea}
\alias{geoarea}
\title{Calculates the area of a given region.}
\usage{
geoarea(
  data,
  Projection = "Lambert",
  old.method = F,
  ngrdpts = 2000,
  robust = T
)
}
\arguments{
\item{data}{The region, should contain lat and lon.}

\item{Projection}{Which projection is beeing used.}

\item{old.method}{If true an older version of this program is used. Default
is False.}

\item{ngrdpts}{The precision of the calculation.}

\item{robust}{If true a more robust method is used, default is True.}
}
\value{
The area of the region given.
}
\description{
Calculates the area of a given region to a given precision.
}
\section{Side Effects}{
 None
}

\examples{

         geoarea(island)         # Calculates the area of Iceland up to 
                                 # an with default precision.

         geoarea(island,10000)   # Calculates the area of Iceland up to 
                                 # an adiquite precision.

#         geoarea(geodefine(),10) # Calculates the area of a region specified 
                                 # by the user.

}
\seealso{
\code{\link{geodefine}}, \code{\link{geolocator}},
\code{\link{geoinside}}.
}
