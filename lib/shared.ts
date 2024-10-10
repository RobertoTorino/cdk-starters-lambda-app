import {
    Stack, Tags
} from 'aws-cdk-lib';


export enum Environment {
    NONPROD = 'non-prod'
}

export const applicationName = 'cdk-example-lambda-app';

export const addTags = (stack: Stack, environment: Environment) => {
    Tags.of(stack).add('Application', applicationName, {
        applyToLaunchedInstances: true,
        includeResourceTypes: [],
    });
    Tags.of(stack).add('Stage', environment, {
        applyToLaunchedInstances: true,
        includeResourceTypes: [],
    });
    Tags.of(stack).add('Stackname', stack.stackName, {
        applyToLaunchedInstances: true,
        includeResourceTypes: [],
    });
};

export const lambdaInsightsLayerArn = "arn:aws:lambda:eu-west-1:580247275435:layer:LambdaInsightsExtension:53";
