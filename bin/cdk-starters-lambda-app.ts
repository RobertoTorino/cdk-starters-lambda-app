#!/usr/bin/env node
import * as cdk from 'aws-cdk-lib';
import {
    addTags, Environment
} from '../lib/shared';
import { CdkStartersLambdaAppStack } from '../lib/cdk-starters-lambda-app-stack';
import * as fs from 'fs';
import * as path from 'path';
import { Aspects } from 'aws-cdk-lib';
import { LambdaChecks } from '../lib/lambda-checks';


export const env = {
    account: process.env.CDK_SYNTH_ACCOUNT || process.env.CDK_DEFAULT_ACCOUNT,
    region: process.env.CDK_SYNTH_REGION || process.env.CDK_DEFAULT_REGION,
};

/*// Define a type for the Lambda resource structure
interface LambdaResource {
    Type: string;
    Properties?: LambdaProperties;
}

// Define a type for Lambda properties, including TracingConfig and Runtime
interface LambdaProperties {
    Runtime?: string;
    TracingConfig?: TracingConfig;
    Timeout?: number;
    MemorySize?: number;
}

// Define a type for the TracingConfig properties
interface TracingConfig {
    Mode: string;
}

// Function to check for Lambda functions in the JSON template
function checkLambdaFunctions(templateFilePath: string) {
    const template = JSON.parse(fs.readFileSync(templateFilePath, 'utf8'));

    // Extract Lambda functions from the template
    const lambdaFunctions = Object.entries(template.Resources).filter(
        ([_, resource]) => (resource as LambdaResource).Type === 'AWS::Lambda::Function'
    );

    lambdaFunctions.forEach(([functionId, resource]) => {
        const lambdaResource = resource as LambdaResource;

        // Ensure Properties is initialized
        if (!lambdaResource.Properties) {
            lambdaResource.Properties = {};
        }

        // Check if TracingConfig exists
        if (!lambdaResource.Properties.TracingConfig) {
            console.warn(`🚫X-Ray tracing is NOT configured for Lambda function ${functionId}!`);
        } else {
                console.log(`✅ X-Ray tracing is ENABLED for Lambda function ${functionId}.`);
        }

        // Check for Runtime
        if (lambdaResource.Properties.Runtime) {
            console.log(`✅ Runtime for Lambda function ${functionId} is ${lambdaResource.Properties.Runtime}.`);
        }

        // Check for memory size
        if (lambdaResource.Properties.MemorySize) {
            console.log(`✅ MemorySize for Lambda function ${functionId} is ${lambdaResource.Properties.MemorySize} MB.`);
        }

        // Check for timeout
        if (lambdaResource.Properties.Timeout) {
            console.log(`✅ Timeout for Lambda function ${functionId} is ${lambdaResource.Properties.Timeout} seconds.`);
        }
    });
}*/

const app = new cdk.App();
const cdkStartersLambdaApp = new CdkStartersLambdaAppStack(app, 'CdkStartersLambdaAppStack', {
    stackName: 'CdkStartersLambdaAppStack',
    description: 'CDK starters Lambda app.',
    env,
});
addTags(cdkStartersLambdaApp, Environment.NONPROD);
Aspects.of(cdkStartersLambdaApp).add(new LambdaChecks())


/*// Call the function with the path to your template file
const templateFilePath = path.join(__dirname, '..', 'cdk.out', 'CdkStartersLambdaAppStack.template.json');
checkLambdaFunctions(templateFilePath);*/

app.synth();
