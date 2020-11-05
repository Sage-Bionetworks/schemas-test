# README

A possible way to organize vocabularies going forward. The goal here is to have
a common set of terms we can reuse across schemas. Individual projects could
reference those terms when building schemas, because the terms themselves would
be registered in Synapse.

Right now, it's not possible for a schema in Synapse to reference only certain
definitions in another schema, so this repo turns each term into its own mini
schema. I've done this only for the terms in the experimentalData module for the
time being.

TODO:

- [X] Convert JSON Schema files into individual mini-schemas (under `terms/`)
- [X] Validate mini-schemas with `ajv compile -s "*.json"`
- [ ] Register these mini-schemas on Synapse and ensure they work (requires
      adding `"concreteType"` key stuff)
- [ ] Build a more complete schema that references the mini-schemas
- [ ] Register that schema and ensure that it works
- [ ] Set up CI to check that mini-schemas are valid and register them in
      Synapse. Need to also ensure that the version number is incremented if the
      schema changes.
