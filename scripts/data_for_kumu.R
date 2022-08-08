
# STAKEHOLDER MAP PROJECT: script to:
# - set authorisations to read from a Google spreadsheet (linked to Google Form)
# - import data from this Google spreadsheet, manipulate and write to a new spreadsheet for Kumu 

###### ---------- LOAD PACKAGES ---------- ######
library(tidyverse)
library(googlesheets4)

###### ---------- AUTHORISATIONS ---------- ######
# this works locally
#gs4_auth(email = "*@talarify.co.za", path = "~/stakeholder_map/.secret/GSHEET_ACCESS")
#gs4_auth(email = "*@talarify.co.za", path = "~/stakeholder_map/sheets_service_account_key.json") # before making the json a secret

# for GitHub Action (adapted from https://github.com/jdtrat/tokencodr-google-demo)
source("functions/func_auth_google.R")

# Authenticate Google Service Account (adapted from https://github.com/jdtrat/tokencodr-google-demo)
auth_google(email = "*@talarify.co.za",
            service = "GSHEET_ACCESS",
            token_path = ".secret/GSHEET_ACCESS")

###### ---------- READ DATA FROM GOOGLE SHEET ---------- ######
form_data <- read_sheet("https://docs.google.com/spreadsheets/d/1UCVAfe5_yHAflSDGt2U9SQwfS42Lq1RTdaJGjy3RZnE/edit?resourcekey#gid=802540909")


###### ---------- Record type: PROJECT ---------- ######
project <- form_data %>%
  filter(`1._What is the type of record you are submitting?` == "Project") %>%
  select(starts_with(c("1.", "2"))) %>%
  unite("Contact name", c(6,4:5), sep = " ", remove = FALSE) %>%
  unite("Tags", 11:12, sep = ", ", remove = FALSE) %>%
  select(-c(1:2, 5:7))

names(project) <-
  c(
    "Type",
    "Contact name",
    "Label",
    "Description",
    "Keywords",
    "Tags",
    "Subjects",
    "Methods",
    "Organisation",
    "Organisation_other",
    "Primary language(s)",
    "Status",
    "Year project started",
    "Year project ended",
    "Funders",
    "URL",
    "Email",
    "Project outputs"
  )

# fix punctuation for subject area & methods
project$Subjects <- gsub(";, ", "; ", project$Subjects)
project$Subjects <-  gsub('.{1}$', "", project$Subjects) # remove ; at the end
project$Methods <- gsub(";, ", "; ", project$Methods)
project$Methods <-  gsub('.{1}$', "", project$Methods)


###### ---------- Record type: PERSON ---------- ######
person <- form_data %>%
  filter(`1._What is the type of record you are submitting?` == "Person") %>%
  select(starts_with(c("1.", "3"))) %>%
  unite("Label", 4:6, sep = " ", remove = FALSE) %>%
  unite("Tags", 11:12, sep = ", ", remove = FALSE) %>%
  select(-c(1:2, 5:7))
  
names(person) <-
  c(
    "Type",
    "Label",
    "Email",
    "Description",
    "Keywords",
    "Tags",
    "Subjects",
    "Methods",
    "Organisation",
    "Organisation_other",
    "Job title",
    "Career stage",
    "Orcid ID",
    "URL",
    "LinkedIn",
    "ResearchGate",
    "Twitter"
  )

# fix punctuation for subject area & methods
project$Subjects <- gsub(";, ", "; ", project$Subjects)
project$Subjects <-  gsub('.{1}$', "", project$Subjects) # remove ; at the end
project$Methods <- gsub(";, ", "; ", project$Methods)
project$Methods <-  gsub('.{1}$', "", project$Methods)

# Kumu sheets
kumu_project <- project %>%
  select(Label, Type, Description, Tags, Organisation, URL, Email)

kumu_person <- person %>%
  select(Label, Type, Description, Tags, Organisation, URL, Email)


###### combine project and person for a kumu spreadsheet
kumu <- rbind(kumu_person, kumu_project)
# replace ;, with |
kumu$Tags <- gsub(";,", " | ", kumu$Tags)
kumu$Tags <-  gsub('.{1}$', "", kumu$Tags) # remove ; at the end


##### write to google spreadsheet
ss = "https://docs.google.com/spreadsheets/d/1PIbPFc0Ye6YqTiWmaL839L88EvO6HrKJI0XbzeyN084/edit#gid=0"

kumu_gsheet <- sheet_write(kumu, ss = ss, sheet = "kumu")
