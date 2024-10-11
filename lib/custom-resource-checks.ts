import { IAspect } from 'aws-cdk-lib';
import { IConstruct } from 'constructs';


export class CustomResourceChecks implements IAspect {
    visit(node: IConstruct): void {
        console.log(`Visiting node: ${node.node.id}, type: ${node.node.root.node.id.}`);

        // Check for Custom Resources
        if (node.node.id.startsWith('Custom::') ||
            node.node.id.includes('LogRetention')) {
            console.log(`⚠️ Custom Resource detected: ${node.node.id}`);
        }
    }
}
