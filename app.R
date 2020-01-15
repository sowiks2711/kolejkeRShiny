# Launch the ShinyApp (Do not remove this comment)
# To deploy, run: rsconnect::deployApp()
# Or use the blue button on top of this file

# bypassing error when extrafont from user spawn process tries to do instert to extrafontdb
# belonging to root
# https://stackoverflow.com/questions/51812219/using-custom-fonts-on-shinyapps-io
.libPaths(c('r-lib', .libPaths()))
install.packages('r-lib/extrafontdb_1.0.tar.gz',type = 'source',repos = NULL)
install.packages('extrafont', repos = "http://cran.us.r-project.org")
pkgload::load_all()
font_import(paths="/usr/share/fonts/truetype/font-awesome/", prompt = FALSE)
loadfonts()
print(fonts())
options( "golem.app.prod" = TRUE)
kolejkeRShiny::run_app() # add parameters here (if any)
