# Code to Cloud AWS Workshop

Follow the steps below to setup your lab environment. 

## Prerequisites

- AWS IAM user with permissions to deploy resources via access key
- Subscribe to [AWS Linux 2023 AMI](https://aws.amazon.com/marketplace/pp/prodview-ii52uljrxoqiq) from the AWS Marketplace

## Workshop Installation

1. [Setup Lab](docs/Setup/README.md)
2. [Connect to Resources](docs/Connect/README.md)

## Known Issues

1. The initial deployment may fail due to timing issues with EKS. Terraform will report the infrastructure as being deployed, but the K8s cluster is not fully operational which causes a failure when trying to apply the helm chart. If this happens re-run the deployment.

 ![rerunjob](/images/github/rerunjob.png)

2. The deploy_eks value in terraform.tfvars has no effect. Due to the cost and time to deploy EKS this is meant to be a toggle, but it has not been implemented. As it is required for code2cloud tracing this is not a priority to address.

3. The current ec2 deployment is not compatible with drift detection. A new version will be deployed soon that addresses this issue.

4. Clicking on links in GitHub Action logs that direct to the Terraform Cloud run will not work. Because we treat the organization and workspace names as sensitive values they are masked in the log output.

 ![brokenlink](/images/github/tfc-bad-link.png)