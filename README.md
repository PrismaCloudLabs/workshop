# Code to Cloud AWS Workshop


## GitHub Setup

The following variables need to be created and set for the GitHub action to properly setup your lab environment.

1. Create a GitHub Organization
2. Allow GitHub Actions in Organization to open PR's
3. Create a Classic PAT with the following values
4. Clone this repo into your new organization

## Terraform Cloud Setup

1. Create a new workspace
2. Create a variable set in your TFC organization with the following values:

Terraform variable with a sensitive value
Key: TF_VAR_git_token Value: PAT from above




----

### Required Repository Secrets

 | Secret |  Type  | Description |
 |--------|---------|-------------|
| AWS_ACCESS_KEY_ID | `string` | AWS IAM access key with the ability to create and provision infrastructure
| AWS_SECRET_ACCESS_KEY | `string` | Password/secret key for IAM access key
| PC_CONSOLE | `string` | Runtime console path (Runtime -> Manage -> System -> Utilities )
| PC_KEY | `string` | Access key with permissions to install Defender (Settings -> Access Control -> Access Keys)
| PC_SECRET | `string` | Generated secret access key used for authentication
| TF_API_TOKEN | `string` | API token used for GitHub -> Terraform Cloud integration (Terraform Cloud -> User Drop-Down -> Account Settings -> Tokens)
| TF_CLOUD_ORGANIZATION | `string` | Name of your created Terraform Cloud Organization
| TF_WORKSPACE | `string` | Name of your created Terraform Cloud Workspace
| TF_WORKSPACE_ID | `string` | Generated ID of your Terraform Cloud Workspace



## SSH to EC2 Instance

Connect to Secrets Manager and save private key to local file.


1. Set Region 
    ```Shell
    awsRegion="us-east-1"
    ```

2. Set instance IP
    ```Shell
    instanceIP="1.1.1.1"
    ```

3. Pull SSH key from AWS Secrets Manager
    ```Shell
    aws secretsmanager get-secret-value --secret-id ssh_private_key-$awsRegion --query SecretString --output text --region $awsRegion > $awsRegion.pem
    ```

4. Modify key permissions
    ```Shell
    chmod 400 $awsRegion.pem 
    ```

5. Connect to EC2 instance
    ```Shell
    ssh -i $awsRegion.pem ec2-user@$instanceIP
    ```


## Update Kubeconfig

Connect to Secrets Manager and save private key to local file.


1. Set Region 
    ```Shell
    awsRegion="us-east-1"
    ```
2. Update kubeconfig
    ```Shell
        aws eks update-kubeconfig --region $awsRegion --name code2cloud
    ```