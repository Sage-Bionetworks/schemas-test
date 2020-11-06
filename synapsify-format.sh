#!/bin/bash
FILES=./terms/experimentalData/*.json
for f in $FILES
do
    echo "Converting $f..."
    jq --argjson term "$(<$f)" '.schema |= $term' synapse-base.json > terms-synapse/$(basename $f)
done
