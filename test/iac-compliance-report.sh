#!/bin/bash

# Test your iac with snyk (optional debug mode = -d)
now=$(date +"%d-%m-%Y-%T")

echo "Remove old test files:"
rm -rvf test/*.html

cdk synth -q

# Copy the snyk ignore file tot the cdk.out folder
cp .snyk cdk.out/.snyk

cd cdk.out || exit

snyk iac test --json | snyk-to-html -d > ../test/snyk-iac-"${now}".html && open ../test/snyk-iac-"${now}".html
