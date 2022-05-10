my_map_activ <- function(x){
  
###### ---------- LOAD LIBRARIES ---------- ######
library(tidyverse)
library(leaflet)
library(htmltools)
  
icons <- awesomeIcons(
    icon = 'ios-close',
    iconColor = 'black',
    library = 'ion',
    markerColor = new
  )

# to break labels over 2 lines
labs <- lapply(seq(nrow(x)), function(i) {
  paste0( '<p>', x[i, "Name"], '<p></p>', 
          x[i, "Organisation"], '</p>' ) 
})

###### ---------- DRAW MAP ---------- ######
  my_map <- leaflet(x) %>%
    addTiles() %>%
    setView(24.774610, -29.038968, zoom = 5) %>%
    addAwesomeMarkers(lng = ~long,
                     lat = ~lat,
                     icon = icons,
                     label = lapply(labs, htmltools::HTML),
                     popup = ~paste(Name, " <br>Subjects include: ", Subjects),
                     clusterOptions = markerClusterOptions()
    )
  
  return(my_map)
  
}