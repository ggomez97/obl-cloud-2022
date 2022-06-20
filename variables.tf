#provider
variable "region" {}
variable "access" {}
variable "secret" {}
variable "token" {}

#network.tf 

variable "vpc_ip" {}
variable "publica-1-ip" {}
variable "publica-2-ip" {}
variable "zona-1a" {}
variable "zona-1b" {}

#Bastion
variable "type" {}
variable "ami" {}

#Cluster
variable "lab-role" {}
