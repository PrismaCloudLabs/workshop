# Modify your region and GitHub information before deploying
#

region                  = "us-east-1"
git_repo                = "YourOrg/YourRepo" #Organization / repo-name

deploy_eks              = true
cluster_version         = "1.31"

s3_tags  = {
    Environment = "prod"
    Terraform   = "true"
    Department  = "Finance"
    Criticality = "High"
    Owner       = "Bob Loblaw"
    Project     = "RayGun"
}

vmhosts = [
    {
        name            = "raygun-dev"
        install_script  = "scripts/vulnerable.sh"
        tags            = {  Environment = "dev", Project = "RayGun", Owner = "Bob Loblaw", Criticality = "Medium" }
        instance_type   = "t2.medium"
        defender        = false
        defender_type   = "container"
        run_containers  = true
        ports           = [ 22, 80, 443, 9443, 3000, 8080 ]
        cidrs           = [ "0.0.0.0/0", "10.0.0.0/8", "172.16.0.0/12" ] # "0.0.0.0/0 triggers Attack Path"
    },    
    {
        name            = "raygun-prod"
        install_script  = "scripts/vulnerable.sh"
        tags            = { Environment = "prod", Project = "RayGun", Owner = "Bob Loblaw", Criticality = "High" }
        instance_type   = "t2.medium"
        defender        = false
        defender_type   = "container"
        run_containers  = true
        ports           = [ 22, 80, 443, 9443, 3000, 8080 ]
        cidrs           = [ "0.0.0.0/0", "10.0.0.0/8", "172.16.0.0/12" ] # "0.0.0.0/0 triggers Attack Path"
    }      
]
