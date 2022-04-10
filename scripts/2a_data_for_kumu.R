
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

# Read in Google Sheet data
form_data <- read_sheet("https://docs.google.com/spreadsheets/d/1-2rF3VNdkXzFKPjUwMexedyVFxsamjO-8yAi7AVierY/edit?resourcekey#gid=1694945086")


###### ---------- Record type: PROJECT ---------- ######
project <- form_data %>%
  filter(`1._What is the type of record you are submitting?` == "Project") %>%
  select(c("Timestamp", "Email Address", starts_with(c("1.", "2")))) %>%
  unite("Tags", 11:12, sep = ", ", remove = FALSE)

names(project) <-
  c(
    "Timestamp",
    "email_collected",
    "data_submitter_name",
    "data_submitter_email",
    "Type",
    "contact_first_names",
    "contact_surname",
    "contact_title",
    "Label",
    "Description",
    "Tags",
    "subject_area",
    "methods",
    "Organisation",
    "Organisation_other",
    "language_primary",
    "status",
    "year_start",
    "year_end",
    "Funders",
    "URL",
    "Email",
    "project_outputs"
  )

# fix punctuation for subject area & methods
project$subject_area <- gsub(";, ", ";", project$subject_area)
project$methods <- gsub(";, ", ";", project$methods)

###### ---------- Record type: PERSON ---------- ######
person <- form_data %>%
  filter(`1._What is the type of record you are submitting?` == "Person") %>%
  select(c("Timestamp", "Email Address", starts_with(c("1.", "3")))) %>%
  unite("Tags", 12:13, sep = ", ", remove = FALSE) %>%
  unite("Label", 6:8, sep = " ", remove = FALSE)

names(person) <-
  c(
    "Timestamp",
    "email_collected",
    "data_submitter_name",
    "data_submitter_email",
    "Type",
    "Label",
    "title",
    "first_names",
    "surname",
    "Email",
    "Description",
    "keywords",
    "Tags",
    "subject_area",
    "methods",
    "Organisation",
    "Other",
    "job_title",
    "career_stage",
    "orcid",
    "URL",
    "linkedin_url",
    "researchgate_url",
    "twitter"
  )

# fix punctuation for subject area & methods
person$subject_area <- gsub(";, ", ";", person$subject_area)
person$methods <- gsub(";, ", ";", person$methods)

# Kumu sheets
kumu_project <- project %>%
  select(Label, Type, Description, Tags, Organisation, URL, Email)

kumu_person <- person %>%
  select(Label, Type, Description, Tags, Organisation, URL, Email)


###### combine project and person for a kumu spreadsheet
kumu <- rbind(kumu_person, kumu_project)
# replace ;, with |
kumu$Tags <- gsub(";,", " | ", kumu$Tags)

##### write to google spreadsheet
ss = "https://docs.google.com/spreadsheets/d/1PIbPFc0Ye6YqTiWmaL839L88EvO6HrKJI0XbzeyN084/edit#gid=0"

kumu_gsheet <- sheet_write(kumu, ss = ss, sheet = "kumu")
