#!/usr/bin/env node
import * as cdk from 'aws-cdk-lib';
import {
    addTags,
    Environment
} from '../lib/shared';
import { CdkStartersLambdaAppStack } from '../lib/cdk-starters-lambda-app-stack';
import * as fs from 'fs';
import * as path from 'path';

export const env = {
    account: process.env.CDK_SYNTH_ACCOUNT || process.env.CDK_DEFAULT_ACCOUNT,
    region: process.env.CDK_SYNTH_REGION || process.env.CDK_DEFAULT_REGION,
};


// Define a type for the Lambda resource structure
interface LambdaResource {
    Type: string;
    Properties?: {
        TracingConfig?: {
            Mode: string;
        };
    };
}

// Function to check for Lambda functions in the JSON template
function checkLambdaFunctions(templateFilePath: string) {
    const template = JSON.parse(fs.readFileSync(templateFilePath, 'utf8'));

    // Extract Lambda functions from the template
    const lambdaFunctions = Object.entries(template.Resources).filter(([_, resource]) =>
        (resource as LambdaResource).Type === 'AWS::Lambda::Function'
    );

    lambdaFunctions.forEach(([functionId, resource]) => {
        console.log(`Checking Lambda Function: ${functionId}`);

        const lambdaResource = resource as LambdaResource;

        // Ensure Properties is initialized
        if (!lambdaResource.Properties) {
            lambdaResource.Properties = {};
        }

        // Check if TracingConfig exists
        if (!lambdaResource.Properties?.TracingConfig) {
            console.warn(`X-Ray tracing is NOT configured for Lambda function ${functionId}!`);
            // Add your logic to add TracingConfig here
            lambdaResource.Properties.TracingConfig = { Mode: 'Active' };
        } else {
            console.log(`X-Ray tracing is enabled for Lambda function ${functionId}.`);
        }
    });
}

const app = new cdk.App();
const cdkStartersLambdaApp = new CdkStartersLambdaAppStack(app, 'CdkStartersLambdaAppStack', {
    stackName: 'CdkStartersLambdaAppStack',
    description: 'CDK starters Lambda app.',
    env,
});
addTags(cdkStartersLambdaApp, Environment.NONPROD);


// Call the function with the path to your template file
const templateFilePath = path.join(__dirname, '..', 'cdk.out', 'CdkStartersLambdaAppStack.template.json');
checkLambdaFunctions(templateFilePath);

app.synth();
