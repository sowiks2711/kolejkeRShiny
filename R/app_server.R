#' @import shiny
#' @import ggplot2
#' @import waffle
#' @import RColorBrewer
#' @import extrafont
app_server <- function(input, output,session) {
    lang <- reactive(
      input$lang
    )
    i18n_r <- reactive({
      i18n$set_translation_language(input$lang)
      i18n
    })
    use_mock <- reactive(
      ifelse(input$mock == "TRUE", TRUE, FALSE)
    )
  # List the first level callModules here
    offices <- reactive({
      result <- unique(mock_data[["name"]])
      result
    })
    raw_data <- reactive({
      result <- mock_data[mock_data$name == input$of,]
      if(!use_mock()) {
        result <- kolejkeR::get_raw_data(input$of)
      }
      result
    })
    queue_data <- reactive({
      raw_data()[raw_data()$nazwaGrupy == input$queue,]
    })
    
    observe({
      updateSelectInput(session, "of", i18n_r()$t("Select office"), choices = offices(), selected = offices()[1])
    })
    observe({
      updateSelectizeInput(session, "queue", i18n_r()$t("Select available queue"), choices = choices())
    })
    
    observe({
      updateActionButton(session, "submit", label = i18n_r()$t("Print results"))
    })
    output$of_label = renderText(i18n_r()$t("Select office"))
    output$queue_label = renderText(i18n_r()$t("Select available queue"))
    output$submit_label = renderText(i18n_r()$t("Print results"))
    output$diagram_label = renderText(i18n_r()$t("Diagram"))
    output$state_label = renderText(i18n_r()$t("Current state"))
    output$table_label = renderText(i18n_r()$t("Table"))
    output$predictions_label = renderText(i18n_r()$t("Predictions"))
    output$lang_label = renderText(i18n_r()$t("Select language"))
    output$mock_label = renderText(i18n_r()$t("Data source"))
    
    
    choices <- reactive({
      office_name = input$of
      if(office_name== '') {
        office_name <- offices()[1] 
      }
      
      #kolejkeR::get_available_queues(office_name)
      unique(mock_data[mock_data$name == office_name,'nazwaGrupy'])
    })
    
    results <- rv(res1="", res2="", res3="")
    observeEvent(input$submit,{
      
      if (!input$queue %in% choices()) return()
      
      results$res1 <- kolejkeR::get_current_ticket_number_verbose(input$of,input$queue, language = lang())
      results$res2 <- kolejkeR::get_number_of_people_verbose(input$of,input$queue, language = lang())
      results$res3 <- kolejkeR::get_waiting_time_verbose(input$of,input$queue, language = lang())
      results$res4 <- raw_data()
      
      service_booths <- queue_data()[['liczbaCzynnychStan']]
      queuers <- queue_data()[['liczbaKlwKolejce']] 
      
      output$open_booths_vis <- renderQueuePlot(
        queue_data()[['liczbaCzynnychStan']], 
        queue_data()[['liczbaKlwKolejce']], 
        input$of, 
        input$queue
      )
    })
    output$result1 <- renderText(results$res1)
    output$result2 <- renderText(results$res2)
    output$result3 <- renderText(results$res3)
    output$result4 <- renderDT(results$res4)
    output$result5 <- renderText(i18n$t("Summary"))
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
      theme(legend.position = "bottom", legend.direction = "horizontal") + 
      ggtitle(label = gsub("_", " ", office), subtitle = queue_name)
    }
  })
}
