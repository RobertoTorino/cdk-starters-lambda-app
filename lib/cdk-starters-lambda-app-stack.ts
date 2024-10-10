import * as cdk from 'aws-cdk-lib';
import { aws_iam, aws_lambda, aws_s3, RemovalPolicy } from 'aws-cdk-lib';
import { Construct } from 'constructs';
import { RetentionDays } from 'aws-cdk-lib/aws-logs';
import { lambdaInsightsLayerArn } from './shared';


export class CdkStartersLambdaAppStack extends cdk.Stack {
    constructor(scope: Construct, id: string, props?: cdk.StackProps) {
        super(scope, id, props);

        const cdkStartersLambdaAppBucket = new aws_s3.Bucket(this, 'CdkStartersLambdaAppBucket', {
            bucketName: 'cdk-starters-lambda-app-bucket', // disable access control lists (ACLs) and take ownership of every object in your bucket.
            objectOwnership: aws_s3.ObjectOwnership.BUCKET_OWNER_ENFORCED, // permissions on new objects are private by default and don’t allow public access.
            blockPublicAccess: aws_s3.BlockPublicAccess.BLOCK_ALL,
            encryption: aws_s3.BucketEncryption.S3_MANAGED,
            enforceSSL: true,
            versioned: true,
            removalPolicy: RemovalPolicy.DESTROY, // with this property set to true cdk will create and deploy a lambda and a custom resource.
            autoDeleteObjects: true,
            serverAccessLogsPrefix: "cdk-starters"
        });
        // give the AWS account owner read access
        cdkStartersLambdaAppBucket.grantRead(new aws_iam.AccountRootPrincipal());

        const fnGo = new aws_lambda.Function(this, 'CdkStartersGoLambdaFunction', {
            runtime: aws_lambda.Runtime.PROVIDED_AL2023,
            handler: 'main.bootstrap',
            code: aws_lambda.Code.fromAsset('./functions'),
            description: "First Go Lambda for CDK starters",
            layers: [ aws_lambda.LayerVersion.fromLayerVersionArn(this, 'GoLambdaInsightsLayer', lambdaInsightsLayerArn) ],
            logRetention: RetentionDays.ONE_DAY,
            tracing: aws_lambda.Tracing.ACTIVE,
        });

        // Grant the necessary X-Ray permissions
        fnGo.addToRolePolicy(new aws_iam.PolicyStatement({
            actions: [
                'xray:PutTelemetryRecords',
                'xray:PutTraceSegments',
            ],
            resources: [ '*' ],
        }));

        const fnPy = new aws_lambda.Function(this, 'CdkStartersPythonLambdaFunction', {
            runtime: aws_lambda.Runtime.PYTHON_3_12,
            handler: 'app.lambda_handler',
            code: aws_lambda.Code.fromAsset('./functions'),
            description: "First Python Lambda for CDK starters",
            layers: [ aws_lambda.LayerVersion.fromLayerVersionArn(this, 'PythonLambdaInsightsLayer', lambdaInsightsLayerArn) ],
            logRetention: RetentionDays.ONE_DAY,
            tracing: aws_lambda.Tracing.ACTIVE,
        });

        // Grant the necessary X-Ray permissions
        fnPy.addToRolePolicy(new aws_iam.PolicyStatement({
            actions: [
                'xray:PutTelemetryRecords',
                'xray:PutTraceSegments',
            ],
            resources: [ '*' ],
        }));
    }
}
