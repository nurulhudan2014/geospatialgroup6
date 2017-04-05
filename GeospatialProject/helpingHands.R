library(leaflet)
library(rgdal)
#mpsz_svy21 <- readOGR(dsn="shapefile", layer="MP14_SUBZONE_NO_SEA_PL")
#shops <- read.csv ("attributetable/shops.csv")
#Footpath<- readOGR(dsn="shapefile", layer="Footpath")
#NeighbourhoodAmenities <- read.csv ("attributetable/NeighbourhoodAmenities.csv")
#HDB <- read.csv ("attributetable/HDB.csv")

#plot.shops <- SpatialPointsDataFrame(shops[,8:9],
 #                                    shops,    #the R object to convert
#                                     proj4string = CRS("+proj=longlat +datum=WGS84"))

#plot.NeighbourhoodAmenities <- SpatialPointsDataFrame(NeighbourhoodAmenities[,7:8],
 #                                                     NeighbourhoodAmenities,    #the R object to convert
  #                                                    proj4string = CRS("+proj=longlat +datum=WGS84"))


#plot.HDB <- SpatialPointsDataFrame(HDB[,6:7],
 #                                  HDB,    #the R object to convert
  #                                 proj4string = CRS("+proj=longlat +datum=WGS84"))


server<-(function(input, output) {

  
  
  output$map <- renderLeaflet({
    df <- shops[shops$CATEGORY == input$CATEGORY,]  
    m<-leaflet()  %>%
      setView(103.777395,1.428903, zoom = 17)
      m%>%addTiles() %>%
      addCircles(~LONGITUDE,~LATITUDE,
                   popup=~POI_ADD,data=HDB
                  
                   )%>%
        
     addMarkers(~LONGITUDE,~LATITUDE,
                 popup=~POI_NAME,data=shops
                 
      )%>%
        addMarkers(~LONGITUDE,~LATITUDE,
                   popup=~POI_NAME,data=NeighbourhoodAmenities
                   
        )
   #addPolylines(data=Footpath, color="red")   
      
  

    
  })
  
})

library(shiny)
library(leaflet)


ui<-fluidPage(
  navbarPage(title="Helping Hands",
             tabPanel(title = "Map View",
     fluidRow(   
              column(8, (leafletOutput("map","100%",600))),
              column(4,fluidPage(tags$h4("-Displaying ramps 500m buffered"),
                                 tags$h4(""),
                                 tags$h4("Sensitivity Analysis"),sliderInput(inputId = "num",
                                   label = "Choose a Distance",
                                   value = 500, min = 500, max = 600))
              )
      )
              ),
  navbarMenu(title = "Accessibility",
             tabPanel(title = "Hansen Potential Model"),
                  
             
             tabPanel(title = "Weighted Matrix"),
                      
                   
             
             tabPanel(title = "Manual distance according to footpath")),
                      
                        
              
             tabPanel(title="Statistics"),
             fluidRow(column(8,""), 
                      column(4,fluidPage(tags$h4("HISTOGRAM: Distribution of public amenities according to number and type of public amenities."),
tags$br(),
tags$h6( " <Fig1> Number of clinics/Dining/ATM/Optical Goods & Eyewear/public amenities[Y]
                                                 Types of clinics/Dining/ATM/Optical Goods & Eyewear/public amenities[X]")
,tags$br(),tags$h4("TABLE: Distribution of public amenities according to postal code and closest type of public amenities "),
tags$h6( " <Fig2>Public Amenities[X],  Postal Code [Y] ")

)
           )
  )
            
 
             
  ))
     
  




shinyApp(server = server, ui = ui)