# Code to Cloud AWS Workshop

---

1. [Setup Lab](/docs/Setup/README.md)
    - [GitHub Setup 1 of 3](#github-setup-1-of-3)
    - [Terraform Cloud Setup 2 of 3](#terraform-cloud-setup-2-of-3)
    - [GitHub Setup 3 of 3](#github-setup-3-of-3)
        - [Required Repository Secrets](#required-repository-secrets)
2. [Connect to Resources](/docs/Connect/README.md)

---

## GitHub Setup 1 of 3

1. [Create a GitHub Organization](https://docs.github.com/en/organizations/collaborating-with-groups-in-organizations/creating-a-new-organization-from-scratch)
2. Allow GitHub Actions in Organization to open PR's
    - Click on your new Organization Name
    - Settings (top nav)
    - Actions -> General (left nav)
    - Scroll to bottom of page, select: "Allow GitHub Actions to create and approve pull requests"
    - Click "Save"

    ![action](/images/github/action-pr.png)

3. [Create a Classic PAT](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token-classic) with the following values, and save the generated token:
    - repo (all values)
    - workflow
    - read:public_key
    - read:repo_hook
    - notifications
4. Clone this repo into your new organization
    - Use this template -> create a new repository

---

## Terraform Cloud Setup 2 of 3

1. Create a new workspace in your organization
    - Organization -> Workspaces -> New (Workspace) -> API-Driven Workflow

![workspace](/images/tfc/workspace.png)

2. Create a variable set in your TFC organization
    - Organization -> Settings -> Variable sets -> Create variable set
    - Name the variable set (Prisma Cloud Lab, etc.)
3. Create the following variables in the set

 | Name |  Type  | Sensitive | Value |
 |------|--------|-----------|-------|
 | <pre lang="sh">AWS_ACCESS_KEY_ID</pre> | Environment variable | false | AWS Access key
 | <pre lang="sh">AWS_SECRET_ACCESS_KEY</pre> | Environment variable | true | AWS Access key secret
 | <pre lang="sh">TF_VAR_git_token</pre> | Terraform variable | true | GitHub PAT value from above

---

## GitHub Setup 3 of 3

> [!NOTE]
> If you do not see your repo make certain you first navigate to the organization you just created

1. Create the following secrets in your GitHub repository
    - Navigate to your repo
    - Settings (top nav)
    - Secrets and variables -> Actions (side nav)
    - New respository secret
    - Repeat until all values have been added

### Required Repository Secrets

 | Secret |  Type  | Description |
 |--------|---------|-------------|
| <pre lang="sh">AWS_ACCESS_KEY_ID</pre> | `string` | AWS IAM access key with the ability to create and provision infrastructure
| <pre lang="sh">AWS_SECRET_ACCESS_KEY</pre> | `string` | Password/secret key for IAM access key
| <pre lang="sh">PC_CONSOLE</pre> | `string` | Runtime console path (Runtime -> Manage -> System -> Utilities )
| <pre lang="sh">PC_KEY</pre> | `string` | Access key with permissions to install Defender (Settings -> Access Control -> Access Keys)
| <pre lang="sh">PC_SECRET</pre> | `string` | Generated secret access key used for authentication
| <pre lang="sh">TF_API_TOKEN</pre> | `string` | API token used for GitHub -> Terraform Cloud integration (Terraform Cloud -> User Drop-Down -> Account Settings -> Tokens)
| <pre lang="sh">TF_CLOUD_ORGANIZATION</pre> | `string` | Name of your created Terraform Cloud Organization
| <pre lang="sh">TF_WORKSPACE</pre> | `string` | Name of your created Terraform Cloud Workspace
| <pre lang="sh">TF_WORKSPACE_ID</pre> | `string` | Generated ID of your Terraform Cloud Workspace

---

## First Deployment

1. Edit the [terraform.tfvars](/terraform.tfvars) file in the repo root