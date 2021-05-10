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
           p("1. You can upload your data in Data Upload tab. CCWeights accepts csv, xls and xlsx formats.'"),
           p("2. Your data should contain at least two columns, i.e., 'concentration' and 'Response'. 
             If your data contains information from more than one metabolites, you need to add an additional column, named 'Compound'.
             If you have stable isotope labeled standards in your data, you need to add a column named 'IS'."),
           p("3. You can load the two example datasets in Data Upload tab to check the data format."),
           p("4. You can view the data in 'Loaded Data' tab, and view the summary statistics of the loaded data in 'Data Summary' tab."),
           p("5. You can click '+' and '-' in the tab to show or hide the contents in the tab.")
           )
         ),
  
  
  column(width = 3,
         
         bs4Card(
           width = 12,
           inputId = "input_card",
           title = "Upload data panel",
           status = "primary",
           solidHeader = FALSE,
           collapsible = FALSE,
           collapsed = FALSE,
           closable = FALSE,
           radioButtons("example_data", "Do you want to view the example data?",
                        choices = c("Yes" = 'yes',
                                    "No, upload my data" = 'umd'),
                        selected = 'yes'),
           conditionalPanel(condition = "input.example_data == 'yes'",
                            radioButtons("example_dataset", "Please choose an example dataset:",
                                         choices = c("Example with internal standard" = 'st000284',
                                                     "Example without internal standard" = 'st000336'
                                                     ),
                                         selected = 'st000284')
                            ),
           conditionalPanel(condition = "input.example_data == 'umd'",
                            fileInput("target","Upload your file (csv/xls/xlsx format):")
                            ),
           actionButton("upload_data", "Submit", icon("paper-plane"),
                        style="color: #fff; background-color: #CD0000; border-color: #9E0000"
                        )
           )
         ),

  
  column(width = 9,
         bs4Card(
           width = 12,
           inputId = "rawData_card",
           title = "Loaded Data",
           status = "secondary",
           solidHeader = FALSE,
           collapsible = TRUE,
           collapsed = FALSE,
           closable = FALSE,
           DT::dataTableOutput("rawData")
           ),
         
         bs4Card(
           width = 12,
           inputId = "summary_card",
           title = "Data Summary",
           status = "secondary",
           solidHeader = FALSE,
           collapsible = TRUE,
           collapsed = TRUE,
           closable = FALSE,
           DT::dataTableOutput("summaryData")
           )
         )
  )

