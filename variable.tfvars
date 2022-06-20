#provider.tf

region = ""
access = ""
secret = ""
token  = ""

#network.tf

vpc_ip       = "10.0.0.0/16"
publica-1-ip = "10.0.1.0/24"
publica-2-ip = "10.0.2.0/24"
zona-1a      = "us-east-1a"
zona-1b      = "us-east-1b"


#Bastion
ami  = "ami-0cff7528ff583bf9a"
type = "t2.micro"


#Cluster

lab-role = "arn:aws:iam::081593047351:role/LabRole"