# PixelForge/PhysiSim/BookNest/TaskRexpress/HabitVapor/NoteKtと同じ設計思想の
# 自作アサーションハーネス。testthat(外部パッケージ)は使わず、素朴なassert
# スタイルで統一している。通常のlist()はコピーオンモディファイなので、
# 呼び出しをまたいでカウンタを蓄積できるよう環境(environment)を使っている。

new_harness <- function() {
  env <- new.env()
  env$passed <- 0
  env$failed <- 0
  env$failures <- character(0)
  env
}

harness_run <- function(h, name, fn) {
  result <- tryCatch(
    {
      fn()
      TRUE
    },
    error = function(e) conditionMessage(e)
  )

  if (isTRUE(result)) {
    h$passed <- h$passed + 1
    cat(sprintf("  [OK] %s\n", name))
  } else {
    h$failed <- h$failed + 1
    h$failures <- c(h$failures, sprintf("%s: %s", name, result))
    cat(sprintf("  [NG] %s: %s\n", name, result))
  }
}

assert_true <- function(condition, message = "expected TRUE") {
  if (!isTRUE(condition)) stop(message)
}

assert_equal <- function(expected, actual, message = NULL, tolerance = 1e-8) {
  ok <- isTRUE(all.equal(expected, actual, tolerance = tolerance))
  if (!ok) {
    msg <- if (!is.null(message)) message else sprintf("expected <%s>, got <%s>", toString(expected), toString(actual))
    stop(msg)
  }
}

assert_error <- function(fn, message = "expected an error to be thrown") {
  thrown <- tryCatch(
    {
      fn()
      FALSE
    },
    error = function(e) TRUE
  )
  if (!thrown) stop(message)
}

harness_summary <- function(h) {
  list(passed = h$passed, failed = h$failed, failures = h$failures)
}
