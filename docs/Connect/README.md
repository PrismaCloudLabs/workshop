# Connect to K8s and EC2 Instances

Following these steps will allow you to remotely connect to the instances and K8s control plane for resources that have been deployed. 

---

1. [Setup Lab](/docs/Setup/README.md)
2. [Connect to Resources](/docs/Connect/README.md)
    - [Connect to EC2 Instance](#ssh-to-ec2-instance)
        - [Single Command](#single-command)
        - [Shell Script Alias](#shell-script-alias)
        - [Individual Commands](#individual-commands)
    - [Allow Access to EKS](#allow-access-to-eks)
    - [Connect to EKS](#update-kubeconfig)
    - [Install K8s Defender](#install-defender-helm-chart)
    - [Install Satellite](#install-satellite)

---

## SSH to EC2 Instance

Connect to Secrets Manager and save private key to local file.

### Single Command

Adjust the region and name to connect to your specified instance.

```Shell
awsRegion="us-east-1"
instanceName="raygun-dev"
instanceIP=$(aws ec2 describe-instances \
--region $awsRegion \
--filters "Name=tag:Name,Values=$instanceName" \
--query 'Reservations[*].Instances[*].PublicIpAddress' \
--output text)
rm -f $awsRegion.pem
aws secretsmanager get-secret-value --secret-id ssh_private_key-$awsRegion --query SecretString --output text --region $awsRegion > $awsRegion.pem
chmod 400 $awsRegion.pem     
ssh -i $awsRegion.pem ec2-user@$instanceIP    
```

### Shell Script Alias

Adjust region and add to your startup script in order to create an alias (connect_ec2) for connecting to instances.

```Shell
connect_ec2() {
    local awsRegion="us-east-1"
    local instanceName=${1:-"raygun-dev"}  # Default to "raygun-dev" if no argument is provided

    # Get the instance IP
    local instanceIP=$(aws ec2 describe-instances \
        --region $awsRegion \
        --filters "Name=tag:Name,Values=$instanceName" \
        --query 'Reservations[*].Instances[*].PublicIpAddress' \
        --output text)
    
    # Get and set up the SSH private key
    rm -f $awsRegion.pem
    aws secretsmanager get-secret-value --secret-id ssh_private_key-$awsRegion \
        --query SecretString --output text --region $awsRegion > $awsRegion.pem
    chmod 400 $awsRegion.pem
    
    # SSH into the instance
    ssh -i $awsRegion.pem ec2-user@$instanceIP
}

```

### Individual Commands

1. Set Region 
    ```Shell
    awsRegion="us-east-1"
    ```

1. Set Instance Name
    ```Shell
    instanceName="raygun-dev"
    ```

3. Set instance IP
    ```Shell
    instanceIP=$(aws ec2 describe-instances \ 
    --region $awsRegion \ 
    --filters "Name=tag:Name,Values=$instanceName" \ 
    --query 'Reservations[*].Instances[*].PublicIpAddress' \ 
    --output text)
    ```

4. Pull SSH key from AWS Secrets Manager
    ```Shell
    aws secretsmanager get-secret-value \ 
    --secret-id ssh_private_key-$awsRegion \ 
    --query SecretString --output text \ 
    --region $awsRegion > $awsRegion.pem
    ```

5. Modify key permissions
    ```Shell
    chmod 400 $awsRegion.pem 
    ```

6. Connect to EC2 instance
    ```Shell
    ssh -i $awsRegion.pem ec2-user@$instanceIP
    ```

---

## Allow Access to EKS

Follow these steps to add your identity to EKS in order to access cluster resources. 

1. Navigate to EKS in the AWS Portal
    - Select "Create Access Entry"

    ![eksaccess](/images/eks-permissions/step1.png)
    
2. Select your identity
    - Search for "sso" and select the SSO_AWSAdministratorAccess

    ![eksaccess](/images/eks-permissions/step2.png)

3. Add policies for cluster access 1 of 2
    - Select AmazonEKSAdminPolicy Click Add Policy

    ![eksaccess](/images/eks-permissions/step3.png)

4. Add policies for cluster access 2 of 2
    - Select AmazonEKSClusterAdminPolicy Click Add Policy
    - Select next

    ![eksaccess](/images/eks-permissions/step4.png)

5. Add permissions
    - Choose create to add your credentials

    ![eksaccess](/images/eks-permissions/step5.png)

---

## Update Kubeconfig

Running this command will allow you to execute kubectl commands against the K8s cluster deployed. 

> [!NOTE]
> You will need to add your SSO accont to the access permissions of the EKS cluster. The following Access policies need to be assigned:
>   - AmazonEKSAdminPolicy
>   - AmazonEKSClusterAdminPolicy

---

1. Set Region 
    ```Shell
    awsRegion="us-east-1"
    ```
    
2. Update kubeconfig
    ```Shell
    aws eks update-kubeconfig --region $awsRegion --name code2cloud
    ```

---

## Install Defender Helm Chart

Follow these steps to install the K8s Defender. 


1. Set Defender Helm Chart Location
    ```Shell
    helmChart=~/Downloads/twistlock-defender-helm-33.00.169.tar.gz
    ```
    
2. Create Twistlock Namespace
    ```Shell
    kubectl create namespace twistlock
    ```


3. Install Defender Helm Chart
    ```Shell
    helm upgrade --install twistlock-defender-ds --namespace twistlock --recreate-pods $helmChart
    ```

---

## Install Satellite

Follow these steps to install the K8s Satellite. 


1. Navigate to K8s Satellite in Prisma Cloud
    - Settings -> Connect Provider -> K8s Satellite

    ![k8sselect](/images/pc-satellite/step1.png)
    
2. Select K8s Cluster

    ![k8sselect](/images/pc-satellite/step2.png)


3. Copy Helm Chart Install
![k8sselect](/images/pc-satellite/step3.png)

4. Deploy Helm Chart
    ```Shell
    helm upgrade --install  prismacloud-satellite https://redlock-public.s3.amazonaws.com/helm/prismacloud-satellite/prismacloud-satellite-1.0.4.tgz \
        --namespace pc-satellite --create-namespace \
        --set global.satellite.accessKey=00000000-0000-0000-0000-000000000000 \
        --set global.satellite.prismaAPI=https://api0-events.prismacloud.io \
        --set global.satellite.clusterName=arn:aws:eks:us-east-2:000000000000:cluster/code2cloud
    ```