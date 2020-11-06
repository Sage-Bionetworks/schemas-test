###################
####  Schemas  ####
###################

## Create individual schemas for each key in experimentalData

library("tools")
library("jsonlite")
library("here")
library("tidyverse")
library("fs")

exp <- fromJSON(
  here("source-schemas", "experimentalData.json"),
  simplifyDataFrame = FALSE
)

create_mini_schema <- function(data, key, module) {
  schema <- c(
    "$schema" = "http://json-schema.org/draft-07/schema#",
    "$id" = glue::glue("karatestorg20201105-{module}.{key}-0.0.1"),
    data
  )
  prettify(toJSON(schema, auto_unbox = TRUE))
}

json_file_to_mini_schemas <- function(file) {
  dat <- fromJSON(file, simplifyDataFrame = FALSE)
  module <- basename(file_path_sans_ext(file))
  imap(dat$definitions, ~ create_mini_schema(data = .x, key = .y, module = module))
}

source_files <- dir_ls(here("source-schemas"))
names(source_files) <- basename(file_path_sans_ext(source_files))

## Create JSON Schema terms for each module
json_versions <- map(source_files, ~ json_file_to_mini_schemas(file = .x))

## Ensure output folders exist
dir_create(here("terms", names(source_files)))

write_files_from_module <- function(data, module_name) {
  iwalk(
    data,
    ~ write(
      .x,
      file = here(
        "terms",
        module_name,
        glue::glue("{.y}.json")
      )
    )
  )
}

## Write out all JSON mini-schemas to appropriate module subfolders
iwalk(json_versions, ~ write_files_from_module(data = .x, module_name = .y))
