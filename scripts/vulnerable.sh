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

# Install NPM and pip
sudo yum install -y npm pip 

# Install git
sudo yum install git -y 

# Install Node.js
sudo npm install npm@15.14.0 -g

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash 
source ~/.bashrc
source /home/ec2-user/.bashrc
nvm install node 

# Install Make
sudo yum install -y make

# Install Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose 
sudo chmod +x /usr/local/bin/docker-compose 

# Clone ai/ml repo
git clone https://github.com/Farama-Foundation/Gymnasium.git
git clone https://github.com/Azure-Samples/azure-search-openai-demo
git clone https://github.com/Azure/azure-openai-samples


# Clone MongoTools
git clone https://github.com/mongodb/mongo-tools

# Clone Sample App Repo and Run It
# git clone https://github.com/dockersamples/example-voting-app
# cd example-voting-app/
# sudo docker-compose up -d