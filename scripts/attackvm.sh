#! /bin/bash

# Direct all output to /home/ec2-user/install.log
exec > /home/ec2-user/install.log 2>&1

#Update Yum
sudo yum update -y 

# Install and Configure Docker
sudo yum install -y docker 
sudo service docker start 
sudo usermod -a -G docker ec2-user 
sudo chkconfig docker on 

# sudo yum install bind9-dnsutils
# sudo yum install net-tools

# sudo yum -y install seclists

# sudo yum install hydra
sudo yum install nmap

#Launch port scan against target VM
#nmap -v -A 10.100.0.100
#nmap -v -A 10.100.0.200