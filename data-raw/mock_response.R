## code to prepare `mock_response` dataset goes here
mock_data <- read.csv("data-raw/mock_data.csv", fileEncoding = 'UTF-8')
library(shiny.i18n)
i18n <- Translator$new(translation_json_path = "data-raw/translation.json")
if (.Platform$OS.type == "windows") {
  mock_data$nazwaGrupy <- iconv(mock_data$nazwaGrupy, from="utf-8", to="cp1250")
}
usethis::use_data(mock_data, overwrite = TRUE)
usethis::use_data(i18n, overwrite = TRUE)

