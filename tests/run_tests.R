#!/usr/bin/env Rscript

file_arg <- grep("--file=", commandArgs(trailingOnly = FALSE), value = TRUE)
script_dir <- if (length(file_arg) > 0) dirname(sub("--file=", "", file_arg)) else "."

source(file.path(script_dir, "test_harness.R"))
source(file.path(script_dir, "..", "R", "load_data.R"))
source(file.path(script_dir, "..", "R", "stats.R"))
source(file.path(script_dir, "..", "R", "trend.R"))
source(file.path(script_dir, "test_load_data.R"))
source(file.path(script_dir, "test_stats.R"))
source(file.path(script_dir, "test_trend.R"))

h <- new_harness()

cat("load_data:\n")
test_load_data(h)

cat("\nstats:\n")
test_stats(h)

cat("\ntrend:\n")
test_trend(h)

summary <- harness_summary(h)
cat("\n", strrep("-", 40), "\n", sep = "")
cat(sprintf("passed: %d, failed: %d\n", summary$passed, summary$failed))

if (summary$failed > 0) {
  cat("\nFAILURES:\n")
  for (f in summary$failures) cat(sprintf("  - %s\n", f))
  quit(status = 1)
}

cat("\n全テスト成功\n")
quit(status = 0)
