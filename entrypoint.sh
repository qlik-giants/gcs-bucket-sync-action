#!/bin/sh
# Auth
echo "$INPUT_SECRETS" > /secrets.json
gcloud auth activate-service-account --key-file=/secrets.json
rm /secrets.json

#identify bucket name
REPO=$(echo $GITHUB_REPOSITORY| cut -d'/' -f 2)

# Sync files to bucket
echo "Syncing bucket $REPO ..."
gsutil -m rsync -r -c -d -x "$INPUT_EXCLUDE" /github/workspace gs://$INPUT_BUCKET/$REPO/$GITHUB_REF_NAME
if [ $? -ne 0 ]; then
    echo "Syncing failed"
    exit 1
fi
echo "Done."
