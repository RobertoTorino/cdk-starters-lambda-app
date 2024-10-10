# Development info

## Latest AWS CDK docs
> **For the latest CDK documentation, run `cdk docs`.**
 
**Make sure you have the AWS CLI `aws --version` and AWS CDK `cdk --version` installed and configured with the necessary credentials, see: `software.sh`**

**Check if the environment is already bootstrapped for the AWS CDK:**
```shell
printf "AWS CDK Bootstrap version = " && aws ssm get-parameters --name '/cdk-bootstrap/hnb659fds/version' --query 'Parameters[0].Value'
```

## Only use this for a (new) AWS account that never used CDK!

Run this script from your terminal, this only have to be done once, make sure you are logged into in to your AWS account `aws sts get-caller-identity --query Account --output text`

```shell
#!/bin/sh
# Bootstrap your AWS account
# Reference: https://docs.aws.amazon.com/cdk/v2/guide/bootstrapping.html
# CDK bootstrap creates a "CloudFormationExecutionRole" that CloudFormation assumes to deploy your stack.

# Bootstrap your AWS account for the AWS CDK and set the tags:
cdk bootstrap aws://YOUR_AWS_ACCOUNT_ID/eu-west-1 aws://YOUR_AWS_ACCOUNT_ID/us-east-1 \
  --tags Application=cdk-toolkit \
  --tags Stage=prod

# Check bootstrap version.
# printf "AWS CDK Bootstrap version = " && aws ssm get-parameters --name '/cdk-bootstrap/hnb659fds/version' --query 'Parameters[0].Value'       
```

## Basic commands and descriptions
```
Deploy the stacks in the correct order!

`npx cdk deploy`  deploy this stack to your default AWS account/region
`npx cdk diff`    compare deployed stack with current state
`npx cdk synth`   emits the synthesized CloudFormation template

The `cdk.json` file tells the CDK Toolkit how to execute your app: `npx ts-node --prefer-ts-exts`.                  
The `versionReporting` property allows you to turn off Metadata Reporting which the CDK team uses to collect analytics set this to `"versionReporting": false,`.                          
The `context` key is used to keep track of feature flags.                           
Feature flags enable the CDK team to push new features that introduce breaking changes, outside of major version releases.                  
If you start a new project with the `cdk init` command, all feature flags are set to true.          
For existing projects you can decide for yourself to opt in if this feature flag might cause breaking changes.      
```

> **Pipeline:**   
> We assume you use a self-mutating pipeline, then if you add new application stages in the source code, or new stacks, the pipeline will automatically reconfigure itself to deploy those new stages and stacks. For deploying you probably need this:
> ```shell
> PIPELINE_BRANCH=$(git branch --show-current) npx cdk deploy PipelineStack
> ```

> **Important!**            
> Be sure to `git commit -m "initial cdk codepipeline commit"` and `git push` before deploying the Pipeline stack using `cdk deploy`!               
> The reason is that the pipeline will start deploying and self-mutating right away based on the sources in the repository, so the sources it finds in there should be the ones you want it to find.

> Before deploying new resources run `cdk diff` to check what will change in your environment if you deploy the stacks.

> **CDK deploy:**                               
> Before creating a change set, `cdk deploy` will compare the template and tags of the currently deployed stack to the template and tags that are about to be deployed and will skip deployment if they are identical.                  
> Use `cdk deploy --force` to override this behavior and always deploy the stack.

> **Tip:**                           
> If the pipeline fails before it reaches the **Update Pipeline Stage** you have to do a `cdk deploy` local. Then it will pick up the latest code changes again.

> **For development you can use this environment. Then where the deployment will take place depends on the CLI's current credential settings:**
> ```typescript
> export const env = {
>    region: process.env.CDK_DEFAULT_REGION,
>    account: process.env.CDK_DEFAULT_ACCOUNT,
> };
> ```


## Cross-account resource sharing

> A little info on how to achieve cross account resource sharing.      
> To be able to get this working correctly, you have to set your policies correct on the source account (A) and on the destination account (B).       
> You have to give permission to resource A (source account) to perform actions on Resource B (destination).       
> And you have to give permission to resource B (destination) to let resource A (source) perform actions on resource B (destination).
>
> * Permission Policy on the Source (A)
> * Access Policy on the Target (B)
> * Set Trusted Relationships on the Target Role (B)
>
> The access policy accepts or rejects a request when it reaches the domain.        
> The request must be signed when an aws account or iam role is specified.


> **Optional: test your Lambda Function locally with AWS SAM.**             
> **[Reference](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-reference.html)**
> ```shell
> cdk synth --no-staging        
> sam local invoke MyFunction --no-event -t ./cdk.out/CdkSamExampleStack.template.json      
> ```
