## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 6,
  fig.height = 5
)

## -----------------------------------------------------------------------------
library(geo)

## -----------------------------------------------------------------------------
# Iceland coastline
geoplot(grid = FALSE)
geolines(island)

## -----------------------------------------------------------------------------
set.seed(1)
lon <- rnorm(10, -27, 1.3)
lat <- rnorm(10, 65, 0.6)
labels <- letters[1:10]

geoplot(
  lat = lat,
  lon = lon,
  grid = FALSE,
  xlim = c(-22, -30),
  ylim = c(63, 67)
)
geopoints(lat, lon, pch = "*", col = 5)
geotext(lat, lon, z = labels, cex = 0.8)

## -----------------------------------------------------------------------------
geoplot(grid = FALSE)
geopolygon(island, col = 115, exterior = TRUE)
geolines(island)

## -----------------------------------------------------------------------------
# Convert degrees-minutes to decimal and back
x <- c(633000, 650000)
geo_dec <- geoconvert.1(x)
geo_dmm <- geoconvert.2(geo_dec)
geo_dec
geo_dmm

## -----------------------------------------------------------------------------
code <- d2r(lat = 65.25, lon = -19.5)
center <- r2d(code)
code
center

## -----------------------------------------------------------------------------
# Create a small synthetic grid
lon <- seq(-26, -22, by = 0.2)
lat <- seq(63, 66, by = 0.2)

gr <- expand.grid(lon = lon, lat = lat)
z <- with(gr, sin((lon + 24) * 2) + cos((lat - 64.5) * 2))

geoplot(grid = FALSE, xlim = range(lon), ylim = range(lat))
geocontour.fill(grd = list(lon = lon, lat = lat), z = z, levels = pretty(z, 6))

## -----------------------------------------------------------------------------
set.seed(2)
pts <- data.frame(
  lon = rnorm(200, -20, 2),
  lat = rnorm(200, 65, 1)
)

geoplot(grid = FALSE, xlim = c(-26, -14), ylim = c(62, 68))
geopolygon(island, col = 115, exterior = TRUE)
geolines(island)

# Keep only points outside Iceland
sea_pts <- geoinside(pts, island, option = 2)

geopoints(sea_pts$lat, sea_pts$lon, pch = ".", col = 4)

## -----------------------------------------------------------------------------
set.seed(3)
# Sample data
lat <- rnorm(150, 64.5, 0.6)
lon <- rnorm(150, -20, 1.2)
z <- 100 * (sin(lat) + cos(lon))

# Build a grid over the data range
lon_seq <- seq(min(lon), max(lon), by = 0.2)
lat_seq <- seq(min(lat), max(lat), by = 0.2)
xgr <- list(lon = lon_seq, lat = lat_seq)

# Empirical variogram and fit (spherical)
vgram <- variogram(lat, lon, z, nbins = 20)
vfit <- variofit(vgram, option = 1)
if (is.null(vfit) || any(!c("rang1", "sill", "nugget") %in% names(vfit))) {
  vfit <- list(rang1 = 1, sill = 1, nugget = 0)
}

# Kriging to grid
zgr <- pointkriging(lat, lon, z, xgr, vfit)
if (all(is.na(zgr))) {
  zgr <- rep(mean(z, na.rm = TRUE), length(xgr$lat) * length(xgr$lon))
}

geoplot(grid = FALSE, xlim = range(xgr$lon), ylim = range(xgr$lat))
z_range <- range(zgr, na.rm = TRUE)
levels <- seq(z_range[1], z_range[2], length.out = 6)
geocontour.fill(xgr, zgr, levels = levels)
