#provider.tf

region = "us-east-1"
access = "ASIARF72TDE3QNWGOUUB"
secret = "UT3n11vzhl8Ul9qtOWGpYSPDa/IBVeqTfXjACo6X"
token  = "FwoGZXIvYXdzEDEaDEAfV4YYQKkSgA5nMSK4AU3UPMw5MQgDDwRiPLRWbBdNnea+AA7vvJiKQS0c5AyjAMHB8wfuuDjHuSX90BhJXJSVDxywfLJ/zjGW1ZeOIfbtaOIgplBb/z5uMp8dYxvoQ4iHlwDIXqkVlo7b/PAx8h6XpzIzhiPtoJvekZMI43WLpYERWTKNQ3IJroJCIxMrz/V0cqOrAZLsfbH+b/tE4oRsHKuYyh+5jSTx9iIuOGfNPX0kKMznLN/ZHydiL26pat+ToffuwG8oqP3DlQYyLTcaggdVPT98aXmcR3gCJ1nyFzs4PjnS7JGBWLKfjdr7olWu4fxXVNk+177ltA=="

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