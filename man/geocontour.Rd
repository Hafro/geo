% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/geocontour.R
\name{geocontour}
\alias{geocontour}
\title{Plots contour lines.}
\usage{
geocontour(
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
)
}
\arguments{
\item{grd}{List with components \code{lat} and \code{lon} (or
\code{x},\code{y}) defining the grid values.  Can be made for example by lat
<- list(lat = seq(60,65,length = 100), lon = seq(-30,- 10,length = 200)).
Also lat can be the output of the program grid and then the components
\code{lat$grpt$lat}, \code{lat$grpt$lon} and \code{lat$reg} are used. See
geocontour.fill.}

\item{z}{Matrix or vector of values.  Length nlat*nlon except when lat is a
list with components \code{lat$grpt} and \code{lat$xgr}.  Then the length of
z is the same as the length of \code{lat$xgr$lat} and \code{lat$xgr$lon}.}

\item{nlevels}{Number of contourlines.  Used if the program has to determine
the contourlines.  Default value is 10. nlevels = 10 does not always mean 10
due to characteristic of the pretty command}

\item{levels}{Ratio of textsize to current size.  1 means same size, 0.5
half size , 0 no text etc.  Default value 1.}

\item{labcex}{Character expansion of letters indicating the z value on the
contour lines. Maybe used instead of a legend.}

\item{triangles}{If TRUE the program makes 4 triangles from each element in
the grid.  In fact it makes the number of grid points approximately twice as
many as before which means smoother contourlines.  Default value TRUE.
Triangles = TRUE is nessecary if the area was plotted with geocontour.fill.
It fits with geocontour.fill.}

\item{reg}{List with two components, \code{reg$lat} and \code{reg$lon}.
Region of interest. Contourlines are only plotted inside the region.  Holes
in the region of interest begin with NA.  If the region consists only of
holes then \code{reg$lat} and \code{reg$lon} begin with NA.}

\item{fill}{If fill is one the matrix is filled with zeros.  If two it is
filled with mean(z).  Default is fill = 1.  ( not an important parameter)}

\item{colors}{If colors is TRUE the contour lines are plotted in many
colors.  Else only in one.  The lines can also be in one color using many
linetypes.}

\item{col}{Number of color (colors) used to plot contourlines.  Default
value is 1 if colors is FALSE.  If colors is TRUE the default value is found
from the number of contour lines.}

\item{only.positive}{Logical value.  If FALSE then negative values are
allowed else negative values are set to zero.  Default value is FALSE.}

\item{maxcol}{Maximum color number in the Splus graphics, default value 155.}

\item{cex}{Character expansion of digits, default value is 0.7.}

\item{save}{If true the contour lines are saved in a list so they can later
be plotted with geolines.  Default value is false.}

\item{plotit}{If TRUE the lines are plotted on the graphics device else not.
Default value is true.}

\item{label.location}{List with components \code{lat} and \code{lon} (or
\code{x},\code{y}) Gives the lower left and upper right corner of the box
where the labels are put.  Default value is 0 that means no labels are put
on the drawing (except when \code{geopar$cont = TRUE}).  l1 is best given by
geolocator or directly by specifying label.location = "locator".}

\item{lwd}{Line with.  Default value is the value set when the program was
called.}

\item{lty}{ine type.  If lty is a vector of the same length of levels it
specifies the linetype for each contour line.  Default value is the same as
when the program was called.}

\item{labels.only}{If true only the labels are drawn.  Default is false.}

\item{digits}{Number of digits in labels.  Default value is one.}

\item{paint}{if true borders of regions will be painted.}

\item{set}{Set something.}

\item{col.names}{the names of the vectors containing the data in grd.
Default is col.names = c("lon","lat").}

\item{csi}{Size of character.  This parameter can not be set in R but for
compatibility with old Splus scripts the parameter cex is readjusted by cex
= cex*csi/0.12.  Use of this parameter is not recommended.  Default value is
NULL i.e not used.}

\item{drawlabels}{Draw labels on the contour lines? Default FALSE.}
}
\value{
No values returned.
}
\description{
The function plots contour lines. It is based on the Splus function
"contour" with some changes and extensions.  The main change is that
coordinates are in lat, lon instead of x, y. There are two additions : 1.
Possibility to have many colors.  2.  Possibility to only plot lines within
certain borders.  3.  Possibility to have labels in a box on the plot.
Note: to plot contour plots with fill between lines you use geocontour.fill
}
\section{Side Effects}{
 No side effects.
}

\examples{

     ###################################################
     # Example l                                       #
     ###################################################  
\dontrun{
     geoplot(deg, cont = TRUE)                        # Plot initialized.
     geocontour(grd$lat,grd$lon,z,nlevels = 10,
                neg = FALSE,reg = reg,colors = TRUE)          # Contour plot.
     geoplot(deg,pch = " ",cont = TRUE,new = TRUE)           # Plot over contourplot.
}
     ###################################################
     # Example 2 Sea Tempeture.                        #
     ###################################################  
      
     # The following data names used are in Icelandic, stodvar means
     # stations and botnhiti means temperature.

     geoplot()
     gbplot(500)
     grd <- list(lat = seq(63,67,length = 30),
                 lon = seq(-28,-10,length = 50))
     labloc <- list(lat = c(63.95,65.4),lon = c(-19.8,-17.3))

     grd1 <- geoexpand(grd)                       # Make grid.
     grd2 <- geoinside(grd1,gbdypif.500)  
     grd2 <- geoinside(grd2,island,robust = FALSE,option = 2) 
     # Use only the points where depth < 500 and outside Iceland.
\dontrun{
     #xx <- loess(botnhiti~ lat*lon,degree = 2,spaALSEn = 0.25,
     #            data = stodvar, na.action = na.omit)
     # Use loess for interpolating.

     #grd2$temp <- predict(xx,grd2)                
     #geocontour(grd2,z = grd2$temp,levels = c(0,1,2,3,4,5,6,7),
     #           label.location = labloc)

     ######################################################
     # Example 3 example of gam() and indexes.            #
     ###################################################### 

     stations<-data.frame(lat = stodvar$lat,lon = stodvar$lon,
                          temp = stodvar$botnhiti)
     # Making a partial data.frame from a big one called stodvar,
     # which means stations in Icelandic.

     stations[1:5,]             # Show first 5 lines all columns
                                # in stations.
     dim(stations)              # Length of (lines,colums).
     dim(stations[!is.na(stations$temp),])      # Without NAs.
     my.data <- stations[!is.na(stations$temp),]
     my.data <- my.data[!is.na(my.data$lat),]
     my.data <- my.data[!is.na(my.data$lon),]
     # my.data is now same as stations but witout NAs in lat,
     # lon and temp.
       
     pred.grid <- list(lat = seq(63.25,67.25,length = round((67.25-63.25+1)*8)),
                       lon = seq(-27,-11.5,length = round((27-11.5+1)*4)))
     pred.grid <- geoexpand(pred.grid)
     # Making a grid to fit our area of interest.
     pred.grid <- geoinside(pred.grid,gbdypif.500)
     # Points within 500m.
     pred.grid <- geoinside(pred.grid,island,robust = FALSE,option = 2)
     # Points outside  of Iceland.
     
     geoplot(grid = FALSE)
     my.data <- geoinside(my.data,island,robust = FALSE,option = 2)
     geopoints(my.data,pch = ".")

     fit <- gam(temp~lo(lat,lon,span = 0.1),data = my.data)
     # see help(gam)
     # can also do:
     # fit <- loess(temp~lon*lat,data = my.data,span = 0.1)
     # fit <- gam(temp~ns(lon,df = 7)*ns(lat,df = 5),data = my.data) 

     pred.grid$pred.temp <- predict(fit,newdata = pred.grid)
     geocontour(pred.grid,z = pred.grid$pred.temp,levels = 0:7,
                label.location = labloc)
}
}
\seealso{
\code{\link{contour}}, \code{\link{geocontour.fill}},
\code{\link{geolocator}}, \code{\link{geopolygon}}, \code{\link{geotext}},
\code{\link{geosymbols}}, \code{\link{geogrid}}, \code{\link{geopar}},
\code{\link{geolines}}.
}
