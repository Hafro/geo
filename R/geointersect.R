#' Find intersection of 2 polygons
#' 
#' Find intersection of 2 polygons
#' 
#' 
#' @param data Polygon.
#' @param border Polygon to intersect with/complement from.
#' @param in.or.out Whether to take intersect of âxâ and âxbâ (0) 
#' or complement of âxâ in âxbâ (1). Default 0.
#' @seealso \code{\link{findcut}}, \code{\link{invProj}}, \code{\link{Proj}}
#' @keywords logic manip 
#' @export geointersect
geointersect <-
function(data, border, in.or.out)
{
	tmp <- invProj(findcut(Proj(data), Proj(border), in.or.out))
	return(data.frame(lat = tmp$lat, lon = tmp$lon))
}

