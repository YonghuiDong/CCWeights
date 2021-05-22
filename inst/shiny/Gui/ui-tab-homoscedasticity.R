fluidRow(

  column(width = 12,

         bs4Card(
           width = 12,
           title = "Instruction",
           status = "secondary",
           solidHeader = FALSE,
           collapsible = TRUE,
           collapsed = FALSE,
           closable = FALSE,
           p("The assumption of homoscedasticity is central to linear regression models.
             Homoscedasticity describes a situation in which the error term is the same across
             all values of the independent variables"),
           p("2. You can click '+' to view the example file in the loaded file tab. Two example files are provided here.'")
           )
         ),

  column(width = 3,

         bs4Card(
           width = 12,
           inputId = "homoTest_card",
           title = "Homoscedasticity Test Parameters",
           status = "primary",
           solidHeader = FALSE,
           collapsible = FALSE,
           collapsed = FALSE,
           closable = FALSE,
           numericInput("pval_cutoff", strong("p-value threshold"), value = 0.01, min = 0, max = 1, step = 0.01),
           actionButton("homoTest", "Start Test", icon("paper-plane"),
                        style="color: #fff; background-color: #CD0000; border-color: #9E0000")
           )
         ),

  column(width = 9,

         bs4Card(
           width = 12,
           inputId = "homoResult_card",
           title = "Homoscedasticity Test Result",
           status = "secondary",
           solidHeader = FALSE,
           collapsible = TRUE,
           collapsed = FALSE,
           closable = FALSE,
           DT::dataTableOutput("homescedasticityResult")
           )
         )
  )





