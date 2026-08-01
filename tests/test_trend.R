test_trend <- function(h) {
  harness_run(h, "完全な線形データからは正確な傾きを推定できる", function() {
    yearly <- data.frame(year = 2000:2009, mean_temperature = 10 + 0.5 * (0:9))
    trend <- temperature_trend(yearly)
    assert_equal(0.5, trend$slope_per_year, tolerance = 1e-6)
    assert_equal(1, trend$r_squared, tolerance = 1e-6)
  })

  harness_run(h, "データが1年分だとエラーになる", function() {
    yearly <- data.frame(year = 2020, mean_temperature = 15)
    assert_error(function() temperature_trend(yearly))
  })

  harness_run(h, "predict_temperatureはトレンドから任意年の気温を予測する", function() {
    trend <- list(slope_per_year = 0.5, intercept = 10 - 0.5 * 2000)
    predicted <- predict_temperature(trend, 2010)
    assert_equal(15, predicted, tolerance = 1e-6)
  })

  harness_run(h, "ノイズを含むデータでもトレンドの符号は正しく推定できる", function() {
    set.seed(42)
    years <- 2000:2029
    noise <- c(
      0.12, -0.08, 0.05, -0.15, 0.09, -0.02, 0.18, -0.11, 0.04, -0.06,
      0.13, -0.09, 0.07, -0.14, 0.02, 0.11, -0.05, 0.08, -0.12, 0.06,
      0.15, -0.07, 0.03, -0.1, 0.09, -0.13, 0.01, 0.1, -0.04, 0.05
    )
    temps <- 10 + 0.3 * (years - 2000) + noise
    trend <- temperature_trend(data.frame(year = years, mean_temperature = temps))
    assert_true(trend$slope_per_year > 0)
  })
}
