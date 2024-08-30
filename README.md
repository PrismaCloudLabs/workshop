# Terraform SA Lab


The following variables need to be created and set for the GitHub action to properly setup your lab environment.

----

### Required Repository Secrets

 | Secret |  Type  | Description |
 |--------|---------|-------------|
| AWS_ACCESS_KEY_ID | `string` | AWS IAM access key with the ability to create and provision infrastructure
| AWS_SECRET_ACCESS_KEY | `string` | Password/secret key for IAM access key
| EC2_KEY | `string` | The file contents of a pre-defined private key used to SSH into EC2 instances in the region where you deploy
| PC_CONSOLE | `string` | Runtime console path (Runtime -> Manage -> System -> Utilities )
| PC_KEY | `string` | Access key with permissions to install Defender (Settings -> Access Control -> Access Keys)
| PC_SECRET | `string` | Generated secret access key used for authentication
| TF_API_TOKEN | `string` | API token used for GitHub -> Terraform Cloud integration (Terraform Cloud -> User Drop-Down -> Account Settings -> Tokens)
| TF_CLOUD_ORGANIZATION | `string` | Name of your created Terraform Cloud Organization
| TF_WORKSPACE | `string` | Name of your created Terraform Cloud Workspace
| TF_WORKSPACE_ID | `string` | Generated ID of your Terraform Cloud Workspace