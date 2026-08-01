# 年平均気温の線形トレンド推定を担当する。base Rのlm()(単回帰)のみを使い、
# 予測パッケージ等の外部依存は一切追加していない。

#' 年平均気温の線形トレンド(1年あたりの気温変化)を最小二乗法で推定する
#' @param yearly_df data.frame(year, mean_temperature)
#' @return list(slope_per_year, intercept, r_squared)
temperature_trend <- function(yearly_df) {
  if (nrow(yearly_df) < 2) {
    stop("at least 2 years of data are required to compute a trend")
  }

  fit <- lm(mean_temperature ~ year, data = yearly_df)
  coefs <- coef(fit)

  list(
    slope_per_year = unname(coefs["year"]),
    intercept = unname(coefs["(Intercept)"]),
    r_squared = summary(fit)$r.squared
  )
}

#' トレンド(temperature_trendの戻り値)を使って、任意の年の気温を線形外挿で予測する
predict_temperature <- function(trend, year) {
  trend$intercept + trend$slope_per_year * year
}
