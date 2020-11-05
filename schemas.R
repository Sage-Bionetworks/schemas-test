###################
####  Schemas  ####
###################

## Create individual schemas for each key in experimentalData

library("jsonlite")
library("here")
library("tidyverse")

exp <- fromJSON(
  here("source-schemas", "experimentalData.json"),
  simplifyDataFrame = FALSE
)

create_mini_schema <- function(data, key) {
  schema <- c(
    "$schema" = "http://json-schema.org/draft-07/schema#",
    "$id" = glue::glue("kara-test-org-20201105-{key}.json-0.0.1"),
    data
  )
  toJSON(schema, auto_unbox = TRUE)
}

json_versions <- imap(
  exp$definitions,
  ~ create_mini_schema(data = .x, key = .y)
)

iwalk(
  json_versions,
  ~ write(
    .x,
    file = here(
      "terms",
      "experimentalData",
      glue::glue("{.y}.json")
    )
  )
)
