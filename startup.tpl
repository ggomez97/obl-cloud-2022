#! /bin/bash 
#Instalacion de aplicaciones necesarias para la preparacion y uso del bastion (Git, Docker, AWS Cli y Kubernetes)

region_cli=${region_cli}
access_cli=${access_cli}
token_cli=${token_cli}
secret_cli=${secret_cli} 
path="/home/ec2-user/obl-cloud-2022/online-boutique"

yum -y install git

yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine

yum install -y yum-utils
amazon-linux-extras install docker -y
systemctl enable docker
systemctl start docker
usermod -a -G docker ec2-user

cd /home/ec2-user

mkdir .aws
touch /home/ec2-user/.aws/credentials
chmod 777 /home/ec2-user/.aws/credentials

touch /home/ec2-user/.aws/config
chmod 777 /home/ec2-user/.aws/config


echo "[default]" > /home/ec2-user/.aws/config
echo "region= $region_cli">> /home/ec2-user/.aws/config
echo "output= json">> /home/ec2-user/.aws/config

echo "[default]" > /home/ec2-user/.aws/credentials
echo "aws_access_key_id= $access_cli" >> /home/ec2-user/.aws/credentials
echo "aws_secret_access_key= $secret_cli" >> /home/ec2-user/.aws/credentials
echo "aws_session_token= $token_cli" >> /home/ec2-user/.aws/credentials

#Kubernet
curl -LO https://dl.k8s.io/release/v1.22.1/bin/linux/amd64/kubectl 
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl


git clone https://github.com/ggomez97/obl-cloud-2022.git


su - ec2-user -c "aws eks update-kubeconfig --region us-east-1 --name obl-eks-cluster"
su - ec2-user -c "kubectl create namespace online-boutique"
su - ec2-user -c "cd $path && kubectl create -f src/frontend/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "cd $path && kubectl create -f src/adservice/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "cd $path && kubectl create -f src/cartservice/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "cd $path && kubectl create -f src/checkoutservice/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "cd $path && kubectl create -f src/currencyservice/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "cd $path && kubectl create -f src/emailservice/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "cd $path && kubectl create -f src/loadgenerator/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "cd $path && kubectl create -f src/paymentservice/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "cd $path && kubectl create -f src/productcatalogservice/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "cd $path && kubectl create -f src/recommendationservice/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "cd $path && kubectl create -f src/redis/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "cd $path && kubectl create -f src/shippingservice/deployment/kubernetes-manifests.yaml"