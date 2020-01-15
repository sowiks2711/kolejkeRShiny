## code to prepare `mock_response` dataset goes here
mock_data <- read.csv("data-raw/mock_data.csv", fileEncoding = 'UTF-8')

#print("Downloading fonts")
#dir.create('~/.fonts')
#download.file("http://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/fonts/fontawesome-webfont.ttf?v=4.3.0",
#              destfile = "~/.fonts/awesome_font.ttf", method = "curl")
#system('fc-cache -f ~/.fonts')

usethis::use_data(mock_data, overwrite = TRUE)