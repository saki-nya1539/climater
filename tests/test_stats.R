sample_climate_df <- function() {
  data.frame(
    date = as.Date(c("2020-01-15", "2020-06-15", "2021-01-15", "2021-06-15")),
    temperature = c(0, 20, 2, 22)
  )
}

test_stats <- function(h) {
  harness_run(h, "yearly_mean_temperatureは年ごとの平均を計算する", function() {
    yearly <- yearly_mean_temperature(sample_climate_df())
    assert_equal(2, nrow(yearly))
    row_2020 <- yearly[yearly$year == 2020, ]
    assert_equal(10, row_2020$mean_temperature)
  })

  harness_run(h, "monthly_mean_temperatureは月ごとに(年をまたいで)平均を計算する", function() {
    monthly <- monthly_mean_temperature(sample_climate_df())
    row_jan <- monthly[monthly$month == 1, ]
    assert_equal(1, row_jan$mean_temperature) # (0+2)/2
  })

  harness_run(h, "temperature_anomalyは基準期間平均との差を計算する", function() {
    anomaly <- temperature_anomaly(sample_climate_df(), baseline_years = 2020)
    row_2021 <- anomaly[anomaly$year == 2021, ]
    assert_equal(12, row_2021$mean_temperature) # (2+22)/2
    assert_equal(2, row_2021$anomaly) # 12 - 10(baseline)
  })

  harness_run(h, "基準期間にデータが無いとエラーになる", function() {
    assert_error(function() temperature_anomaly(sample_climate_df(), baseline_years = 1999))
  })
}
