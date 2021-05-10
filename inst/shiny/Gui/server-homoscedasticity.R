# F-test Function

observeEvent(input$homoTest, {

  output$homescedasticityResult <- renderDataTable({
    
    validate(need(nrow(userInput()) > 0, "No data"))
    datatable(CCWeights::doFtest(DF = userInput(), p = input$pval_cutoff), 
              class = 'cell-border stripe', 
              rownames = FALSE, 
              options = list(scrollX = TRUE))
    })
  
  })
