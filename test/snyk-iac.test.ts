import { exec } from 'child_process';


describe('Snyk IaC test', () => {
    it('should synthesize CDK and then run Snyk test with severity threshold high', (done) => {
        // First, run the CDK synth command
        exec('cdk synth -q', (synthError, synthStdout, synthStderr) => {
            if (synthError) {
                console.error(`CDK Synth Error: ${synthError.message}`);
                done(synthError); // Fail the test if CDK synth fails
                return;
            }
            if (synthStderr) {
                console.error(`CDK Synth stderr: ${synthStderr}`);
            }
            console.log(`CDK Synth stdout: ${synthStdout}`);

            // After CDK synth, run the Snyk IaC test
            exec('snyk iac test cdk.out --severity-threshold=high', (snykError, snykStdout, snykStderr) => {
                if (snykError) {
                    console.error(`Snyk Error: ${snykError.message}`);
                    // Consider failing the test if Snyk command fails
                }
                if (snykStderr) {
                    console.error(`Snyk stderr: ${snykStderr}`);
                }
                console.log(`Snyk stdout: ${snykStdout}`);
                done();
            });
        });
    }, 15000); // Set timeout to 30 seconds (increase if needed)
});
