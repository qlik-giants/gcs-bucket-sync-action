#!/bin/sh
# Auth
echo "$INPUT_SECRETS" > /secrets.json
gcloud auth activate-service-account --key-file=/secrets.json
rm /secrets.json

#identify bucket name
BUCKET=$(echo $GITHUB_HEPOSITORY| cut -d'/' -f 2)

# Sync files to bucket
echo "Syncing bucket $BUCKET ..."
gsutil -m rsync -r -c -d -x "$INPUT_EXCLUDE" /github/workspace/$BUCKET gs://$INPUT_BUCKET/$BUCKET
if [ $? -ne 0 ]; then
    echo "Syncing failed"
    exit 1
fi
echo "Done."
