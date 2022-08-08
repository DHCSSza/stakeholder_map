
# STAKEHOLDER MAP PROJECT: script to:
# - set authorisations to read from a Google spreadsheet (linked to Google Form)
# - import data from this Google spreadsheet, manipulate and write to an R Data file for Shiny

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
  select(-c(1:3, 5:7))

names(project) <-
  c(
    "Contact name",
    "Name",
    "Description",
    "Keywords",
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
  unite("Name", 4:6, sep = " ", remove = FALSE) %>%
  select(-c(1:3, 5:7))

names(person) <-
  c(
    "Name",
    "Email",
    "Description",
    "Keywords",
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
person$Subjects <- gsub(";, ", "; ", person$Subjects)
person$Subjects <-  gsub('.{1}$', "", person$Subjects) # remove ; at the end
person$Methods <- gsub(";, ", "; ", person$Methods)
person$Methods <-  gsub('.{1}$', "", person$Methods)


###### ---------- Record type: DATASET ---------- ######
dataset <- form_data %>%
  filter(`1._What is the type of record you are submitting?` == "Dataset") %>%
  select(starts_with(c("1.", "4"))) %>%
  unite("Contact name", c(6,4:5), sep = " ", remove = FALSE) %>%
  select(-c(1:3, 5:7))

names(dataset) <-
  c(
    "Contact name",
    "Contact email",
    "Name",
    "Description",
    "Keywords",
    "Subjects",
    "Methods",
    "Status",
    "Publisher",
    "Repository",
    "Publication year",
    "Primary language(s)",
    "Other language(s)",
    "Identifier",
    "Licence",
    "Paywall",
    "Machine readable",
    "URL",
    "Dataset format"
  )

# fix punctuation for subject area & methods
dataset$Subjects <- gsub(";, ", "; ", dataset$Subjects)
dataset$Subjects <-  gsub('.{1}$', "", dataset$Subjects) # remove ; at the end
dataset$Methods <- gsub(";, ", "; ", dataset$Methods)
dataset$Methods <-  gsub('.{1}$', "", dataset$Methods)


###### ---------- Record type: TOOL ---------- ######
tool <- form_data %>%
  filter(`1._What is the type of record you are submitting?` == "Tool") %>%
  select(starts_with(c("1.", "5"))) %>%
  unite("Contact name", c(6,4:5), sep = " ", remove = FALSE) %>%
  select(-c(1:3, 5:7))

names(tool) <-
  c(
    "Contact name",
    "Contact email",
    "Name",
    "Description",
    "Keywords",
    "Subjects",
    "Methods",
    "Organisation",
    "Organisation_other",
    "Primary language(s)",
    "Other language(s)",
    "Year created",
    "Year updated",
    "Analysis type",
    "Tool run",
    "Usage",
    "TaDiRAH methods",
    "Licence",
    "Status",
    "TaDiRAH goals",
    "Funders",
    "URL"
  )

# fix punctuation for subject area & methods
tool$Subjects <- gsub(";, ", "; ", tool$Subjects)
tool$Subjects <-  gsub('.{1}$', "", tool$Subjects) # remove ; at the end
tool$Methods <- gsub(";, ", "; ", tool$Methods)
tool$Methods <-  gsub('.{1}$', "", tool$Methods)


###### ---------- Record type: PUBLICATION ---------- ######
publication <- form_data %>%
  filter(`1._What is the type of record you are submitting?` == "Publication") %>%
  select(starts_with(c("1.", "6"))) %>%
  select(-c(1:3))

names(publication) <-
  c(
    "Publication type",
    "Title",
    "Abstract",
    "Keywords",
    "Authors",
    "Subjects",
    "Methods",
    "Primary language(s)",
    "Other language(s)",
    "Status",
    "Publisher",
    "Volume number",
    "Start page number",
    "End page number",
    "Publication year",
    "Conference name",
    "Conference start date",
    "Identifier",
    "Licence",
    "Paywall",
    "URL",
    "Zotero library addition"
  )

# fix punctuation for subject area & methods
publication$Subjects <- gsub(";, ", "; ", publication$Subjects)
publication$Subjects <-  gsub('.{1}$', "", publication$Subjects) # remove ; at the end
publication$Methods <- gsub(";, ", "; ", publication$Methods)
publication$Methods <-  gsub('.{1}$', "", publication$Methods)

publication <- relocate(publication, Authors, .before = Title)

###### ---------- Record type: TRAINING ---------- ######
training <- form_data %>%
  filter(`1._What is the type of record you are submitting?` == "Training") %>%
  select(starts_with(c("1.", "7", "8", "9"))) %>%
  unite("Contact name", c(6,4:5), sep = " ", remove = FALSE) %>%
  select(-c(1:3, 5:7))
  
names(training) <-
  c(
    "Contact name",
    "Contact email",
    "Training type",
    "Name",
    "Description",
    "Keywords",
    "Subjects",
    "Methods",
    "Organisation",
    "Organisation_other",
    "Year",
    "Length",
    "Frequency",
    "Primary language(s)",
    "Other language(s)",
    "URL",
    "In person or online",
    "In person organisation venue",
    "In person organisation venue other",
    "Online type"
  )

# fix punctuation for subject area & methods
training$Subjects <- gsub(";, ", "; ", training$Subjects)
training$Subjects <-  gsub('.{1}$', "", training$Subjects) # remove ; at the end
training$Methods <- gsub(";, ", "; ", training$Methods)
training$Methods <-  gsub('.{1}$', "", training$Methods)

###### ---------- Record type: ARCHIVES ---------- ######
archives <- form_data %>%
  filter(`1._What is the type of record you are submitting?` == "Archives") %>%
  select(starts_with(c("1.", "10"))) %>%
  unite("Contact name", c(6,4:5), sep = " ", remove = FALSE) %>%
  select(-c(1:3, 5:7))

names(archives) <-
  c(
    "Contact name",
    "Contact email",
    "Name",
    "Description",
    "Keywords",
    "Subjects",
    "Methods",
    "Organisation",
    "Organisation_other",
    "Year",
    "Primary language(s)",
    "Other language(s)",
    "URL"
  )

# fix punctuation for subject area & methods
archives$Subjects <- gsub(";, ", "; ", archives$Subjects)
archives$Subjects <-  gsub('.{1}$', "", archives$Subjects) # remove ; at the end
archives$Methods <- gsub(";, ", "; ", archives$Methods)
archives$Methods <-  gsub('.{1}$', "", archives$Methods)


###### ---------- Record type: LEARNING MATERIAL ---------- ######
learning_material <- form_data %>%
  filter(`1._What is the type of record you are submitting?` == "Learning Material") %>%
  select(starts_with(c("1.", "11"))) %>%
  unite("Contact name", c(6,4:5), sep = " ", remove = FALSE) %>%
  select(-c(1:3, 5:7))

names(learning_material) <-
  c(
    "Contact name",
    "Contact email",
    "Name",
    "Description",
    "Keywords",
    "Subjects",
    "Methods",
    "Organisation",
    "Organisation_other",
    "Type",
    "Year created",
    "Year updated",
    "Target audience",
    "Primary language(s)",
    "Other language(s)",
    "Available online",
    "URL",
    "Licence"
  )

# fix punctuation for subject area & methods
learning_material$Subjects <- gsub(";, ", "; ", learning_material$Subjects)
learning_material$Subjects <-  gsub('.{1}$', "", learning_material$Subjects) # remove ; at the end
learning_material$Methods <- gsub(";, ", "; ", learning_material$Methods)
learning_material$Methods <-  gsub('.{1}$', "", learning_material$Methods)


###### ---------- Record type: UNCLASSIFIED ---------- ######
unclassified <- form_data %>%
  filter(`1._What is the type of record you are submitting?` == "Unclassified") %>%
  select(starts_with(c("1.", "12"))) %>%
  unite("Contact name", c(6,4:5), sep = " ", remove = FALSE) %>%
  select(-c(1:3, 5:7))
  
names(unclassified) <-
  c(
    "Contact name",
    "Contact email",
    "Name",
    "Description",
    "Keywords",
    "Subjects",
    "Methods",
    "Organisation",
    "Organisation_other",
    "Year collected",
    "Primary language(s)",
    "Other language(s)",
    "URL"
  )

# fix punctuation for subject area & methods
unclassified$Subjects <- gsub(";, ", "; ", unclassified$Subjects)
unclassified$Subjects <-  gsub('.{1}$', "", unclassified$Subjects) # remove ; at the end
unclassified$Methods <- gsub(";, ", "; ", unclassified$Methods)
unclassified$Methods <-  gsub('.{1}$', "", unclassified$Methods)


###### ---------- Record type: INFRASTRUCTURE ---------- ######
infrastructure <- form_data %>%
  filter(`1._What is the type of record you are submitting?` == "Infrastructure") %>%
  select(starts_with(c("1.", "13"))) %>%
  unite("Contact name", c(6,4:5), sep = " ", remove = FALSE) %>%
  select(-c(1:3, 5:7))

names(infrastructure) <-
  c(
    "Contact name",
    "Contact email",
    "Name",
    "URL",
    "Description",
    "Keywords",
    "Services",
    "Subjects",
    "Methods",
    "Organisation",
    "Organisation_other"
  )

# fix punctuation for subject area & methods
infrastructure$Subjects <- gsub(";, ", "; ", infrastructure$Subjects)
infrastructure$Subjects <-  gsub('.{1}$', "", infrastructure$Subjects) # remove ; at the end
infrastructure$Methods <- gsub(";, ", "; ", infrastructure$Methods)
infrastructure$Methods <-  gsub('.{1}$', "", infrastructure$Methods)


####### ------- READ in GOOGLE SHEET DATA FOR LOCATIONS ------- #######
ss = "https://docs.google.com/spreadsheets/d/1fUf6SbWQttVVCUAZ2jH9z24qua1BqO05Qv2lLNllsCU/edit#gid=0"
locations <- read_sheet(ss, sheet = "Organisation_locations")


###### ---------- MERGE W/LOCATIONS ---------- ######
project <- project %>%
  merge(locations, by = 'Organisation')
person <-  person %>%
  merge(locations, by = 'Organisation')
#dataset <- dataset %>%
#tool <- tool %>%
#publication <- publication %>%
training <-  training %>%
  merge(locations, by = 'Organisation')
#archives <- archives %>%
#learning_material <- learning_material %>%
#unclassified <- unclassified %>%
#infrastructure <- infrastructure %>% 

### SAVE RDATA FILE
save(project, person, dataset, tool, publication, training, archives, learning_material, unclassified, infrastructure, file = "shiny_stakeholder_map/shiny_data.RData")


