# 気候データCSVの読み込みを担当する。
#
# 期待するCSVの列:
#   date        - YYYY-MM-DD形式の日付
#   temperature - 数値(摂氏)。日別・月別どちらの粒度でも可
#   precipitation - 数値(mm)。任意列(無くてもよい)

#' 気候データCSVを読み込み、date列をDate型に変換して日付順に返す
load_climate_data <- function(path) {
  if (!file.exists(path)) {
    stop(sprintf("file not found: %s", path))
  }

  df <- read.csv(path, stringsAsFactors = FALSE)

  required_cols <- c("date", "temperature")
  missing_cols <- setdiff(required_cols, names(df))
  if (length(missing_cols) > 0) {
    stop(sprintf("missing required columns: %s", paste(missing_cols, collapse = ", ")))
  }

  df$date <- as.Date(df$date)
  if (any(is.na(df$date))) {
    stop("some rows have an invalid date")
  }
  if (!is.numeric(df$temperature)) {
    stop("temperature column must be numeric")
  }

  df[order(df$date), ]
}
