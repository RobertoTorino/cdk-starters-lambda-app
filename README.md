# cdk-starters-lambda-app

**1. Create 2 Lambda's and an S3 Bucket in AWS CDK**                    
**2. Test your Lambda functions with SAM**    
**3. Scan your code and IaC for vulnerabilities and misconfigurations.**                      
**4. Run a code coverage report with jest.**   
**5. View reports for your findings.**

### Prerequisites:
- CDK
- Go
- Python
- Makefile

**With only one stack, run `cdk synth -q` to be able to view the notifications from CDK or use `make build`.**             

## Development process via Makefile

To simplify the development process and provide an ability to run tests locally you can use the make file. You can execute a series of actions or execute individual steps.

* Build, validate and test: `make`
* Execute integration and security tests: `make test`
* Compare local stacks with the deployed stacks: `make compare`
* Cleanup the environment: `make clean`

Look at the Makefile for the other options.
