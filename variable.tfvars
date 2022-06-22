#provider.tf

region = "us-east-1"
access = "ASIARF72TDE3S6GLR65Y"
secret = "nGubmUwh+XXNxa8HyblfoXwzrYbyYplDJCrQ33//"
token  = "FwoGZXIvYXdzEEoaDHyVAC7sMpZcJTiuViK4ASsKZkYq0AYvBaa52NrulKysLfEGMRy2EENLCwkOGNRo15e50HcK0bejznwm3BmYP3da33jqcaFRS3pl/KMu9dFgUyM02QvDy8MdjWLrmqWxIdtoa4rloIcrmzN/JHqyS8gCtApLa5+MIXLehzobXbSjcV+pbk+nTTBhmbZchzFnvomiji8mgb7fTYssYpftz+Ej4QvAe5irCQ+4sbVmNzYZYOizt98zGP2cDXOse90MuDf9FkpGiBso4cnJlQYyLXZ7ihW9GqNnxsWhNPQsUOMqEuXofY1d7s4erv/Ge7T/RYDFHcfuwsph+vcwMg=="

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