# terraform-aws-eks



## Usage Instructions

Copy and paste into your Terraform configuration and set values for the input variables. Or, design a configuration to easily use module and workspace outputs as inputs.


```
module "eks-module" {
  source  = "app.terraform.io/jfmontufar32/eks-module/aws"
  version = ">= 1.0.0"
}
```

When running Terraform on the CLI, you must configure credentials in .terraformrc or terraform.rc to access this module:

```
credentials "app.terraform.io" {
    # valid user API token:
    token = "xxxxxx.atlasv1.zzzzzzzzzzzzz"
  }
```