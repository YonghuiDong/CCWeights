userWeightsexist <- reactive({
  if(is.null(userWeights())){
  return("user: None")
  }
})

observeEvent(input$caliDo, {

  shiny::validate(need(nrow(userInput()) > 0, "No data"))

  M1 <- CCWeights::doCalibration(DF = userInput(), weights = NULL)
  M2 <- CCWeights::doCalibration(DF = userInput(), weights = "1/x")
  M3 <- CCWeights::doCalibration(DF = userInput(), weights = "1/x^2")
  M4 <- CCWeights::doCalibration(DF = userInput(), weights = "1/y")
  M5 <- CCWeights::doCalibration(DF = userInput(), weights = "1/y^2")
  M6 <- CCWeights::doCalibration(DF = userInput(), weights = userWeightsexist())
  CaliFinal <- rbind.data.frame(M1, M2, M3, M4, M5, M6)

  output$caliResult <- renderDataTable({
    datatable(CaliFinal,
              class = 'cell-border stripe',
              rownames = FALSE,
              options = list(scrollX = TRUE))
    })

  output$caliSave<- downloadHandler(
    filename = function() {
      paste("Calibration_Results_", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      write.csv(CaliFinal, file)
    }
  )

})
