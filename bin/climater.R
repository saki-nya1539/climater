#!/usr/bin/env Rscript

# ClimateR CLI エントリポイント。
# 使い方: Rscript bin/climater.R <csvファイル> [--baseline START:END] [--plot 出力先.png]

# Rscriptから実行されたスクリプト自身のディレクトリを特定する定番のイディオム。
file_arg <- grep("--file=", commandArgs(trailingOnly = FALSE), value = TRUE)
script_dir <- if (length(file_arg) > 0) dirname(sub("--file=", "", file_arg)) else "."

source(file.path(script_dir, "..", "R", "load_data.R"))
source(file.path(script_dir, "..", "R", "stats.R"))
source(file.path(script_dir, "..", "R", "trend.R"))
source(file.path(script_dir, "..", "R", "report.R"))

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 1) {
  cat("使い方: Rscript bin/climater.R <csvファイル> [--baseline START:END] [--plot 出力先.png]\n")
  quit(status = 1)
}

csv_path <- args[1]
rest <- if (length(args) > 1) args[2:length(args)] else character(0)

baseline <- 1991:2020
plot_path <- NULL

i <- 1
while (i <= length(rest)) {
  if (rest[i] == "--baseline" && i + 1 <= length(rest)) {
    parts <- as.integer(strsplit(rest[i + 1], ":")[[1]])
    baseline <- parts[1]:parts[2]
    i <- i + 2
  } else if (rest[i] == "--plot" && i + 1 <= length(rest)) {
    plot_path <- rest[i + 1]
    i <- i + 2
  } else {
    i <- i + 1
  }
}

df <- tryCatch(
  load_climate_data(csv_path),
  error = function(e) {
    cat(sprintf("error: %s\n", conditionMessage(e)))
    quit(status = 1)
  }
)

report <- tryCatch(
  build_report(df, baseline),
  error = function(e) {
    cat(sprintf("error: %s\n", conditionMessage(e)))
    quit(status = 1)
  }
)

cat(report, "\n")

if (!is.null(plot_path)) {
  yearly <- temperature_anomaly(df, baseline)
  trend <- temperature_trend(yearly[, c("year", "mean_temperature")])

  png(plot_path, width = 800, height = 500)
  plot(yearly$year, yearly$mean_temperature,
    type = "o", pch = 19, col = "steelblue",
    xlab = "年", ylab = "平均気温(C)", main = "年平均気温の推移"
  )
  abline(a = trend$intercept, b = trend$slope_per_year, col = "firebrick", lwd = 2, lty = 2)
  dev.off()
  cat(sprintf("グラフを %s に保存しました\n", plot_path))
}
