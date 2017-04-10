library(leaflet)
library(rgdal)
library(raster)
#mpsz_svy21 <- readOGR(dsn="shapefile", layer="MP14_SUBZONE_NO_SEA_PL")
#shops <- read.csv ("attributetable/shops.csv")
#footpath<- readOGR(dsn="shapefile", layer="footpaths")
#footpath<-spTransform(footpath, CRS("+proj=utm +zone=48N +datum=WGS84"))
#footpath<-spTransform(footpath, CRS("+proj=longlat +datum=WGS84"))
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
      addTiles(
        urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>%
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
                   
        )%>%
   addPolylines(data=footpath, color="red")   
      
  

    
  })
  
})

library(shiny)
library(leaflet)


ui<-fluidPage(
  navbarPage(title="Helping Hands",
             tabPanel(title = "Map View"
              ),
  navbarMenu(title = "Accessibility",
             tabPanel(title = "Hansen Potential Model"
                      ,
                      fluidRow(   
                        column(8, (leafletOutput("map","100%",600))),
                        column(4,fluidPage(tags$h4("Accessibility Analysis"),
                                           tags$h4("")
                        )
                        )
                      )
                      ),
                  
             
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