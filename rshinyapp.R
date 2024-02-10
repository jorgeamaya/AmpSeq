library(shiny)

# Define UI
ui <- fluidPage(
  titlePanel("Select Elements"),
  
  fluidRow(
    sidebarPanel(
      checkboxGroupInput("elements1", "Select Genes:",
                         choices = c("PfDHFR", "PfMDR1" , "PfDHPS", "PfKelch13", "PF3D7_1447900"),
                         selected = NULL),
      br(),
      downloadButton("downloadCSV1", "Download Genes")
    ),
    
    sidebarPanel(
      checkboxGroupInput("elements2", "Select Locations:",
                         choices = c("Quibdó", "Buenaventura" , "Guapi" , "Tumaco", "PuertoInírida"),
                         selected = NULL),
      br(),
      downloadButton("downloadCSV2", "Download Locations")
    ),
    
    sidebarPanel(
      checkboxGroupInput("elements4", "Select Colors:",
                         choices = c("red", "blue", "yellow", "grey", "black"),
                         selected = NULL),
      br(),
      downloadButton("downloadCSV4", "Download Colors")
    ),
    
    sidebarPanel(
      checkboxGroupInput("elements3", "Select Quarters of Collection:",
                         choices = c("2020-Q4", "2021-Q1", "2021-Q2", "2021-Q3", "2021-Q4", "2022-Q1", "2022-Q2", "2022-Q3"),
                         selected = NULL),
      br(),
      downloadButton("downloadCSV3", "Download Quarters of Collection")
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  # Function to create CSV for Set 1
  output$downloadCSV1 <- downloadHandler(
    filename = function() {
      paste("selected_elements_set1.csv", sep = "")
    },
    
    content = function(file) {
      # Create data frame with selected elements
      selected_df <- data.frame(Selected_Element = input$elements1)
      
      # Write CSV
      write.csv(selected_df, file, row.names = FALSE)
    }
  )
  
  # Function to create CSV for Set 2
  output$downloadCSV2 <- downloadHandler(
    filename = function() {
      paste("selected_elements_set2.csv", sep = "")
    },
    
    content = function(file) {
      # Create data frame with selected elements
      selected_df <- data.frame(Selected_Element = input$elements2)
      
      # Write CSV
      write.csv(selected_df, file, row.names = FALSE)
    }
  )
  
  # Function to create CSV for Set 4
  output$downloadCSV2 <- downloadHandler(
    filename = function() {
      paste("selected_elements_set4.csv", sep = "")
    },
    
    content = function(file) {
      # Create data frame with selected elements
      selected_df <- data.frame(Selected_Element = input$elements2)
      
      # Write CSV
      write.csv(selected_df, file, row.names = FALSE)
    }
  )
  
  # Function to create CSV for Set 3
  output$downloadCSV3 <- downloadHandler(
    filename = function() {
      paste("selected_elements_set3.csv", sep = "")
    },
    
    content = function(file) {
      # Create data frame with selected elements
      selected_df <- data.frame(Selected_Element = input$elements3)
      
      # Write CSV
      write.csv(selected_df, file, row.names = FALSE)
    }
  )
}

# Run the application
shinyApp(ui = ui, server = server)
