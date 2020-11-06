############################################
####  Register mini-schemas in Synapse  ####
############################################

library("synapser")
library("fs")
library("here")
library("purrr")

synLogin()

# Create organization ----------------------------------------------------------

## (Commented out because this only needed to be run once and I'm saving it for
## posterity)

# org <- synRestPOST(
#   uri = "/schema/organization",
#   body = '{organizationName: "karatestorg20201105"}'
# )

# Register schemas -------------------------------------------------------------

term_files <- dir_ls(here("terms-synapse"))

register_term <- function(file) {
  synRestPOST(
    uri = "/schema/type/create/async/start",
    body = paste(readLines(file), collapse = "")
  )
}

## Register each mini-schema
walk(term_files, register_term)

## List all schemas to check they're there
synRestPOST(
  uri = "/schema/list",
  body = '{organizationName: "karatestorg20201105"}'
)
