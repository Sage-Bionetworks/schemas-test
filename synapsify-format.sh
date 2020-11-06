#!/bin/bash
FILES=./terms/*/*.json
for f in $FILES
do
    echo "Converting $f..."
    jq --argjson term "$(<$f)" '.schema |= $term' synapse-base.json > terms-synapse/$(basename $f)
done
