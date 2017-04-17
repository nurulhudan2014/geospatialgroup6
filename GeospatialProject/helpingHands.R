library(leaflet)
library(rgdal)
library(raster)
library(ggplot2)



#mpsz_svy21 <- readOGR(dsn="shapefile", layer="MP14_SUBZONE_NO_SEA_PL")
#WoodgroveNeighbourhood<-readOGR(dsn="shapefile",layer="WoodgroveNeighbourhood")
#shops <- read.csv ("attributetable/shops.csv")
#footpath<- readOGR(dsn="shapefile", layer="footpaths")
#footpath<-spTransform(footpath, CRS("+proj=utm +zone=48N +datum=WGS84"))
#footpath<-spTransform(footpath, CRS("+proj=longlat +datum=WGS84"))
#NeighbourhoodAmenities <- read.csv ("attributetable/NeighbourhoodAmenities.csv")
#Ramps <- read.csv ("attributetable/Ramps.csv")
#WoodgroveNeighbourhood<-spTransform(WoodgroveNeighbourhood, CRS("+proj=utm +zone=48N +datum=WGS84"))
#WoodgroveNeighbourhood<-spTransform(WoodgroveNeighbourhood, CRS("+proj=longlat +datum=WGS84"))
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
#distancematrixhdbNeighbourhood <- distm(NeighbourhoodAmenities[,c('LONGITUDE','LATITUDE')], HDB[,c('LONGITUDE','LATITUDE')], fun=distVincentyEllipsoid)
#NeighbourhoodAmenities$NEAREST_POSTCODE <- HDB$POSTCODE[max.col(-distancematrixhdbNeighbourhood)]
#NeighbourhoodAmenities$NEAREST_DIST <- apply(distancematrixhdbNeighbourhood, 1, min)
#> distancematrixhdbramps <- distm(ramps[,c('LONGITUDE','LATITUDE')], HDB[,c('LONGITUDE','LATITUDE')], fun=distVincentyEllipsoid)
#> ramps$NEAREST_POSTCODE <- HDB$POSTCODE[max.col(-distancematrixhdbramps)]
#> ramps$NEAREST_DIST <- apply(distancematrixhdbramps, 1, min)

#> distancematrixhdbfootpath <- distm(foot[,c('LONGITUDE','LATITUDE')], HDB[,c('LONGITUDE','LATITUDE')], fun=distVincentyEllipsoid)
#> ramps$NEAREST_POSTCODE <- HDB$POSTCODE[max.col(-distancematrixhdbramps)]
#> ramps$NEAREST_DIST <- apply(distancematrixhdbramps, 1, min)
#ggplot(shops,aes(x=CATEGORY,y=NEAREST_DIST))+geom_line(aes(colour=NEAREST_DIST)) + geom_point(aes(colour=NEAREST_DIST),size=3)+coord_flip() +ggtitle("Shortest Fly-over distance(<100km) from each home in woodgrove Neighbourhood") + xlab("Public Amenities") + ylab("Distance to nearest shop (km)")
#ggplot(NeighbourhoodAmenities,aes(x=POI_NAME,y=NEAREST_POSTCODE))+geom_line(aes(colour=NEAREST_DIST)) + geom_point(aes(colour=NEAREST_DIST),size=3)+coord_flip() +ggtitle("Shortest Fly-over distance(<100km) from each home in woodgrove Neighbourhood") + xlab("Neighbourhood Amenities") + ylab("Distance to nearest Neighbourhood Amenities (km)")
#ggplot(ramps,aes(x=POI_ADD,y=NEAREST_POSTCODE,group=1))+  geom_line(aes(colour=NEAREST_DIST)) +   geom_point(aes(colour=NEAREST_DIST),size=3)+coord_flip() +  ggtitle("Shortest Fly-over distance(<100km) to ramps in woodgrove Neighbourhood") +   xlab("Location of Ramps") +   ylab("Distance to nearest Ramp (km)") 
#library(shp2graph)

#coordinates(plot.NeighbourhoodAmenities) <- cbind(NeighbourhoodAmenities$LONGITUDE , NeighbourhoodAmenities$LATITUDE)
#proj4string(plot.NeighbourhoodAmenities) = CRS(espg.3414)



ramps <- read.csv ("attributetable/Ramps.csv")
icon.shops <- makeAwesomeIcon(icon= 'shopping-cart', markerColor = 'red', iconColor = 'white')
icon.ramps <- makeAwesomeIcon(icon= 'road', markerColor = 'green', iconColor = 'white')
icon.neighbourhood<-makeAwesomeIcon(icon= 'blackboard', markerColor = 'blue', iconColor = 'white')


server<-(function(input, output) {
  
  output$bar <- renderPlot({
    #(shops.loc[shops['CATEGORY'].isin(['ATM','BANKING'])])
    ggplot(data.frame(shops$CATEGORY),aes(x=shops$CATEGORY ))+geom_histogram(aes(y=(..count..)), stat="count",fill="green", colour="black",size=1)+
      xlab("Categories of Necessary Amenities")+ coord_flip()+
      ylab("Number of Shops per Category")
      
  })
  
  output$bar2 <- renderPlot({
    ggplot(shops,aes(x=CATEGORY,y=as.character(NEAREST_POSTCODE)))+geom_line(aes(colour=NEAREST_DIST)) + 
      geom_point(aes(colour=NEAREST_DIST),size=5)+coord_flip() +
      ggtitle("Shortest Fly-over distance(<100km) to public amenities in woodgrove Neighbourhood") + 
      xlab("Public Amenities") + 
      ylab("Distance to nearest shop (km)")
    
    
  })
  
  output$bar3 <- renderPlot({
    ggplot(NeighbourhoodAmenities,aes(x=POI_NAME,y=as.character(NEAREST_POSTCODE)))+
      geom_line(aes(colour=NEAREST_DIST)) + 
      geom_point(aes(colour=NEAREST_DIST),size=5)+coord_flip() +
      ggtitle("Shortest Fly-over distance(<100km) to neighbourhood amenities in woodgrove Neighbourhood") + 
      xlab("Types of Neighbourhood Amenities") + 
      ylab("Distance to nearest Neighbourhood Amenities (km)")
    
    
  })
  
  output$bar4 <- renderPlot({
#    ggplot(ramps,aes(x=POI_ADD,y=(as.character(ramps$NEAREST_DIST))))+
     # geom_line(aes(group=1,colour=(as.character(ramps$NEAREST_DIST)))) + 
      #geom_point(aes(colour=(as.character(ramps$NEAREST_DIST))))+coord_flip() +
      #ggtitle("Shortest Fly-over distance(<100km) to ramps in woodgrove Neighbourhood") + 
      #xlab("Location of ramps") + 
      #ylab("Distance to nearest Ramp (km)")
    
    ggplot(ramps,aes(x=POI_ADD,y=ramps$NEAREST_DIST))+
      geom_line(aes(colour=ramps$NEAREST_DIST, group=ramps$NEAREST_DIST)) + 
      geom_point(aes(colour=NEAREST_DIST),size=7)+coord_flip() +
      ggtitle("Shortest Fly-over distance(<100km) to ramps in woodgrove Neighbourhood") + 
      xlab("Location of ramps") + 
      ylab("Distance to nearest Ramp (km)")
    
    
    
  })
  output$bar5<-renderPlot({
    ggplot(perpendicularDistancerampsFootpath,aes(x=as.character(perpendicularDistancerampsFootpath$ID),y=perpendicularDistancerampsFootpath$distance))+
      geom_line(aes(colour=distance,)) + 
      geom_point(aes(colour=distance),size=7)+
      ggtitle("Shortest Perpendicular Distances from Footpath to Ramps") + 
      xlab("ID of Footpath") + 
      ylab("Distance to nearest Ramp (km)")
    
  })
  
  
  
  output$map1 <- renderLeaflet({
    df <- shops[shops$CATEGORY == input$CATEGORY,]  
    m<-leaflet()  %>%
      addTiles(
        urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>%
      setView(103.777395,1.428903, zoom = 17)
    m%>%addTiles() %>%
      addPolygons(data=pc50meter, color="green", fill="green", group= "Ramp Buffer")%>%
      addCircleMarkers(~LONGITUDE,~LATITUDE,
                       popup=~POI_ADD,data=HDB, group="HDB"
                       
      )%>%
      
      addAwesomeMarkers(~LONGITUDE,~LATITUDE,
                        popup=~POI_NAME,data=shops, icon=icon.shops, group="Shops"
                        
      )%>%
     addAwesomeMarkers(~LONGITUDE,~LATITUDE,
                       popup=~POI_ADD,data=ramps, icon=icon.ramps, group="Ramps") %>%
      
      addAwesomeMarkers(~LONGITUDE,~LATITUDE,
                        popup=~POI_NAME,data=NeighbourhoodAmenities,icon= icon.neighbourhood, group="Neighbourhood Amenities"
                        
      )%>%
      addPolylines(data=footpath, color="red", group="Footpaths")   %>%
      addPolygons(data=pc5km)%>%
      addCircleMarkers(data=plot.HDB,radius=8,fillColor =   'green',fillOpacity=0.8,weight=1,color='black',popup=pop1)%>%
     # addCircleMarkers(data=Ramps,radius=20,fillColor = 'orange',fillOpacity=0.8,weight=1,color='black',popup=pop2)%>%
      addPolygons(data=WoodgroveNeighbourhood, color="yellow", fill="purple",group= "WoodgroveNeighbourhood")%>%
      addLayersControl(
        overlayGroups = c("WoodgroveNeighbourhood","Ramp Buffer","Footpaths","HDBs", "Shops","Ramps","Neighbourhood Amenities"), 
       
         position = c("bottomright"),
        options = layersControlOptions(collapsed = FALSE)
      )
    
    
    
  })
  output$map2 <- renderLeaflet({
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
                        popup=~POI_NAME,data=NeighbourhoodAmenities,icon= icon.neighbourhood, group="Neighbourhood Amenities"
                        
      )%>%
      addPolylines(data=footpath, color="red", group="Footpaths")   %>%
      addPolygons(data=WoodgroveNeighbourhood, color="purple")%>%
      addPolygons(data=pc5km)%>%
      addPolygons(data=pc50meter, color="green", fill="green", group= "Ramp Buffer")

    
    
  })
  
})

library(shiny)
library(leaflet)


ui<-fluidPage(
  navbarPage(title="Helping Hands",
             tabPanel(title = "Map View @ Woodgrove",
                      fluidRow(
                        column(12, (leafletOutput("map1","100%",650))),
                        tags$h4("")
                      )
             ),
          #   navbarMenu(title = "Analysis",
                     #   tabPanel(title = "Hansen Potential Model"
                              #   ,
                               #  fluidRow(   
                               #    column(8, (leafletOutput("map2","100%",600))),
                              #     column(4,fluidPage(tags$h4("Accessibility Analysis"),
                               #                       tags$h4("")
                                                      
                           #        )
                         #          )
                         #        )
                       # ),
                        
                        
                   #     tabPanel(title = "Weighted Matrix"),
                        
                        
                        
                      #  tabPanel(title = "Manual distance according to footpath"),
             
                     #   tabPanel(title = "K-means clustering according to ramps")),
             
             tabPanel(title="Distance Analysis (Haversine & Vincenty) & Statistics",
                      fluidRow(column(12,fluidPage(tags$h4("HISTOGRAM: Distribution of public amenities according to number and type of public amenities."),
                                                  tags$br(),plotOutput("bar"),
                                                  tags$br(),
                                                  tags$h4("TABLE: Distribution of public amenities according to postal code and closest type of public amenities "),
                                                  plotOutput("bar2"),
                                                  tags$br(),
                                                  plotOutput("bar3"),
                                                  tags$br(),
                                                #  plotOutput("bar4"),
                                                  tags$br(),
                                                  plotOutput("bar5")
                                                  
                                                  
                               )
                               )
                      )
                      
             )
             
  ))
#ggplot(shops, aes(x=shops$POSTCODE, y=shops$NEAREST_DIST)) + geom_point(alpha = 0.4) + geom_smooth(method=lm) + ggtitle("Comparison between nearest hdb and shortest distance") + xlab("Postcodes") + ylab("Distance to nearest shops") + facet_wrap(~CATEGORY)+coord_flip()
#ggplot(shops,aes(x=CATEGORY,y=NEAREST_DIST))+geom_line(aes(colour=NEAREST_DIST)) + geom_point(aes(colour=NEAREST_DIST),size=3)+coord_flip()
#ggplot(HDB,aes(x=POSTCODE,y=NEAREST_DIST))+geom_line(aes(colour=NEAREST_DIST)) + geom_point(aes(colour=NEAREST_DIST),size=3)+ggtitle("Shortest Fly-over distance(<100km) from each home in woodgrove Neighbourhood") + xlab("Public Amenities") + ylab("Distance to nearest shop (km)")
#ggplot(shops,aes(x=CATEGORY,y=NEAREST_DIST))+geom_line(aes(colour=NEAREST_DIST)) + geom_point(aes(colour=NEAREST_DIST),size=3)+coord_flip() +ggtitle("Shortest Fly-over distance(<100km) from each home in woodgrove Neighbourhood") + xlab("Public Amenities") + ylab("Distance to nearest shop (km)")
shinyApp(server = server, ui = ui)