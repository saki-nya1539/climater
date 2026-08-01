test_load_data <- function(h) {
  harness_run(h, "存在しないファイルはエラーになる", function() {
    assert_error(function() load_climate_data("/tmp/climater_does_not_exist_12345.csv"))
  })

  harness_run(h, "必須列(temperature)が欠けているとエラーになる", function() {
    tmp <- tempfile(fileext = ".csv")
    write.csv(data.frame(date = c("2020-01-01"), foo = c(1)), tmp, row.names = FALSE)
    assert_error(function() load_climate_data(tmp))
  })

  harness_run(h, "不正な日付が含まれるとエラーになる", function() {
    tmp <- tempfile(fileext = ".csv")
    write.csv(data.frame(date = c("not-a-date"), temperature = c(1)), tmp, row.names = FALSE)
    assert_error(function() load_climate_data(tmp))
  })

  harness_run(h, "正常なCSVを読み込み、日付順にソートして返す", function() {
    tmp <- tempfile(fileext = ".csv")
    write.csv(data.frame(
      date = c("2020-01-02", "2020-01-01"),
      temperature = c(5.5, 4.0)
    ), tmp, row.names = FALSE)
    df <- load_climate_data(tmp)
    assert_equal(2, nrow(df))
    assert_true(df$date[1] < df$date[2])
    assert_equal(4.0, df$temperature[1])
  })
}
