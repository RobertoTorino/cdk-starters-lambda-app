#!/bin/sh

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
  echo "Docker is not running. Attempting to start Docker..."

# For macOS with Docker Desktop, use the following (this assumes Docker Desktop is installed):
elif [ "$(uname)" = "Darwin" ]; then
    open --background -a Docker
    echo "Starting Docker Desktop on macOS."
    # Wait until Docker is fully running (this may take some time)
    while ! docker info >/dev/null 2>&1; do
        echo "Waiting for Docker to start..."
        sleep 3
    done
    echo "Docker Desktop is running."
    fi

# Build the templates
# cd .. || exit
# use --no-staging to disable the copy of assets which allows local debugging
# via the SAM CLI to reference the original source files.
cdk synth -q --no-staging
cd functions || exit
aws sso login

echo "You are working in AWS account:"
ID=$(aws sts get-caller-identity --query Account --output text)
ALIAS=$(aws iam list-account-aliases --query AccountAliases --output text)
printf "$ID - " && printf "$ALIAS"; echo

# Clean up Go
go mod tidy

# Build the Go executable
GOOS=linux GOARCH=amd64 go build -o bootstrap
zip --junk-paths bootstrap.zip bootstrap

# Optional
# aws s3 cp bootstrap.zip s3://cdk-starters-lambda-app-bucket/bin/handlers/bootstrap.zip

# File path to the JSON template
template_file="../cdk.out/CdkStartersLambdaAppStack.template.json"

# Extract the logical IDs of all AWS::Lambda::Function resources
lambda_logical_ids=$(jq -r '.Resources | to_entries[] | select(.value.Type == "AWS::Lambda::Function") | .key' "$template_file")

# Convert the list of logical IDs into an array
lambda_ids_array=($lambda_logical_ids)

# Initialize a variable to hold the specific Lambda functions ID
target_lambda_id=""

# Loop through the array to find the specific Lambda functions ID
for id in "${lambda_ids_array[@]}"; do
  if [[ $id == CdkStartersGoLambdaFunction* ]]; then
    target_lambda_id="$id"
    break
  fi
done

# Check if the target Lambda functions ID was found
if [ -z "$target_lambda_id" ]; then
  echo "Error: No target Lambda function found in the JSON file."
  echo "Possible options in your template:" "${lambda_ids_array[@]}"
  exit 1
fi

# Output the target Lambda functions ID (for debugging purposes)
echo "The logical ID of the target Lambda function is: $target_lambda_id"

# Test Go Lambda with SAM
sam local invoke "$target_lambda_id" --no-event -t ../cdk.out/CdkStartersLambdaAppStack.template.json
