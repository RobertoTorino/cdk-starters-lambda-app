#!/bin/bash

# Test your iac with snyk (optional debug mode = -d)
now=$(date +"%d-%m-%Y-%T")

echo "Remove old test files:"
rm -rvf ../test/*.html

cd .. || exit
# Run Snyk code scan: scan your code for security vulnerabilities.
snyk code test --json -d | snyk-to-html -o test/snyk-code-"${now}".html && open test/snyk-code-"${now}".html
