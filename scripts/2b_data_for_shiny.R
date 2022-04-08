
# STAKEHOLDER MAP PROJECT: script to:
# - set authorisations to read from a Google spreadsheet (linked to Google Form)
# - import data from this Google spreadsheet, manipulate and write to new spreadsheets for Shiny

###### ---------- LOAD PACKAGES ---------- ######
library(tidyverse)
library(googlesheets4)

###### ---------- AUTHORISATIONS ---------- ######
# this works locally
gs4_auth(email = "*@talarify.co.za", path = "~/stakeholder_map/.secret/MY_GOOGLE")

# for GitHub Action (adapted from https://github.com/jdtrat/tokencodr-google-demo)
#source("R/func_auth_google.R")

# Authenticate Google Service Account (adapted from https://github.com/jdtrat/tokencodr-google-demo)
#auth_google(email = "*@talarify.co.za",
#            service = "MY_GOOGLE",
#            token_path = ".secret/MY_GOOGLE")


###### ---------- READ DATA FROM GOOGLE SHEET ---------- ######
form_data <- read_sheet("https://docs.google.com/spreadsheets/d/1-2rF3VNdkXzFKPjUwMexedyVFxsamjO-8yAi7AVierY/edit?resourcekey#gid=1694945086")


###### ---------- Record type: PROJECT ---------- ######
project <- form_data %>%
  filter(`1._What is the type of record you are submitting?` == "Project") %>%
  select(c("Timestamp", "Email Address", starts_with(c("1.", "2"))))

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
    "Subjects",
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
project$Subjects <- gsub(";, ", "; ", project$Subjects)
project$Subjects <-  gsub('.{1}$', "", project$Subjects) # remove ; at the end

project$methods <- gsub(";, ", "; ", project$methods)
project$methods <-  gsub('.{1}$', "", project$methods)


###### ---------- Record type: PERSON ---------- ######
person <- form_data %>%
  filter(`1._What is the type of record you are submitting?` == "Person") %>%
  select(c("Timestamp", "Email Address", starts_with(c("1.", "3")))) %>%
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
    "Subjects",
    "methods",
    "Organisation",
    "Organisation_other",
    "job_title",
    "career_stage",
    "orcid",
    "URL",
    "linkedin_url",
    "researchgate_url",
    "twitter"
  )

# fix punctuation for subject area & methods
person$Subjects <- gsub(";, ", "; ", person$Subjects)
person$Subjects <-  gsub('.{1}$', "", person$Subjects) # remove ; at the end

person$methods <- gsub(";, ", "; ", person$methods)
person$methods <-  gsub('.{1}$', "", person$methods)


###### ---------- Record type: DATASET ---------- ######
dataset <- form_data %>%
  filter(`1._What is the type of record you are submitting?` == "Dataset") %>%
  select(c("Timestamp", "Email Address", starts_with(c("1.", "4"))))

names(dataset) <-
  c(
    "Timestamp",
    "email_collected",
    "data_submitter_name",
    "data_submitter_email",
    "Type",
    "contact_first_names",
    "contact_surname",
    "contact_title",
    "contact_email",
    "Label",
    "Description",
    "keywords",
    "Subjects",
    "methods",
    "status",
    "publisher",
    "repository",
    "publication_year",
    "language_primary",
    "language_other",
    "identifier",
    "licence",
    "paywall",
    "machine_readable",
    "URL",
    "dataset_format"
  )

# fix punctuation for subject area & methods
dataset$Subjects <- gsub(";, ", "; ", dataset$Subjects)
dataset$Subjects <-  gsub('.{1}$', "", dataset$Subjects) # remove ; at the end

dataset$methods <- gsub(";, ", "; ", dataset$methods)
dataset$methods <-  gsub('.{1}$', "", dataset$methods)


###### ---------- Record type: TOOL ---------- ######
tool <- form_data %>%
  filter(`1._What is the type of record you are submitting?` == "Tool") %>%
  select(c("Timestamp", "Email Address", starts_with(c("1.", "5"))))

names(tool) <-
  c(
    "Timestamp",
    "email_collected",
    "data_submitter_name",
    "data_submitter_email",
    "Type",
    "contact_first_names",
    "contact_surname",
    "contact_title",
    "contact_email",
    "Label",
    "Description",
    "Subjects",
    "methods",
    "Organisation",
    "Organisation_other",
    "language_primary",
    "language_other",
    "year_created",
    "year_updated",
    "analysis_type",
    "tool_run",
    "usage",
    "TaDiRAH_methods",
    "licence",
    "status",
    "TaDiRAH_goals",
    "Funders",
    "URL"
  )

# fix punctuation for subject area & methods
tool$Subjects <- gsub(";, ", "; ", tool$Subjects)
tool$Subjects <-  gsub('.{1}$', "", tool$Subjects) # remove ; at the end

tool$methods <- gsub(";, ", "; ", tool$methods)
tool$methods <-  gsub('.{1}$', "", tool$methods)


###### ---------- Record type: PUBLICATION ---------- ######
publication <- form_data %>%
  filter(`1._What is the type of record you are submitting?` == "Publication") %>%
  select(c("Timestamp", "Email Address", starts_with(c("1.", "6"))))

names(publication) <-
  c(
    "Timestamp",
    "email_collected",
    "data_submitter_name",
    "data_submitter_email",
    "Type",
    "publication_type",
    "title",
    "abstract",
    "authors",
    "Subjects",
    "methods",
    "language_primary",
    "language_other",
    "status",
    "publisher",
    "volume_no",
    "start_page_no",
    "end_page_no",
    "publication_year",
    "conference_name",
    "conference_start_date",
    "identifier",
    "licence",
    "paywall",
    "URL",
    "zotero_library"
  )

# fix punctuation for subject area & methods
publication$Subjects <- gsub(";, ", "; ", publication$Subjects)
publication$Subjects <-  gsub('.{1}$', "", publication$Subjects) # remove ; at the end

publication$methods <- gsub(";, ", "; ", publication$methods)
publication$methods <-  gsub('.{1}$', "", publication$methods)


###### ---------- Record type: TRAINING ---------- ######
training <- form_data %>%
  filter(`1._What is the type of record you are submitting?` == "Training") %>%
  select(c("Timestamp", "Email Address", starts_with(c("1.", "7", "8", "9"))))

names(training) <-
  c(
    "Timestamp",
    "email_collected",
    "data_submitter_name",
    "data_submitter_email",
    "Type",
    "contact_first_names",
    "contact_surname",
    "contact_title",
    "contact_email",
    "training_type",
    "Label",
    "Description",
    "Subjects",
    "methods",
    "Organisation",
    "Organisation_other",
    "year",
    "length",
    "frequency",
    "language_primary",
    "language_other",
    "URL",
    "inperson_or_online",
    "inperson_organisation_venue",
    "inperson_organisation_venue_other",
    "online_type"
  )

# fix punctuation for subject area & methods
training$Subjects <- gsub(";, ", "; ", training$Subjects)
training$Subjects <-  gsub('.{1}$', "", training$Subjects) # remove ; at the end

training$methods <- gsub(";, ", "; ", training$methods)
training$methods <-  gsub('.{1}$', "", training$methods)

###### ---------- Record type: ARCHIVES ---------- ######
archives <- form_data %>%
  filter(`1._What is the type of record you are submitting?` == "Archives") %>%
  select(c("Timestamp", "Email Address", starts_with(c("1.", "10"))))

names(archives) <-
  c(
    "Timestamp",
    "email_collected",
    "data_submitter_name",
    "data_submitter_email",
    "Type",
    "contact_first_names",
    "contact_surname",
    "contact_title",
    "contact_email",
    "Label",
    "Description",
    "Subjects",
    "methods",
    "Organisation",
    "Organisation_other",
    "year",
    "language_primary",
    "language_other",
    "URL"
  )

# fix punctuation for subject area & methods
archives$Subjects <- gsub(";, ", "; ", archives$Subjects)
archives$Subjects <-  gsub('.{1}$', "", archives$Subjects) # remove ; at the end

archives$methods <- gsub(";, ", "; ", archives$methods)
archives$methods <-  gsub('.{1}$', "", archives$methods)


###### ---------- Record type: LEARNING MATERIAL ---------- ######
learning_material <- form_data %>%
  filter(`1._What is the type of record you are submitting?` == "Learning Material") %>%
  select(c("Timestamp", "Email Address", starts_with(c("1.", "11"))))

names(learning_material) <-
  c(
    "Timestamp",
    "email_collected",
    "data_submitter_name",
    "data_submitter_email",
    "Type",
    "contact_first_names",
    "contact_surname",
    "contact_title",
    "contact_email",
    "Label",
    "Description",
    "Subjects",
    "methods",
    "Organisation",
    "Organisation_other",
    "learning_material_type",
    "year_created",
    "year_updated",
    "target_audience",
    "language_primary",
    "language_other",
    "available_online",
    "material_URL",
    "licence"
  )

# fix punctuation for subject area & methods
learning_material$Subjects <- gsub(";, ", "; ", learning_material$Subjects)
learning_material$Subjects <-  gsub('.{1}$', "", learning_material$Subjects) # remove ; at the end

learning_material$methods <- gsub(";, ", "; ", learning_material$methods)
learning_material$methods <-  gsub('.{1}$', "", learning_material$methods)


###### ---------- Record type: UNCLASSIFIED ---------- ######
unclassified <- form_data %>%
  filter(`1._What is the type of record you are submitting?` == "Unclassified") %>%
  select(c("Timestamp", "Email Address", starts_with(c("1.", "12"))))

names(unclassified) <-
  c(
    "Timestamp",
    "email_collected",
    "data_submitter_name",
    "data_submitter_email",
    "Type",
    "contact_first_names",
    "contact_surname",
    "contact_title",
    "contact_email",
    "Label",
    "Description",
    "Subjects",
    "methods",
    "Organisation",
    "Organisation_other",
    "year_collected",
    "language_primary",
    "language_other",
    "URL"
  )

# fix punctuation for subject area & methods
unclassified$Subjects <- gsub(";, ", "; ", unclassified$Subjects)
unclassified$Subjects <-  gsub('.{1}$', "", unclassified$Subjects) # remove ; at the end

unclassified$methods <- gsub(";, ", "; ", unclassified$methods)
unclassified$methods <-  gsub('.{1}$', "", unclassified$methods)


###### ---------- EXCLUDE DATA SUBMITTER INFO FOR SHINY ---------- ######
project <- select(project, -c("Timestamp", "email_collected", "data_submitter_name", "data_submitter_email"))
person <- select(person, -c("Timestamp", "email_collected", "data_submitter_name", "data_submitter_email"))
dataset <- select(dataset, -c("Timestamp", "email_collected", "data_submitter_name", "data_submitter_email"))
tool <- select(tool, -c("Timestamp", "email_collected", "data_submitter_name", "data_submitter_email"))
publication <- select(publication, -c("Timestamp", "email_collected", "data_submitter_name", "data_submitter_email"))
training <- select(training, -c("Timestamp", "email_collected", "data_submitter_name", "data_submitter_email"))
archives <- select(archives, -c("Timestamp", "email_collected", "data_submitter_name", "data_submitter_email"))
learning_material <- select(learning_material, -c("Timestamp", "email_collected", "data_submitter_name", "data_submitter_email"))
unclassified <- select(unclassified, -c("Timestamp", "email_collected", "data_submitter_name", "data_submitter_email"))


###### ---------- WRITE DATA SHEETS FOR Shiny ---------- ######
##### write to Google spreadsheet ##### 

ss = "https://docs.google.com/spreadsheets/d/1fUf6SbWQttVVCUAZ2jH9z24qua1BqO05Qv2lLNllsCU/edit#gid=0"

sheet_write(project, ss = ss, sheet = "project")
sheet_write(person, ss = ss, sheet = "person")
sheet_write(dataset, ss = ss, sheet = "dataset")
sheet_write(tool, ss = ss, sheet = "tool")
sheet_write(publication, ss = ss, sheet = "publication")
sheet_write(training, ss = ss, sheet = "training")
sheet_write(archives, ss = ss, sheet = "archives")
sheet_write(learning_material, ss = ss, sheet = "learning_material")
sheet_write(unclassified, ss = ss, sheet = "unclassified")

