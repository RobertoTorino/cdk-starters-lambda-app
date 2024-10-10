package main

import (
	"context"
	"github.com/aws/aws-lambda-go/lambda"
)

// Define a handler functions which will handle the Lambda request
func bootstrap(ctx context.Context) (string, error) {
	return " ✨ ✨ Success! Hello from SAM, CDK and the Go Lambda! ✨ ✨ ", nil
}

func main() {
	// Start the Lambda functions
	lambda.Start(bootstrap)
}
