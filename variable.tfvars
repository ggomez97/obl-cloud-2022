#Definimos las variables para el archivo provider.tf con las credenciales de AWS academy.
region = ""
access = ""
secret = ""
token  = ""

#Definimos las variables que seran usadas por el archivo network.tf 

vpc_ip       = "10.0.0.0/16" # Rango de IPs para la VPC
publica-1-ip = "10.0.1.0/24" # Rango de IPs para la subnet 1
publica-2-ip = "10.0.2.0/24" # Rango de IPs para la subnet 2
zona-1a      = "us-east-1a"  # Avaiability Zone 1
zona-1b      = "us-east-1b"  # Avaiability Zone 2

#Bastion
ami  = "ami-0cff7528ff583bf9a" # Usamos una instancia Amazon Linux 2
type = "t2.micro"              # El tipo de instancia elegida 
ssh-key= "ssh-key"             # Variable para definir que ssh-key va a utilizarse para conectarse con el bastion.
ssh-path= "~/ssh-key.pem"      # Path a donde terraform tiene que ir a buscar la clave SSH localmente.

#Definimos el rol para porder administrar los recursos desde Kubernetes Control Panel
lab-role = "arn:aws:iam::081593047351:role/LabRole"
