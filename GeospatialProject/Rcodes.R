library(leaflet)


# Map
m<-leaflet(data=shops)%>% addTiles()%>%
  addMarkers(~LONGITUDE,~LATITUDE,
             popup=~POI_NAME)

--------
  m <- leaflet() %>%
  setView(103.7732232,1.4293702, zoom = 16)
m%>%addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(lng=103.7732261,
             lat=1.4306896,
             popup="POSB BANK")
---------------

library(rgdal)
roads <- readOGR(dsn="E:/IS415/GeospatialProject/shapefile", layer="roads")
mpsz_svy21 <- readOGR(dsn="E:/IS415/GeospatialProject/shapefile", layer="MP14_SUBZONE_NO_SEA_PL")
leaflet(data = mpsz_svy21) %>% addTiles() %>%
  addPolygons(fillColor = topo.colors(10, alpha = NULL), stroke = FALSE)

library(maptools)
shops <- read.csv ("/IS415/GeospatialProject/shops.csv")
coords <- cbind(shops$LONGITUDE, shops$LONGITUDE)
sp_shops <- SpatialPointsDataFrame(coords = coords, data = shops, proj4string = CRS("+proj=longlat +datum=SVY21"))
sp_shops_proj <- spTransform(sp_shops, CRS("+init=epsg:3414"))
plot(sp_shops)
summary(sp_shops)
library(maptools)
library(spatstat)
library(rgeos)
buff2km <- gBuffer(sp_shops_proj, byid = TRUE, width = 2000)