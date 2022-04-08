
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
source('functions/my_map_activ.R')


####### ------- AUTHORISATIONS ------- #######
# this works locally
gs4_auth(email = "*@talarify.co.za", path = "~/stakeholder_map/.secret/GSHEET_ACCESS")

# for GitHub Action (adapted from https://github.com/jdtrat/tokencodr-google-demo)
#source("functions/func_auth_google.R")

# Authenticate Google Service Account
#auth_google(email = "*@talarify.co.za",
#            service = "GSHEET_ACCESS",
#            token_path = ".secret/GSHEET_ACCESS")


####### ------- READ in GOOGLE SHEET DATA ------- #######
ss = "https://docs.google.com/spreadsheets/d/1fUf6SbWQttVVCUAZ2jH9z24qua1BqO05Qv2lLNllsCU/edit#gid=0"

locations <- read_sheet(ss, sheet = "Organisation_locations")

project <- read_sheet(ss, sheet = "project") %>%
    merge(locations, by = 'Organisation')
person <- read_sheet(ss, sheet = "person")%>%
    merge(locations, by = 'Organisation')
dataset <- read_sheet(ss, sheet = "dataset")
tool <- read_sheet(ss, sheet = "tool")
publication <- read_sheet(ss, sheet = "publication")
training <- read_sheet(ss, sheet = "training")%>%
    merge(locations, by = 'Organisation')
archives <- read_sheet(ss, sheet = "archives")
learning_material <- read_sheet(ss, sheet = "learning_material")
unclassified <- read_sheet(ss, sheet = "unclassified")

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
                    To ungroup, click on a green circle and see individual locations, click again to see individual beneficiaries at one location. Click on', strong(em('Reset map view')), 'to get back to the orginal view.'),
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
        project
    })
    # ----- output (table) for 3nd panel (people table) -----
    output$mytable_person = DT::renderDataTable({
        person
    })
    # ----- output (table) for 4th panel (dataset table) -----
    output$mytable_dataset = DT::renderDataTable({
        dataset
    })    
    # ----- output (table) for 5th panel (tool table) -----
    output$mytable_tool = DT::renderDataTable({
        tool
    })
    # ----- output (table) for 6th panel (publication table) -----
    output$mytable_publication = DT::renderDataTable({
        publication
    })
    # ----- output (table) for 7th panel (training table) -----
    output$mytable_training = DT::renderDataTable({
        training
    })
    # ----- output (table) for 8th panel (learning_material table) -----
    output$mytable_learning_material = DT::renderDataTable({
        learning_material
    })
    # ----- output (table) for 9th panel (archives table) -----
    output$mytable_archives = DT::renderDataTable({
        archives
    })
    # ----- output (table) for 10th panel (unclassified table) -----
    output$mytable_unclassified = DT::renderDataTable({
        unclassified
    })
} # end server

# Run the application
shinyApp(ui, server)
