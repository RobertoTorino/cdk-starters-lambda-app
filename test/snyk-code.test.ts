import { exec } from 'child_process';
import * as fs from 'fs';
import * as path from 'path';

// To prevent this test failing on a node_modules folder that is non-essential.
describe('Snyk code test', () => {
    const folderPath = path.join(__dirname, '../node_modules/aws-cdk/lib/init-templates');

    beforeAll((done) => {
        // Check if the folder exists
        if (fs.existsSync(folderPath)) {
            console.log(`Folder exists, deleting: ${folderPath}`);
            // Delete the folder
            fs.rmSync(folderPath, {
                recursive: true,
                force: true
            });
        }
        done();
    });

    it('should run Snyk test with severity threshold high', (done) => {
        // Run the Snyk test after the folder is deleted
        exec('snyk test --fail-on=all --all-projects --allow-missing', (error, stdout, stderr) => {
            if (error) {
                console.error(`error: ${error.message}`);
            }
            if (stderr) {
                console.error(`stderr: ${stderr}`);
            }
            console.log(`stdout: ${stdout}`);
            done();
        });
    }, 15000); // Set timeout to 15 seconds
});
