args <- commandArgs(trailingOnly = TRUE)
lib <- if (length(args) >= 1) args[1] else NULL
if (!is.null(lib)) {
  suppressMessages(library(geo, lib.loc = lib))
} else {
  suppressMessages(library(geo))
}

border <- list(
  x = c(0, 5, 10, 8, 2, 0),
  y = c(0, 2, 0, 8, 10, 0)
)

line <- list(
  x = c(seq(-5, 15, length.out = 200), NA, seq(15, -5, length.out = 200)),
  y = c(seq(1, 9, length.out = 200), NA, seq(9, 1, length.out = 200))
)

run_once <- function() {
  geo_clip_polyline_to_polygon_cpp(line$x, line$y, border$x, border$y)
}

# Warmup
run_once()

n <- 50
elapsed <- numeric(n)
for (i in 1:n) {
  elapsed[i] <- system.time(run_once())[["elapsed"]]
}

cat("Elapsed seconds (n=", n, ")\n", sep = "")
print(elapsed)
cat("Summary\n")
print(summary(elapsed))
