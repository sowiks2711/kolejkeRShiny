
#' @import shiny
#' @import shinyhelper
app_ui <- function() {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    fluidPage(
      titlePanel("kolejkeR"),
      sidebarLayout(
        sidebarPanel(
          helper(
            selectInput("of", "Select office", choices = c())
          ),
          #conditionalPanel(condition = "typeof input.of === 'undefined' || input.of == null", uiOutput("Queue"))
          # dzięki selectizeInput mamy autocomplete, ale trzeba obsłużyć brzydkie inputy
          helper(
            selectizeInput("queue", "Select available queue", choices = "")
          ),
          actionButton("submit", label = "Print results")
        ),
        mainPanel(
          # helper(textOutput("result1")),
          # textOutput("result2"),
          # textOutput("result3")
          tabsetPanel(
            tabPanel(
              "Plot",
              plotOutput("open_booths_vis")
              #fluidRow(
              #  column(3, plotOutput("open_booths_vis")),
              #  column(9, plotOutput("queuers_vis"))
              #),
              
            ),
            tabPanel("Summary", 
              textOutput("result1"),
              textOutput("result2"),
              textOutput("result3"),
              textOutput("result4")
            ),
            tabPanel("Table", textOutput("result5"))
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
