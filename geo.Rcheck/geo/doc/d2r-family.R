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
# Convert point to rectangle code and back to the rectangle center
code <- d2r(lat = 65.25, lon = -19.5)
center <- r2d(code)
code
center

## -----------------------------------------------------------------------------
# Tally coastline points into rectangles
data(island)
rects <- d2r(island)
head(table(rects))

## -----------------------------------------------------------------------------
# Sub-rectangle code and back to center
sr_code <- d2sr(lat = 65.25, lon = -19.5)
sr_center <- sr2d(sr_code)
sr_code
sr_center

## -----------------------------------------------------------------------------
# 5' latitude by 10' longitude grid
mr_code <- d2mr(lat = 65.25, lon = -19.5, dlat = 5, dlon = 10)
mr_center <- mr2d(mr_code, dlat = 5, dlon = 10)
mr_code
mr_center

## -----------------------------------------------------------------------------
# 1° latitude by 2° longitude grid, starting at 50°N
# (Use startLat to align the coding origin)
dr_code <- d2dr(lat = 65.25, lon = -19.5, dlat = 1, dlon = 2, startLat = 50)
dr_center <- dr2d(dr_code, dlat = 1, dlon = 2, startLat = 50)
dr_code
dr_center

## -----------------------------------------------------------------------------
# Round-trips should land at the rectangle center for the chosen system
r2d(d2r(lat = 65 + 1 / 4, lon = -19 - 1 / 2))

## -----------------------------------------------------------------------------
# Rectangle code -> center -> back to code
# (Center stays in the same rectangle)
d2r(r2d(519))
