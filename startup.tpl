#! /bin/bash 

#Instalacion de aplicaciones necesarias para la preparacion y uso del bastion (Git, Docker, AWS Cli y Kubernetes)

region_cli=${region_cli}                             # Definimos las variables de entorno que van a tomar el valor de las variables declaradas
access_cli=${access_cli}                                #  en el recurso data en el archivo bastion.tf
token_cli=${token_cli}   
secret_cli=${secret_cli} 
path="/home/ec2-user/obl-cloud-2022/online-boutique" # Definimos esta variable path para utilizarla luego en el script

yum -y install git                                   # Instalamos git sin interaccion      

yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine                     # Eliminamos cualquier instalacion de docker

yum install -y yum-utils                            # Instalamos la herramienta "yum-utils"    
amazon-linux-extras install docker -y               # Instalamos docker
systemctl enable docker                             # Habilitamos docker para que sea ejecutado en el startup del bastion.
systemctl start docker                              # Inicializamos el servicio de docker    
usermod -a -G docker ec2-user                       # Se agrega el usuario ec2-user al grupo docker

cd /home/ec2-user                                   # Se mueve a la home del usuario ec2-user

mkdir .aws                                          # Crea el directorio oculto aws        
touch /home/ec2-user/.aws/credentials               # Crea le archivo credentials
chmod 777 /home/ec2-user/.aws/credentials           # Se le agregan permisos en para todos los usuarios del sitema.

touch /home/ec2-user/.aws/config                    # Crea le archivo config
chmod 777 /home/ec2-user/.aws/config                # Se le agregan permisos en para todos los usuarios del sitema.


echo "[default]" > /home/ec2-user/.aws/config           # Se ejecutan una serie de echos con la informacion necesaria
echo "region= $region_cli">> /home/ec2-user/.aws/config     # para la conexion de AWS CLI y se redirecciona la salia hacia los respectivos archivos
echo "output= json">> /home/ec2-user/.aws/config                # substityendo la informacion con las variables previamente declaradas.

echo "[default]" > /home/ec2-user/.aws/credentials      
echo "aws_access_key_id= $access_cli" >> /home/ec2-user/.aws/credentials
echo "aws_secret_access_key= $secret_cli" >> /home/ec2-user/.aws/credentials
echo "aws_session_token= $token_cli" >> /home/ec2-user/.aws/credentials

#Kubernet
curl -LO https://dl.k8s.io/release/v1.22.1/bin/linux/amd64/kubectl  # Descarga Kubernetes
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl      # Se instala Kubectl y se cambian los permisos para poder ejecutar el comando sin sudo


git clone https://github.com/ggomez97/obl-cloud-2022.git            # Clonamos el repositorio de github que cuenta con los deployments a crear.

su - ec2-user -c "aws eks update-kubeconfig --region us-east-1 --name obl-eks-cluster"   # Conecta el bastion al cluster desde AWS CLI
su - ec2-user -c "kubectl create namespace online-boutique"                              # Crea un namespace en el cluster               
su - ec2-user -c "cd $path && kubectl create -f src/frontend/deployment/kubernetes-manifests.yaml" # Crea todo los deployment de los microservicos
#balancerip=(su -ec2-user -c "kubectl get -o json svc frontend-external --namespace online-boutique | jq .status.loadBalancer.ingress[].hostname") #Para que el .yaml tome la variable del script
su - ec2-user -c "cd $path && kubectl create -f src/adservice/deployment/kubernetes-manifests.yaml"                                                 #necesito hacer un sed desde el script para substituir el valor en el .yaml
su - ec2-user -c "cd $path && kubectl create -f src/cartservice/deployment/kubernetes-manifests.yaml"                                                   # EJEMPLO : cat app-deployment.yaml | sed "s/{{BITBUCKET_COMMIT}}/$BITBUCKET_COMMIT/g" | kubectl apply -f -
su - ec2-user -c "cd $path && kubectl create -f src/checkoutservice/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "cd $path && kubectl create -f src/currencyservice/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "cd $path && kubectl create -f src/emailservice/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "cd $path && kubectl create -f src/loadgenerator/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "cd $path && kubectl create -f src/paymentservice/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "cd $path && kubectl create -f src/productcatalogservice/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "cd $path && kubectl create -f src/recommendationservice/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "cd $path && kubectl create -f src/redis/deployment/kubernetes-manifests.yaml"
su - ec2-user -c "cd $path && kubectl create -f src/shippingservice/deployment/kubernetes-manifests.yaml"