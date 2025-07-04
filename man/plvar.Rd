% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plvar.R
\name{plvar}
\alias{plvar}
\title{Plots a variogram estimated by variofit.}
\usage{
plvar(vagram, n = 4, fit = T, type = "p")
}
\arguments{
\item{vagram}{List from the program variogram with the following components.
<s-example> range: range of data.  nugget: nugget effect.  sill: sill.
vario: z values of the variogram.  xh: mean distance for each class.

</s-example>}

\item{n}{The plot covers n times the range.  Default value is all the data.}

\item{fit}{Also plot lines and fitted values (\code{TRUE}, the default, 
or plot variogram only as points (\code{FALSE}).}

\item{type}{Plot type, given to \code{plot}, defaults to points.}
}
\value{
No values returned.
}
\description{
Plot a variogram and a spherical model fit to it.
}
\seealso{
\code{\link{pointkriging}}, \code{\link{grid}}.
}
