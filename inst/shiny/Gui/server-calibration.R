userWeightsexist <- reactive({
  if(is.null(userWeights())){
  return("user: None")
  } else {
    return(userWeights())
  }
})

observeEvent(input$caliDo, {

  options(warn=-1) # temporally hide Unknown or uninitialised column: `IS` warnings

  shiny::validate(need(nrow(userInput()) > 0, "No data"))

  withProgress(message = 'Calibration in progress',
               detail = 'It may take a while...', {

                 M1 <- userInput() %>%
                   dplyr::group_by(Compound) %>%
                   dplyr::do(CCWeights::doCalibration(., weights = NULL))

                 M2 <- userInput() %>%
                   dplyr::group_by(Compound) %>%
                   dplyr::do(CCWeights::doCalibration(., weights = "1/x"))

                 M3 <- userInput() %>%
                   dplyr::group_by(Compound) %>%
                   dplyr::do(CCWeights::doCalibration(., weights = "1/x^2"))

                 M4 <- userInput() %>%
                   dplyr::group_by(Compound) %>%
                   dplyr::do(CCWeights::doCalibration(., weights = "1/y"))

                 M5 <- userInput() %>%
                   dplyr::group_by(Compound) %>%
                   dplyr::do(CCWeights::doCalibration(., weights = "1/y^2"))

                 M6 <- userInput() %>%
                   dplyr::group_by(Compound) %>%
                   dplyr::do(CCWeights::doCalibration(., weights =  userWeightsexist()))

                 CaliFinal <- rbind.data.frame(M1, M2, M3, M4, M5, M6)

                 output$caliResult <- renderDataTable({
                   datatable(CaliFinal,
                             class = 'cell-border stripe',
                             rownames = FALSE,
                             options = list(scrollX = TRUE))
                   })

                 output$caliSave<- downloadHandler(
                   filename = function() {
                     paste("calibrationResults_", Sys.Date(), ".csv", sep="")
                     },
                   content = function(file) {
                     write.csv(CaliFinal, file, row.names = FALSE)
                     }
                   )
                 })
  })
