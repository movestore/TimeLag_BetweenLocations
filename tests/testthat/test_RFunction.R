library('move2')

test_data <- test_data("input3_move2.rds") #file must be move2!

test_that("equal units", {
  actual <- rFunction(data = test_data, units="s")
  expect_equal(units(actual$timelag)$numerator, "s")
})
