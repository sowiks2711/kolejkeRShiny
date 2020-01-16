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
                             i18n$t("Select office"),
                             choices = c())),
          helper(selectizeInput("queue", i18n$t("Select available queue"), choices = "")),
          actionButton("submit", label = i18n$t("Print results"))
        ),
        mainPanel(
        
          tabsetPanel(
            tabPanel(
              "Plot",
              plotOutput("open_booths_vis")
            ),
            tabPanel(i18n$t("Current state"),
              textOutput("result1"),
              textOutput("result2"),
              textOutput("result3")
            ),
            tabPanel(i18n$t("Table"), DTOutput("result4")),
            tabPanel(i18n$t("Predictions"), textOutput("result5"))
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
