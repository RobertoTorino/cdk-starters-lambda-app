import { App } from 'aws-cdk-lib';
import { env } from '../bin/cdk-starters-lambda-app';
import { CdkStartersLambdaAppStack } from '../lib/cdk-starters-lambda-app-stack';


describe('Synthesize tests', () => {
    const app = new App();

    test('Creates the stack without exceptions', () => {
        expect(() => {
            new CdkStartersLambdaAppStack(app, 'CdkStartersLambdaAppStack', {
                description: 'CdkStartersLambdaAppStack',
                env,
            });
        }).not.toThrow();
    });

    test('This app can synthesize completely', () => {
        expect(() => {
            app.synth();
        }).not.toThrow();
    });
});
