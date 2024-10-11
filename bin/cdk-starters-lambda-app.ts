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
import { CustomResourceChecks } from '../lib/custom-resource-checks';


export const env = {
    account: process.env.CDK_SYNTH_ACCOUNT || process.env.CDK_DEFAULT_ACCOUNT,
    region: process.env.CDK_SYNTH_REGION || process.env.CDK_DEFAULT_REGION,
};

const app = new cdk.App();
const cdkStartersLambdaApp = new CdkStartersLambdaAppStack(app, 'CdkStartersLambdaAppStack', {
    stackName: 'CdkStartersLambdaAppStack',
    description: 'CDK starters Lambda app.',
    env,
});
addTags(cdkStartersLambdaApp, Environment.NONPROD);
// Aspects.of(cdkStartersLambdaApp).add(new LambdaChecks())
// Aspects.of(cdkStartersLambdaApp).add(new CustomResourceChecks())

app.synth();
