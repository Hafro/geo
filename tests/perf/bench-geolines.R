args <- commandArgs(trailingOnly = TRUE)
lib <- if (length(args) >= 1) args[1] else NULL
if (!is.null(lib)) {
  suppressMessages(library(geo, lib.loc = lib))
} else {
  suppressMessages(library(geo))
}

run_once <- function() {
  geoplot(xlim = c(0, -50), ylim = c(60, 75), projection = "Lambert")
  geolines(geo::greenland, col = 3, lwd = 1)
}

# Warmup
pdf(tempfile(fileext = ".pdf"))
run_once()
dev.off()

n <- 10
elapsed <- numeric(n)
for (i in 1:n) {
  pdf(tempfile(fileext = ".pdf"))
  elapsed[i] <- system.time(run_once())[["elapsed"]]
  dev.off()
}

cat("Elapsed seconds (n=", n, ")\n", sep = "")
print(elapsed)
cat("Summary\n")
print(summary(elapsed))
