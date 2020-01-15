## code to prepare `mock_response` dataset goes here
mock_data <- read.csv("data-raw/mock_data.csv", fileEncoding = 'UTF-8')


usethis::use_data(mock_data, overwrite = TRUE)