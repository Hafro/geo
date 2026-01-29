args <- commandArgs(trailingOnly = TRUE)
lib <- if (length(args) >= 1) args[1] else NULL
if (!is.null(lib)) {
  suppressMessages(library(geo, lib.loc = lib))
} else {
  suppressMessages(library(geo))
}

tmp_pdf <- tempfile(fileext = ".pdf")
profiling_out <- tempfile(fileext = ".out")

pdf(tmp_pdf)
geoplot(xlim = c(0, -50), ylim = c(60, 75), projection = "Lambert")
Rprof(profiling_out, interval = 0.01)
for (i in 1:10) {
  geolines(geo::greenland, col = 3, lwd = 1)
}
Rprof(NULL)
dev.off()

prof <- summaryRprof(profiling_out)
cat("Top by total time\n")
print(utils::head(prof$by.total, 20))
cat("\nTop by self time\n")
print(utils::head(prof$by.self, 20))
