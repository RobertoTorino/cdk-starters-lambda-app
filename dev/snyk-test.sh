#!/bin/bash

cd .. || exit

echo "Run Snyk code scan: scan your code for security vulnerabilities."
snyk code test

echo "Run Snyk scan: scan your open-source libraries for vulnerabilities and license issues."
snyk test --all-sub-projects

echo "Run Snyk container scan: scan for container image and workload vulnerabilities."
snyk container test

echo "Run Snyk IaC scan: scan for issues in your cloud infrastructure configurations."
cdk synth -q
cd cdk.out || exit
snyk iac test
