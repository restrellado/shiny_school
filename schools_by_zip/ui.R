library(shiny)
library(leaflet)

shinyUI(fluidPage(
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       
      textInput("zip", "Enter a zip code", value = "95670"), 
      
      actionButton("go", "Go"), 
      
      textOutput("message")
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      
      h3("Find Schools By Zip Code"), 
      
      "This shiny app takes the five digit zip code you enter and displays
      California public schools in that area. The zipcode should be five 
      digits and needs to be in California in order to get results. Clicking 
      on the map markers will display the name of the school. The original
      data used in this shiny app can be found at the California Department 
      of Education.", 
      
      leafletOutput("cde_map")
      
    )
  )
))
