# Terraform SA Lab


The following variables need to be created and set for the GitHub action to properly setup your lab environment.

Create a GitHub Organization
Allow GitHub Actions in Organization to open PR's
Create a Classic PAT with the following values:

Clone this repo into your new organization

## Terraform Cloud Setup

Create a new workspace
Create a variable set in your TFC organization with the following values:

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

### SSH to EC2 Instance

Connect to Secrets Manager and save private key to local file

```Shell
aws secretsmanager get-secret-value --secret-id ssh_private_key-us-east-1 --query SecretString --output text --region us-east-1 > useast1.pem
```

Modify key permissions

```Shell
chmod 400 useast1.pem 
```

Connect to EC2 instance

```Shell
ssh -i useast1.pem ec2-user@<ip_of_ec2>
```