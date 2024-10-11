import { IAspect, Annotations, Tokenization } from 'aws-cdk-lib';
import { CfnFunction } from 'aws-cdk-lib/aws-lambda';
import { IConstruct } from 'constructs';


export class LambdaChecks implements IAspect {
    visit(node: IConstruct): void {
        if (node instanceof CfnFunction) {
            const functionId = node.node.id;
            console.log(`Checking Lambda function: ${functionId}`);
            console.log(`Visiting node: ${node.node.id}, type: ${node.constructor.name}`);

            // Log relevant properties instead of the entire object
            const properties = {
                logicalId: functionId,
                runtime: node.runtime,
                memorySize: node.memorySize,
                timeout: node.timeout,
                tracingConfig: node.tracingConfig,
            };
            console.log("Lambda function properties:", properties); // Log specific properties

            // Check for X-Ray TracingConfig
            if (!node.tracingConfig || (!Tokenization.isResolvable(node.tracingConfig) && node.tracingConfig.mode !== 'Active')) {
                Annotations.of(node).addWarning(`\n` + `🚫For Lambda function ${functionId}\n` + `🚫X-Ray tracing is NOT configured!`);
            } else {
                Annotations.of(node).addInfo(`\n` + `✅ For Lambda function ${functionId}\n` + `✅ X-Ray tracing is ENABLED!` + `\n`);
            }

            // Check for Lambda's
            Annotations.of(node).addInfo(`\n` + `✅ We found Lambda function ${functionId}.\n`);

            // Check for X-Ray TracingConfig
            if (!node.tracingConfig || (!Tokenization.isResolvable(node.tracingConfig) && node.tracingConfig.mode !== 'Active')) {
                Annotations.of(node).addWarning(`\n` + `🚫For Lambda function ${functionId}\n` + `🚫X-Ray tracing is NOT configured!` + `\n`);
            } else {
                Annotations.of(node).addInfo(`\n` + `✅ For Lambda function ${functionId}\n` + `✅ X-Ray tracing is ENABLED!` + `\n`);
            }

            // Check for Runtime
            if (node.runtime || (!Tokenization.isResolvable(node.runtime) && node.runtime)) {
                Annotations.of(node).addInfo(`\n` + `✅ For Lambda function ${functionId}\n` + `✅ The Runtime is: ${node.runtime}.` + `\n`);
            }

            // Check for MemorySize
            if (node.memorySize || (!Tokenization.isResolvable(node.memorySize) && node.memorySize)) {
                Annotations.of(node).addInfo(`\n` + `✅ For Lambda function ${functionId}\n` + `✅ The MemorySize is: ${node.memorySize}MB.` + `\n`);
            }

            // Check for Timeout
            if (node.memorySize || (!Tokenization.isResolvable(node.memorySize) && node.memorySize)) {
                Annotations.of(node).addInfo(`\n` + `✅ For Lambda function ${functionId}\n` + `✅ The Timeout is ${node.timeout} seconds.` + `\n`);
            }
        }
    }
}
