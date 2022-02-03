#MAP EXAMPLE #1
#east coast map
#loading libraries
library(tidyverse)
library(sf)

#getting the data
usa <- ggplot2::map_data('state') %>% 
  filter(region %in% c("maine", "vermont", "new hampshire", 
                       "massachusetts", "connecticut", "rhode island",
                       "new york", "pennsylvania", "new jersey",
                       "delaware", "district of columbia", "maryland",
                       "west virginia", "virginia", "north carolina"))

#
ggplot() + geom_polygon(data = usa, aes(x=long, y = lat, group = group,colour='white'),fill = 'Grey60') + theme_bw() + 
  coord_sf(crs="+proj=longlat +datum=WGS84")


#MAP EXAMPLE #2
#Pulling in bathymetry=
library(marmap)
atl <- marmap::getNOAA.bathy(-78.5,-66.5, 34.5, 45, res = 1, keep=TRUE)

#firt layer
map <- NULL
map <- ggplot() + 
  geom_raster(data=atl, aes(x=x, y=y,fill = z), interpolate = TRUE,alpha=0.75, show.legend = FALSE)

map + scale_fill_etopo()

#second layer
map <- map + geom_contour(data = atl, aes(x=x, y=y, z=z), breaks=c(-100), size=c(0.3), colour="black",alpha=0.75)

map

#third layer
#Making the state polygon again
usa <- ggplot2::map_data('state') %>% filter(region %in% c("maine", "vermont", "new hampshire", 
                       "massachusetts", "connecticut", "rhode island",
                       "new york", "pennsylvania", "new jersey",
                       "delaware", "district of columbia", "maryland",
                       "west virginia", "virginia", "north carolina"))

map <- map + geom_polygon(data = usa, aes(x=long, y = lat, group = group),fill = 'Grey60') 

map

#Some polshing
#Making lat/lon bbox for plotting
lons = c(-75, -67)
lats = c(36, 44)

map <- map + theme_bw() + 
  coord_sf(xlim = lons, ylim = lats, crs="+proj=longlat +datum=WGS84")


map
#Adding some data
data <- data.frame(lon=rnorm(500,-70,0.15),lat=rnorm(500,40,0.15),n=rnorm(500,1,0.3))

map <- map + new_scale('fill') + 
      stat_summary_2d(data=data, aes(y=lat,x=lon,z=n),binwidth = c(0.16666,0.16666),alpha=0.5) +
      scale_fill_viridis_c()

map

atl %>% autoplot()
