# Deploy a Lambda and a S3 Bucket with the AWS CDK

### Prerequisites:
- Go
- Python
- Makefile


## Development process via Makefile

To simplify the development process and provide an ability to run tests locally you can use the make file. You can execute a series of actions or execute individual steps.

* Build, validate and test: `make`
* Execute integration and security tests: `make test`
* Compare local stacks with the deployed stacks: `make compare`
* Cleanup the environment: `make clean`

Look at the Makefile for the other options.
