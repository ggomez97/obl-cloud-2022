#! /bin/bash 
#Instalacion de aplicaciones necesarias para la preparacion y uso del bastion (Git, Docker, AWS Cli y Kubernetes)



sudo yum -y install git

sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine

sudo yum install -y yum-utils
sudo amazon-linux-extras install docker -y
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -a -G docker ec2-user

#Kubernet
curl -LO https://dl.k8s.io/release/v1.22.1/bin/linux/amd64/kubectl 
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

#AWS CLI
cd /home/ec2-user
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/home/ec2-user/awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

sudo git clone https://github.com/ggomez97/obl-cloud-2022.git
cd /home/ec2-user/obl-cloud-2022

aws configure

