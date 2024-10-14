# Execute a sequence of actions
all: build testme testgo testpy iacreport testreport ossreport codereport
# Manual executions: make clean, make diff, make deploy, make diagram make sso, make whereami.

## Build the templates
build:
	npm run cdk synth -q
## Executes unit tests for the code base
testme:
	npm run test
## Test Go Lambda.
testgo:
	@bash ./functions/test_go_lambda.sh
## Test Python Lambda.
testpy:
	@bash ./functions/test_python_lambda.sh
## Validate your open source code and publish html test report.
ossreport:
	@bash ./test/oss-vulnerabilities-report.sh
## Check your code for vulnerabilities and publish html test report.
codereport:
	@bash ./test/code-vulnerabilities-report.sh
## Validate your IaC and publish html test report.
iacreport:
	@bash ./test/iac-compliance-report.sh
## Show test report results.
testreport:
	open ./coverage/lcov-report/index.html
## Create simple IaC diagram.
diagram:
	npm i cdk-dia && cdk synth -q && npx cdk-dia && rm -rf diagram.dot && mv -f diagram.png ./images/diagram_small.png && open ./images/diagram_small.png && npm r cdk-dia
## Which AWS account is currently active.
whereami:
	aws sts get-caller-identity --query Account --output text && aws iam list-account-aliases --query AccountAliases --output text
## Login to AWS.
sso:
	aws sso login
## Deploy the app to your nonprod AWS account manually.
deploy:
	npx cdk deploy
## Compare and validate the new stacks with the current state in your AWS account.
compare:
	npx cdk diff --no-change-set --strict
## Cleanup the whole environment and remove all temporary files.
clean:
	rm -rvf cdk.out coverage test-results diagram test/__snapshots__ test/*.html test/.dccache functions/bootstrap functions/bootstrap.zip && git add . && git clean -df
