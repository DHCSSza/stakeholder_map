my_map_activ <- function(x){
  
###### ---------- LOAD LIBRARIES ---------- ######
library(tidyverse)
library(leaflet)
  
icons <- awesomeIcons(
    icon = 'ios-close',
    iconColor = 'black',
    library = 'ion',
    markerColor = new
  )

  
###### ---------- DRAW MAP ---------- ######
  my_map <- leaflet(x) %>%
    addTiles() %>%
    setView(24.774610, -29.038968, zoom = 5) %>%
    addAwesomeMarkers(lng = ~long,
                     lat = ~lat,
                     icon = icons,
                     #popup = ~paste(Name,"|"," Subjects include: ", Subjects),
                     label = ~paste(Name, " at ", Organisation),
                     popup = ~paste(Name, " <br>Subjects include: ", Subjects),
                     #label = ~paste(Name, Organisation),
                     clusterOptions = markerClusterOptions()
    )
  
  return(my_map)
  
}