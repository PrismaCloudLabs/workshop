# Check your public IP and add it to the list of allowed ingress in order to support 
# remote access to ec2 instances. To check your public IP run: curl http://checkip.amazonaws.com
#

region                  = "us-east-1"
git_repo                = "PrismaCloudLabs/sa-lab" #Organization / repo-name

deploy_eks              = true
cluster_version         = "1.28"

s3_tags  = {
    Environment = "prod"
    Terraform   = "true"
    Department  = "Finance"
    Criticality = "High"
    Owner       = "Nikesh Arora"
    Project     = "RayGun"
}

vmhosts = [
    {
        name            = "defending"
        install_script  = "scripts/vulnerable.sh"
        tags            = { Environment = "dev" }
        defender        = true
        defender_type   = "container"
        run_containers  = true
        ports           = [ 22, 80, 443, 9443, 3000, 8080 ]
        cidrs           = [ "0.0.0.0/0", "10.0.0.0/8", "172.16.0.0/12" ] # "0.0.0.0/0 triggers Attack Path"
    },    
    {
        name            = "victim"
        install_script  = "scripts/vulnerable.sh"
        tags            = { Environment = "prod", Project = "RayGun", Owner = "Bob Loblaw", Criticality = "High" }
        defender        = false
        defender_type   = "container"
        run_containers  = true
        ports           = [ 22, 80, 443, 9443, 3000, 8080 ]
        cidrs           = [ "0.0.0.0/0", "10.0.0.0/8", "172.16.0.0/12" ] # "0.0.0.0/0 triggers Attack Path"
    }      
]