# README

A possible way to organize vocabularies going forward. The goal here is to have
a common set of terms we can reuse across schemas. Individual projects could
reference those terms when building schemas, because the terms themselves would
be registered in Synapse.

## What's here

There are schemas for individual terms in the `terms/` folder. The terms are
organized to mirror the modules in the original synapseAnnotations repo: there
are subfolders for each module, and the term names include the module (e.g.
`experimentalData.assay`). The terms are mini schemas that are valid JSON
Schema, such as the following:

```
{
    "$schema": "http://json-schema.org/draft-07/schema#",
    "$id": "karatestorg20201105-experimentalData.specimenID-0.0.1",
    "description": "Identifying string linked to a particular sample or specimen",
    "type": "string"
}
```

To register these schemas in Synapse, we need to slightly modify their format
and nest the schema inside of some additional JSON that Synapse requires.
`synapsify-format.sh` converts them to the correct format by adding and stores
the resulting files in `terms-synapse/`. Thus the `specimenID` schema above becomes:

```
{
  "concreteType": "org.sagebionetworks.repo.model.schema.CreateSchemaRequest",
  "schema": {
    "$schema": "http://json-schema.org/draft-07/schema#",
    "$id": "karatestorg20201105-experimentalData.specimenID-0.0.1",
    "description": "Identifying string linked to a particular sample or specimen",
    "type": "string"
  }
}
```

The terms in `terms-synapse/` have been registered in Synapse under a test
organization via the `register-schemas.R` script.

Each project can use these terms to build a schema or set of schemas to validate
annotations. By referencing the terms that are registered in Synapse, we can
reuse the same vocabulary while allowing each project to set requirements based
on their own needs. An example of such a schema is at `schemas/testschema.json`.
This too has been registered in Synapse. Real project schemas for AMP-AD, PEC,
HTAN, NF, etc. could live in this repo or could be stored elsewhere. Either way,
they'll reference the terms defined here.

Building schemas this way also provides some very limited support for synonyms.
A schema that reuses the values for `fileFormat` but wants to call the key
`fileType` could do so as follows (though we encourage using the same key names
whenever possible, since queries on Synapse will still treat `fileFormat` and
`fileType` as two unrelated keys):

```
"fileType": {
    "$ref": "karatestorg20201105-sageCommunity.fileFormat-0.0.1"
}
```

## What's to come

We still need to test out binding the registered `testschema.json` to a folder
and validating data against it.

To use these terms, HTAN and other projects that use
[schematic](https://github.com/sage-bionetworks/schematic) will need to...
[milen can you fill this in?]

Over time we will add terms to the vocabulary, and change existing terms. The
terms are versioned, and each time a term is changed we will update the version
number. That means taht only the most recent version will appear in the GitHub
repo, but older versions will remain registered in Synapse. We may want to
consider building a tool that makes it easier to look up older versions of a
term. Schemas can continue to reference old versions of a term. If a project
wants to redefine a term, it can create its own term in its own organization and
reference that one instead. 

Because versioned schemas are immutable, it is important that we always
increment the version when we change a schema. We will want to add testing to
this repo that can compare an updated version of a file with the previous
version and ensure that the version number has changed if the schema changed.
Ideally these tests will run on GitHub Actions or similar to ensure that
proposed changes follow the versioning rules before being merged. We should also
test that the terms themselves are valid JSON schema.

This testing will be important because we'd like to automatically register
updated terms to Synapse (likely also via a GitHub Actions workflow that runs
upon merging to the main branch). In the past, there was a cumbersome release
process for the synapseAnnotations repo that caused long delays between when
terms were approved and when they were available in downstream tools.
Automatically registering terms will ensure that once they've been agreed upon,
they're immediate available for use.

If we agree on this approach, then the contents of this repo should be moved to
the synapseAnnotations repo.

## Remaining questions

A few questions remain:

- Is there anything in this approach that won't work with the way Synapse
  schemas are implemented? It seems to work so far, but I haven't attempted to
  validate actual annotations yet.
- Compiling schemas locally: validation libraries like ajv let you check that
  JSON Schema is valid according to the JSON Schema spec, however this does not
  work for `testschema.json`. That's because referencing terms in a way that
  Synapse understands (in the format `organization-schema.name-version.number`)
  makes it impossible for a local validator to find them. I'm not sure what we
  should do about this.
- How do we set up the testing and CI described above? (Kara is working on this
  and has some ideas, but nothing in place and working yet)

## TODO:

- [X] Convert JSON Schema files into individual mini-schemas (under `terms/`)
- [X] Validate mini-schemas with `ajv compile`
- [X] Convert format to Synapse's required format (with `"concreteType"`)
- [X] Register these mini-schemas on Synapse and ensure they work
- [X] Build a more complete schema that references the mini-schemas
- [X] Register that schema and ensure that it works
- [ ] Add templates for new terms to make contributing easier
- [ ] Bind schema to an entity and test validation
- [ ] Set up CI to check that mini-schemas are valid. Need to also ensure that
      the version number is incremented if the schema changes.
- [ ] Automatically register terms in Synapse
