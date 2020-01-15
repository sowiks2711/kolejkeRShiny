#' @import shiny
#' @import ggplot2
#' @import waffle
#' @import RColorBrewer
#' @import extrafont
app_server <- function(input, output,session) {
  # List the first level callModules here
    offices <- reactive({
      #kolejkeR::get_available_offices()
      unique(mock_data[["name"]])
    }) 
    queue_data <- reactive({
      if (.Platform$OS.type == "windows") {
        mock_data$nazwaGrupy <- iconv(mock_data$nazwaGrupy, from="utf-8", to="cp1250")
      }
      mock_data[mock_data$name == input$of & mock_data$nazwaGrupy == input$queue,]
    })
    observe({
      updateSelectInput(session, "of", "Select office", choices = offices(), selected = offices()[1])
    })
    choices <- reactive({
      #kolejkeR::get_available_queues(
      #  ifelse(input$of == '', offices()[1], input$of)
      #)
      office_name = input$of
      if(office_name== '') {
        office_name <- offices()[1] 
      }
      
      unique(mock_data[mock_data$name == office_name,'nazwaGrupy'])
    })
    
    observe({
      updateSelectizeInput(session, "queue", "Select available queue", choices = choices())
    })
    
    results <- rv(res1="", res2="", res3="")
    observeEvent(input$submit,{
      if (!input$queue %in% choices()) return()
      service_booths <- queue_data()[['liczbaCzynnychStan']]
      queuers <- queue_data()[['liczbaKlwKolejce']] 
      
      output$open_booths_vis <- renderQueuePlot(
        queue_data()[['liczbaCzynnychStan']], 
        queue_data()[['liczbaKlwKolejce']], 
        input$of, 
        input$queue
      )

      
      results$res1 <- kolejkeR::get_current_ticket_number_verbose(input$of,input$queue)
      results$res2 <- kolejkeR::get_number_of_people_verbose(input$of,input$queue)
      results$res3 <- kolejkeR::get_waiting_time_verbose(input$of,input$queue)
    })
    output$result1 <- renderText(results$res1)
    output$result2 <- renderText(results$res2)
    output$result3 <- renderText(results$res3)
    output$result4 <- renderText("Summary")
    output$result5 <- renderText("Table")
} 

renderQueuePlot <- function(service_booths, queuers, office, queue_name) {
  renderPlot({
    if (service_booths <= 0 ) {
      ggplot() +
        ggtitle(label = "Brak otwartych stanowisk!")
      
    } else {
      waffle(
        #c(`Serving booths` = service_booths, `Queuers` = queuers),
        #c(`Stanowiska obslugi` = service_booths, `Osoby w kolejce` = queuers),
        c(`Stanowiska obslugi` = service_booths, `Stojący w kolejce` = queuers),
        rows = service_booths,
        use_glyph = c("institution", "child"),
        colors=brewer.pal(n = 3, name = "Set2")[-3],
        glyph_size = 10
        ) +
        theme(legend.position = "bottom", legend.direction = "horizontal"
      ) + ggtitle(label = gsub("_", " ", office), subtitle = queue_name)
    }
  })
}
