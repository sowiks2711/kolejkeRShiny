#' @import shiny
#' @import shinyhelper
#' @import shinycssloaders
#' @import DT
#' @import shiny.i18n
app_ui <- function() {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    fluidPage(
      titlePanel("kolejkeR"),
      sidebarLayout(
        sidebarPanel(
          helper(selectInput("of",
                             textOutput("of_label"),
                             choices = c())),
          helper(selectizeInput("queue", textOutput("queue_label"), choices = "")),
          actionButton("submit", textOutput("submit_label"))
        ),
        mainPanel(
        
          tabsetPanel(
            tabPanel(
              textOutput("diagram_label"),
              plotOutput("open_booths_vis")
            ),
            tabPanel(textOutput("state_label"),
              textOutput("result1"),
              textOutput("result2"),
              textOutput("result3")
            ),
            tabPanel(textOutput("table_label"), DTOutput("result4")),
            tabPanel(textOutput("predictions_label"), textOutput("result5"))
        )
        )
      )
    )
  )
}

#' @import shiny
golem_add_external_resources <- function(){
  
  addResourcePath(
    'www', system.file('app/www', package = 'kolejkeRShiny')
  )
 
  tags$head(
    golem::activate_js(),
    golem::favicon()
    # Add here all the external resources
    # If you have a custom.css in the inst/app/www
    # Or for example, you can add shinyalert::useShinyalert() here
    #tags$link(rel="stylesheet", type="text/css", href="www/custom.css")
  )
}
