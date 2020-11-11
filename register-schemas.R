############################################
####  Register mini-schemas in Synapse  ####
############################################

library("synapser")
library("fs")
library("here")
library("purrr")
library("glue")

synLogin()

# Create organization ----------------------------------------------------------

## (Commented out because this only needed to be run once and I'm saving it for
## posterity)

# org <- synRestPOST(
#   uri = "/schema/organization",
#   body = '{organizationName: "karatestorg20201105"}'
# )

# Function to register JSON schema file ----------------------------------------

register_schema <- function(file) {
  synRestPOST(
    uri = "/schema/type/create/async/start",
    body = paste(readLines(file), collapse = "")
  )
}

# Register terms ---------------------------------------------------------------

term_files <- dir_ls(here("terms-synapse"), regexp = "*\\.json")

## Register each mini-schema
walk(term_files, register_schema)

## List all schemas to check they're there
synRestPOST(
  uri = "/schema/list",
  body = '{organizationName: "karatestorg20201105"}'
)

# Register top-level schema ----------------------------------------------------

# TODO update this to work after the changes in 98143ae (testschema.json no
# longer includes the full request body; need to add it here)
token <- register_schema(here("schemas", "testschema.json"))

# Retrieve schema
synRestGET(uri = glue("/schema/type/create/async/get/{token$token}"))
