# 分析結果を人間が読めるテキストレポートに整形する。

#' 気候データの分析結果をテキストレポートとして整形する
build_report <- function(df, baseline_years) {
  yearly <- temperature_anomaly(df, baseline_years)
  trend <- temperature_trend(yearly[, c("year", "mean_temperature")])

  lines <- c(
    sprintf("期間: %s 〜 %s (%d年分)", min(df$date), max(df$date), nrow(yearly)),
    sprintf("基準期間: %d-%d年", min(baseline_years), max(baseline_years)),
    sprintf("年平均気温トレンド: %+.4f C/年 (10年あたり %+.2f C)", trend$slope_per_year, trend$slope_per_year * 10),
    sprintf("決定係数(R^2): %.3f", trend$r_squared),
    "",
    "年別 平均気温・基準期間との差(アノマリー):"
  )

  for (i in seq_len(nrow(yearly))) {
    lines <- c(lines, sprintf(
      "  %d: %.2f C (anomaly %+.2f C)",
      yearly$year[i], yearly$mean_temperature[i], yearly$anomaly[i]
    ))
  }

  paste(lines, collapse = "\n")
}
