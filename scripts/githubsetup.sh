#!/bin/bash

# Repository where secrets are to be added (Organization/repo)
REPO="PrismaCloudLabs/sa-lab"

# Declare an associative array with secret names and their corresponding values
# Do not add actual secret values here as they will be commited to the repo, instead use environment variables
declare -A secrets=(
    [AWS_ACCESS_KEY_ID]=$AWS_ACCESS_KEY_ID
    [AWS_SECRET_ACCESS_KEY]=$AWS_SECRET_ACCESS_KEY
    [EC2_KEY]=$EC2_KEY
    [PC_CONSOLE]=$PC_CONSOLE
    [PC_KEY]=$PC_KEY
    [PC_SECRET]=$PC_SECRET
    [TF_API_TOKEN]=$TF_API_TOKEN
    [TF_CLOUD_ORGANIZATION]=$TF_CLOUD_ORGANIZATION
    [TF_WORKSPACE]=$TF_WORKSPACE
    [TF_WORKSPACE_ID]=$TF_WORKSPACE_ID
)

# Loop through the associative array and add each secret
for secret in "${!secrets[@]}"; do
    echo "Adding secret: $secret"
    echo "${secrets[$secret]}" | gh secret set "$secret" --repo "$REPO" --body -
done

echo "Secrets have been added/updated successfully."