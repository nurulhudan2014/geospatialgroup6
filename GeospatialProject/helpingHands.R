library(leaflet)
library(rgdal)
library(raster)
library(ggplot2)



#mpsz_svy21 <- readOGR(dsn="shapefile", layer="MP14_SUBZONE_NO_SEA_PL")
#shops <- read.csv ("attributetable/shops.csv")
#footpath<- readOGR(dsn="shapefile", layer="footpaths")
#footpath<-spTransform(footpath, CRS("+proj=utm +zone=48N +datum=WGS84"))
#footpath<-spTransform(footpath, CRS("+proj=longlat +datum=WGS84"))
#NeighbourhoodAmenities <- read.csv ("attributetable/NeighbourhoodAmenities.csv")
#Ramps <- read.csv ("attributetable/Ramps.csv")

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

#library(ggplot2)
#ggplot(data.frame(shops),aes(x=shops$CATEGORY))+geom_bar()+xlab("Categories of Necessary Amenities")+ylab("Number of Shops per Category")

#library(rgeos)
#coordinates( Ramps ) <- c( "LONGITUDE", "LATITUDE" )
# proj4string( Ramps ) <- CRS( "+proj=longlat +datum=WGS84" )
#pc <- spTransform( Ramps, CRS( "+init=epsg:3414" ) ) 
#crs(Ramps)
#pc5km <- gBuffer( pc, width=5*1000, byid=TRUE )
#> writeOGR( pc5km, "Ramps5km", "Ramps5km", driver="ESRI Shapefile" )

##library(plyr)
##shop_category<-count(shops,'CATEGORY')
#ptsfootpath = as(footpath, "SpatialPointsDataFrame")
#library(geosphere)
#distancematrixhdbshops <- distm(shops[,c('LONGITUDE','LATITUDE')], HDB[,c('LONGITUDE','LATITUDE')], fun=distVincentyEllipsoid)
# shops$NEAREST_POSTCODE <- HDB$POSTCODE[max.col(-distancematrixhdbshops)]
# shops$NEAREST_DIST <- apply(distancematrixhdbshops, 1, min)

#coordinates(plot.NeighbourhoodAmenities) <- cbind(NeighbourhoodAmenities$LONGITUDE , NeighbourhoodAmenities$LATITUDE)
#proj4string(plot.NeighbourhoodAmenities) = CRS(espg.3414)
ramps <- read.csv ("attributetable/Ramps.csv")
icon.shops <- makeAwesomeIcon(icon= 'shopping-cart', markerColor = 'red', iconColor = 'white')
icon.ramps <- makeAwesomeIcon(icon= 'road', markerColor = 'green', iconColor = 'white')
icon.neighbourhood<-makeAwesomeIcon(icon= 'blackboard', markerColor = 'blue', iconColor = 'white')


server<-(function(input, output) {
  
  output$bar <- renderPlot({
    
    ggplot(data.frame(shops),aes(x=shops$CATEGORY))+geom_bar(fill="green", colour="black",size=0)+
      xlab("Categories of Necessary Amenities")+
      ylab("Number of Shops per Category")
  })
  
  output$map <- renderLeaflet({
    df <- shops[shops$CATEGORY == input$CATEGORY,]  
    m<-leaflet()  %>%
      addTiles(
        urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>%
      setView(103.777395,1.428903, zoom = 17)
    m%>%addTiles() %>%
      addCircleMarkers(~LONGITUDE,~LATITUDE,
                       popup=~POI_ADD,data=HDB
                       
      )%>%
      
      addAwesomeMarkers(~LONGITUDE,~LATITUDE,
                        popup=~POI_NAME,data=shops, icon=icon.shops
                        
      )%>%
     addAwesomeMarkers(~LONGITUDE,~LATITUDE,
                       popup=~POI_ADD,data=ramps, icon=icon.ramps) %>%
      
      addAwesomeMarkers(~LONGITUDE,~LATITUDE,
                        popup=~POI_NAME,data=NeighbourhoodAmenities,icon= icon.neighbourhood
                        
      )%>%
      addPolylines(data=footpath, color="red")   %>%
      addPolygons(data=pc5km)
    
    
    
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
             
             
             
             tabPanel(title="Statistics",
                      fluidRow(column(12,fluidPage(tags$h4("HISTOGRAM: Distribution of public amenities according to number and type of public amenities."),
                                                  tags$br(),plotOutput("bar"),
                                                  tags$h6( " <Fig1> Number of clinics/Dining/ATM/Optical Goods & Eyewear/public amenities[Y]
                                                 Types of clinics/Dining/ATM/Optical Goods & Eyewear/public amenities[X]")
                                                  ,tags$br(),tags$h4("TABLE: Distribution of public amenities according to postal code and closest type of public amenities "),
                                                  tags$h6( " <Fig2>Public Amenities[X],  Postal Code [Y] ")
                                                  
                               )
                               )
                      )
                      
             )
             
  ))



shinyApp(server = server, ui = ui)