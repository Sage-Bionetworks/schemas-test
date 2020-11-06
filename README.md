# README

A possible way to organize vocabularies going forward. The goal here is to have
a common set of terms we can reuse across schemas. Individual projects could
reference those terms when building schemas, because the terms themselves would
be registered in Synapse.

Right now, it's not possible for a schema in Synapse to reference only certain
definitions in another schema, so this repo turns each term into its own mini
schema. I've done this only for the terms in the experimentalData module for the
time being. `source-schemas/` contains the JSON Schema file copied from Cindy's
repo -- this folder can be removed in the future, but is left in for now to
illustrate how we convert the JSON Schema into mini-schemas via
`create-mini-schemas.R`.

Terms are defined in the `terms/` folder. These are valid JSON Schema files (to
check that they are valid, run `ajv compile -s "terms/*/*.json`). These are the
files that should be edited when adding new values, etc.

To register these terms on Synapse requires a slightly different format with a
couple extra keys. `synapsify-format.sh` converts the files in `terms/` into the
correct format, and saves them in `terms-synapse/`. Each of these terms has been
registered in Synapse via the `register-schemas.R` script. Ultimately, I think
we want to automate converting the JSON format and registering to Synapse.

Higher-level schemas that reference the individual terms are in `schemas/` (but
could also live elsewhere, including outside of this repo). One current issue is
that ajv-cli can't validate the schema because it can't find the references in
the format they're in...but that format is required for Synapse. Not sure what
to do about that.

TODO:

- [X] Convert JSON Schema files into individual mini-schemas (under `terms/`)
- [X] Validate mini-schemas with `ajv compile`
- [X] Convert format to Synapse's required format (with `"concreteType"`)
- [X] Register these mini-schemas on Synapse and ensure they work
- [X] Build a more complete schema that references the mini-schemas
- [X] Register that schema and ensure that it works
- [ ] Bind schema to an entity and test validation
- [ ] Set up CI to check that mini-schemas are valid and register them in
      Synapse. Need to also ensure that the version number is incremented if the
      schema changes.
