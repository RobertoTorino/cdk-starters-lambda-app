#!/bin/bash

# Test your iac with snyk (optional debug mode = -d)
now=$(date +"%d-%m-%Y-%T")

echo "Remove old test files:"
rm -rvf ../test/*.html

cd .. || exit
# Run Snyk scan: scan your open-source libraries for vulnerabilities and license issues.
snyk test --json --all-sub-projects -d | snyk-to-html -o test/snyk-test-"${now}".html && open test/snyk-test-"${now}".html
