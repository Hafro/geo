Performance scripts for geo

- `profile-geolines.R`: Rprof-based profiling of `geolines()` under a typical
  rectangular clipping path. Outputs a summary to stdout.
- `bench-geolines.R`: quick elapsed-time benchmark for `geolines()`.

These scripts assume the `geo` package is installed. For a local install:

  R CMD INSTALL -l /tmp/geo-lib .
  Rscript -e 'library(geo, lib.loc = "/tmp/geo-lib")'
