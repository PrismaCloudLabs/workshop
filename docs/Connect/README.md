# Connect to K8s and EC2 Instances

Following these steps will allow you to remotely connect to the instances and K8s control plane for resources that have been deployed. 

---

1. [Setup Lab](docs/Setup/README.md)
2. [Connect to Resources](docs/Connect/README.md)
    - [Connect to EC2 Instance](ssh-to-ec2-instance)
    - [Connect to EKS Control Plane](update-kubeconfig)
    - [Install K8s Defender](install-defender-helm-chart)
    - Install Satellite(install-satellite)

---

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

## Install Satellite

Follow these steps to install the K8s Satellite. 


1. Navigate to K8s Satellite in Prisma Cloud
    - Settings -> Connect Provider -> K8s Satellite

    ![k8sselect](images/pc-satellite/step1.png)
    
2. Select K8s Cluster

    ![k8sselect](images/pc-satellite/step2.png)


3. Copy Helm Chart Install
![k8sselect](images/pc-satellite/step3.png)

4. Deploy Helm Chart
    ```Shell
    helm upgrade --install  prismacloud-satellite https://redlock-public.s3.amazonaws.com/helm/prismacloud-satellite/prismacloud-satellite-1.0.4.tgz \
        --namespace pc-satellite --create-namespace \
        --set global.satellite.accessKey=00000000-0000-0000-0000-000000000000 \
        --set global.satellite.prismaAPI=https://api0-events.prismacloud.io \
    -   -set global.satellite.clusterName=arn:aws:eks:us-east-2:000000000000:cluster/code2cloud
    ```