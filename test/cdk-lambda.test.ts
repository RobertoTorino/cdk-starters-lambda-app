import { aws_lambda, Stack } from 'aws-cdk-lib';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import { Template } from 'aws-cdk-lib/assertions';


test('Lambda function has correct handler and runtime', () => {
    // Create the stack
    const stack = new Stack();

    // Define the Lambda function
    new lambda.Function(stack, 'StarterLambda', {
        runtime: lambda.Runtime.PYTHON_3_12,
        code: lambda.Code.fromAsset('functions'),
        handler: 'app.lambda_handler',
        tracing: aws_lambda.Tracing.ACTIVE,
    });

    // Extract the CloudFormation template from the stack
    const template = Template.fromStack(stack);

    // Assert the Lambda function has the correct properties
    template.hasResourceProperties('AWS::Lambda::Function', {
        Handler: 'app.lambda_handler',
        Runtime: 'python3.12',
    });
});
