# Check your public IP and add it to the list of allowed ingress in order to support 
# remote access to ec2 instances. To check your public IP run: curl http://checkip.amazonaws.com
#

# GLOBALS
#

region                  = "us-east-2"
key_name                = "erick-pc" # EC2 SSH Private-Key in selected AWS region
git_repo                = "PrismaCloudLabs/sa-lab" #Organization / repo-name

ecr_name                = "pcl-ecr01"
bucket_name             = "pcl-app01data"

deploy_eks              = true
eks_cluster_name        = "code2cloud"
cluster_version         = "1.28"


s3_tags  = {
    Environment = "prod"
    Terraform   = "true"
    Department  = "Finance"
    Project     = "RayGun"
}
s3_files = {
        file1 = "sampledata/cardholder_data_primary.csv"
        file2 = "sampledata/cardholder_data_secondary.csv"
        file3 = "sampledata/cardholders_corporate.csv"
}

vmhosts = [
    {
        name            = "attacking"
        ami             = "ami-0900fe555666598a2" # AWS Linux us-east-2
        install_script  = "scripts/attackvm.sh"
        tags            = { Environment = "prod", Department = "HR" }
        defender        = true
        defender_type   = "host"
        run_containers  = false
        private_ip      = "10.100.0.254"
        ports           = [ 22 ]
        cidrs           = [ "165.1.128.0/17", "137.83.192.0/18" ] # SSH from Private IP
    },
    {
        name            = "defending"
        ami             = "ami-0900fe555666598a2" # AWS Linux us-east-2
        install_script  = "scripts/vulnerable.sh"
        tags            = { Environment = "prod" }
        defender        = true
        defender_type   = "container"
        run_containers  = true
        private_ip      = "10.100.0.100"
        ports           = [ 22, 80, 443, 9443, 3000, 8080 ]
        cidrs           = [ "0.0.0.0/0", "10.0.0.0/8", "172.16.0.0/12" ] # "0.0.0.0/0 triggers Attack Path"
    },    
    {
        name            = "victim"
        ami             = "ami-0900fe555666598a2" # AWS Linux us-east-2
        install_script  = "scripts/vulnerable.sh"
        tags            = { Environment = "dev", Project = "RayGun" }
        defender        = false
        defender_type   = "container"
        run_containers  = true
        private_ip      = "10.100.0.200"
        ports           = [ 22, 80, 443, 9443, 3000, 8080 ]
        cidrs           = [ "0.0.0.0/0", "10.0.0.0/8", "172.16.0.0/12" ] # "0.0.0.0/0 triggers Attack Path"
    }      
]