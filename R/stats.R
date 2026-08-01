# 年別・月別の集計と、基準期間からの気温偏差(アノマリー)計算を担当する。

#' 年ごとの平均気温を計算する
#' @return data.frame(year, mean_temperature)
yearly_mean_temperature <- function(df) {
  years <- format(df$date, "%Y")
  means <- tapply(df$temperature, years, mean, na.rm = TRUE)
  result <- data.frame(year = as.integer(names(means)), mean_temperature = as.numeric(means))
  result[order(result$year), ]
}

#' 月ごとの平均気温を計算する(全年をまたいで月別に集計)
#' @return data.frame(month, mean_temperature)
monthly_mean_temperature <- function(df) {
  months <- format(df$date, "%m")
  means <- tapply(df$temperature, months, mean, na.rm = TRUE)
  result <- data.frame(month = as.integer(names(means)), mean_temperature = as.numeric(means))
  result[order(result$month), ]
}

#' baseline_years(例: 1991:2020)の平均気温を基準に、年ごとのアノマリー(偏差)を計算する
#' @return data.frame(year, mean_temperature, anomaly)
temperature_anomaly <- function(df, baseline_years) {
  yearly <- yearly_mean_temperature(df)
  baseline <- yearly[yearly$year %in% baseline_years, ]
  if (nrow(baseline) == 0) {
    stop("no data found within the baseline period")
  }
  baseline_mean <- mean(baseline$mean_temperature)
  yearly$anomaly <- yearly$mean_temperature - baseline_mean
  yearly
}
