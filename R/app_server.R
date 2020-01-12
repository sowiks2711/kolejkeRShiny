#' @import shiny
#' @import ggplot2
#' @import waffle
app_server <- function(input, output,session) {
  # List the first level callModules here
    offices <- reactive(
      kolejkeR::get_available_offices()
    ) 
    queue_data <- reactive(
      mock_offices_data[mock_offices_data$name == input$of & mock_offices_data$nazwaGrupy == input$queue,]
    )
    observe({
      updateSelectInput(session, "of", "Select office", choices = offices(), selected = offices()[1])
    })
    choices <- reactive(kolejkeR::get_available_queues(ifelse(input$of == '', offices()[1], input$of)))
    
    observe({
        updateSelectizeInput(session, "queue", "Select available queue", 
                          choices = choices() )
    })
    
    results <- reactiveValues(res1="", res2="", res3="")
    observeEvent(input$submit,{
        if(!input$queue %in% choices()) return()
        output$queue_vis <- renderPlot({
          waffle(queue_data()[['liczbaKlwKolejce']], rows = queue_data()[['liczbaCzynnychStan']], use_glyph = "child")
        })
        results$res1 <- kolejkeR::get_current_ticket_number_verbose(input$of,input$queue)
        results$res2 <- kolejkeR::get_number_of_people_verbose(input$of,input$queue)
        results$res3 <- kolejkeR::get_waiting_time_verbose(input$of,input$queue)
        }
    )
    output$result1 <- renderText(results$res1)
    output$result2 <- renderText(results$res2)
    output$result3 <- renderText(results$res3)
    output$result4 <- renderText("Summary")
    output$result5 <- renderText("Table")
}
