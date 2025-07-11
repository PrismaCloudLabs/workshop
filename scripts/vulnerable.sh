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

pip install -U "huggingface_hub[cli]"
huggingface-cli download Qwen/Qwen2.5-Coder-32B-Instruct config.json tokenizer.json tokenizer_config.json
huggingface-cli download ai21labs/Jamba-v0.1 config.json tokenizer.json tokenizer_config.json
huggingface-cli download microsoft/Phi-3.5-mini-instruct config.json tokenizer.json tokenizer_config.json
huggingface-cli download tiiuae/falcon-mamba-7b-instruct config.json tokenizer.json tokenizer_config.json
huggingface-cli download deepseek-ai/DeepSeek-R1-0528 config.json tokenizer.json tokenizer_config.json
huggingface-cli download google/flan-t5-xxl config.json tokenizer.json tokenizer_config.json
huggingface-cli download microsoft/table-transformer-detection config.json tokenizer.json tokenizer_config.json

# Clone Sample App Repo and Run It
# git clone https://github.com/dockersamples/example-voting-app
# cd example-voting-app/
# sudo docker-compose up -d
