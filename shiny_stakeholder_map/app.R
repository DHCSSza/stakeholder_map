
## Shiny app for the SADiLaR Stakeholder Map Project

####### ------- LOAD LIBRARIES ------- #######
library(tidyverse)
library(googlesheets4)
library(shiny)
library(leaflet)
library(DT)
library(tableHTML)

# usecairo = T from package Cairo for better quality of figures in shiny app
options(shiny.usecairo=T)

####### ------- LOAD FUNCTIONS ------- #######
source('shiny_stakeholder_map/my_map_activ.R') # for local deployment
#source('my_map_activ.R')

####### ------- LOAD DATA ------- #######
load("shiny_stakeholder_map/shiny_data.RData") # for local deployment
#load("shiny_data.RData")

####### ------- CHOICES for ACTIVITIES MAP ------- #######
choices_record_type <- c('Person', 'Project', 'Training')


####### ------- Define UI for application that draws plot ------- #######
ui <- (fluidPage(
    titlePanel(title = "Digital Humanities and Computational Social Sciences landscape in South Africa"),
    p("The South African Centre for Digital Language Resources (SADiLaR) is a national centre supported by the Department of Science and Innovation (DSI) as part of the South African Research Infrastructure Roadmap (SARIR). SADiLaR has an enabling function, with a focus on all official languages of South Africa, supporting research and development in the domains of language technologies and language-related studies in the humanities and social sciences. Furthermore the centre has a mandate to develop digital humanities capacity in South Africa."),
    tabsetPanel(
        # ----- input for 1st panel (activities map) -----
        tabPanel('Activities Map',
                 sidebarPanel(
                     # add filter for data by record type
                     selectInput(inputId = 'Type', 
                                 label = 'Choose which record type to view', 
                                 choices = choices_record_type, 
                                 selected = 'People'
                     ), # end selectInput
                     # add reset button for map view
                     actionButton("reset_button", "Reset map view")
                 ), # end sidebarPanel
                     mainPanel(
                         #h4('DH and CSS landscape in South Africa'),
                         p("This map shows data on Digital Humanities (DH) and Computational Social Sciences (CSS) activities and initiatives in South Africa."),
                         p('Records from locations close to each other are grouped together.
                    To ungroup, click on a green circle to see individual locations. Click again to see individual records at one location. Click on', strong(em('Reset map view')), 'to get back to the orginal view.'),
                         leafletOutput("my_map_activities"),
                     ) # end mainPanel
        ), # end tabPanel 1
        
        # ----- input for 2nd panel (project table) -----
        tabPanel('Projects',
                 DT::dataTableOutput("mytable_project")
        ), # end tabPanel 2
        
        # ----- input for 3rd panel (person table) -----
        tabPanel('People',
                 DT::dataTableOutput("mytable_person")
        ), # end tabPanel 3
        
        # ----- input for 4th panel (dataset table) -----  
        tabPanel('Datasets',
                 DT::dataTableOutput("mytable_dataset")
        ), # end tabPanel 4
        
        # ----- input for 5th panel (tool table) -----
        tabPanel('Tools',
                 DT::dataTableOutput("mytable_tool")
        ), # end tabPanel 5
        
        # ----- input for 6th panel (publication table) -----
        tabPanel('Publications',
                 DT::dataTableOutput("mytable_publication")
        ), # end tabPanel 6
        
        # ----- input for 7th panel (training table) -----
        tabPanel('Training',
                 DT::dataTableOutput("mytable_training")
        ), # end tabPanel 7
        
        # ----- input for 8th panel (learning_material table) -----
        tabPanel('Learning materials',
                 DT::dataTableOutput("mytable_learning_material")
        ), # end tabPanel 8
        
        # ----- input for 9th panel (archives table) -----
        tabPanel('Archives',
                 DT::dataTableOutput("mytable_archives")
        ), # end tabPanel 9
        
        # ----- input for 10th panel (unclassified table) -----
        tabPanel('Unclassified records',
                 DT::dataTableOutput("mytable_unclassified")
        ), # end tabPanel 10
        
    ) # end tabsetPanel
)) # end fluidpage

# Define server logic required to draw a the leaflet map, other plots, and show tables
server <- function(input, output){
    # ----- output (map) for 1st panel (map) ----- 

    output$my_map_activities <- leaflet::renderLeaflet({
        # filter for type 
        if(input$Type == 'Project') {
            mapData <- project
        }else if(input$Type == 'Person') {
            mapData <- person
        }else if(input$Type == 'Training'){
            mapData <- training
        } # end if else
        
        # draw the map using function
        my_map_activ(x = mapData)
    }) # end my_map_activities map
    
    # set reset button for activities map
    observe({
        input$reset_button
        leafletProxy("my_map_activities") %>% 
            setView(lng = 24.774610,  
                    lat = -29.038968, 
                    zoom = 5)
    })
    
    # ----- output (table) for 2nd panel (projects table) -----
    output$mytable_project = DT::renderDataTable({
         datatable(project, escape=FALSE, 
                   options = list(
                       pageLength = 20, autoWidth = TRUE,
                       columnDefs = list(list( targets = 7, width = '600px')),
                       scrollX = TRUE
                   ))
     })
    # ----- output (table) for 3nd panel (people table) -----
    output$mytable_person = DT::renderDataTable({
        datatable(person, escape=FALSE, 
                  options = list(
                      pageLength = 20, autoWidth = TRUE,
                      columnDefs = list(list( targets = 8, width = '600px')),
                      scrollX = TRUE
                  ))
    })
    # ----- output (table) for 4th panel (dataset table) -----
    output$mytable_dataset = DT::renderDataTable({
        datatable(dataset, escape=FALSE, 
                  options = list(
                      pageLength = 20, autoWidth = TRUE,
                      columnDefs = list(list( targets = 7, width = '600px')),
                      scrollX = TRUE
                  ))
    })
    # ----- output (table) for 5th panel (tool table) -----
    output$mytable_tool = DT::renderDataTable({
        datatable(tool, escape=FALSE, 
                  options = list(
                      pageLength = 20, autoWidth = TRUE,
                      columnDefs = list(list( targets = 7, width = '600px')),
                      scrollX = TRUE
                  ))
    })
    # ----- output (table) for 6th panel (publication table) -----
    output$mytable_publication = DT::renderDataTable({
        datatable(publication, escape=FALSE, 
                  options = list(
                      pageLength = 20, autoWidth = TRUE,
                      columnDefs = list(list( targets = 4, width = '600px')),
                      scrollX = TRUE
                  ))
    })
    # ----- output (table) for 7th panel (training table) -----
    output$mytable_training = DT::renderDataTable({
        datatable(training, escape=FALSE, 
                  options = list(
                      pageLength = 20, autoWidth = TRUE,
                      columnDefs = list(list( targets = 9, width = '600px')),
                      scrollX = TRUE
                  ))
    })
    # ----- output (table) for 8th panel (learning_material table) -----
    output$mytable_learning_material = DT::renderDataTable({
        datatable(learning_material, escape=FALSE, 
                  options = list(
                      pageLength = 20, autoWidth = TRUE,
                      columnDefs = list(list( targets = 7, width = '600px')),
                      scrollX = TRUE
                  ))
    })
    # ----- output (table) for 9th panel (archives table) -----
    output$mytable_archives = DT::renderDataTable({
        datatable(archives, escape=FALSE, 
                  options = list(
                      pageLength = 20, autoWidth = TRUE,
                      columnDefs = list(list( targets = 7, width = '600px')),
                      scrollX = TRUE
                  ))
    })
    # ----- output (table) for 10th panel (unclassified table) -----
    output$mytable_unclassified = DT::renderDataTable({
        datatable(unclassified, escape=FALSE, 
                  options = list(
                      pageLength = 20, autoWidth = TRUE,
                      columnDefs = list(list( targets = 7, width = '600px')),
                      scrollX = TRUE
                  ))
    })
} # end server

# Run the application
shinyApp(ui, server)

