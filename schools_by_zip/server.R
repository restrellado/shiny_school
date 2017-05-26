library(tidyverse)
library(shiny)
library(leaflet)
library(stringr)

shinyServer(function(input, output) {
  
  # Read and clean data
  if(file.exists("data/pubschls.txt") == FALSE) {
    download.file("ftp://ftp.cde.ca.gov/demo/schlname/pubschls.txt",
                  "data/pubschls.txt",
                  method = "curl")
  }
  
  original <- read_tsv("data/pubschls.txt") 
  
  # Define reactive function to get the zipcode
  zipcode <- eventReactive(input$go, {
    input$zip
  })
  
  # Define message text output 
  output$message <- renderText({
    if(sum(str_detect(original$MailZip, zipcode()), na.rm = T) < 1) {
      "This is not a Californiz zip code"
    } else {
      ""
    } 
  })
  
  # Render the map 
  output$cde_map <- renderLeaflet({

    cde_schls <- original %>%
      filter(StatusType == "Active",
             str_detect(MailZip, zipcode()) == TRUE) %>%
      rename(lat = Latitude, lon = Longitude) %>%
      select(-c(AdmFName1:AdmEmail3, FundingType, Magnet, StatusType,
                Street:State, DOC, CharterNum, SOC, EdOpsCode, EILCode))

    cde_schls %>%
      leaflet() %>%
      addTiles() %>%
      addMarkers(popup = cde_schls$School)

  })
  
})