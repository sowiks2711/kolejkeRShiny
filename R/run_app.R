#' Run the Shiny Application
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
run_app <- function(...) {
  #if (!dir.exists('~/.fonts')) {
  #  print("Creating .fonts folder!")
  #  dir.create('~/.fonts')
  #}
  #file.copy("./inst/app/www/awesome_font.ttf", "~/.fonts")
  #download.file("http://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/fonts/fontawesome-webfont.ttf?v=4.3.0",
  #              destfile = "./inst/app/www/awesome_font.ttf", method = "curl")
  #system('fc-cache -f ~/.fonts')

  with_golem_options(
    app = shinyApp(ui = app_ui, server = app_server), 
    golem_opts = list(...)
  )
}
