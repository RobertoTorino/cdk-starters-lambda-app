#!/bin/bash

IMAGE_NAME=$"snyk-demo"
now=$(date +"%d-%m-%Y-%T")
echo "${now}"

# docker login
docker login

docker build -t "$IMAGE_NAME":latest -f Dockerfile .
echo "new image build"

echo "start scanning container:"
snyk container test "$IMAGE_NAME":latest --file=Dockerfile --json | snyk-to-html -a > "${now}"-snyk-container.html && open "${now}"-snyk-container.html

