## code to prepare `mock_response` dataset goes here
mock_offices_data <- read.csv("data-raw/mock_data.csv")

mock_offices_data %>% arrange(desc(liczbaKlwKolejce))

usethis::use_data("mock_response")
