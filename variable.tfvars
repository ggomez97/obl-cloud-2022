#provider.tf

region = "us-east-1"
access = "ASIARF72TDE3X6OV2V6B"
secret = "+WOdOx9UyOof13TNgb/yMMM7wb1WLL933bs/MJnq"
token  = "FwoGZXIvYXdzEBYaDG4JVYrhdD8wBoH3hiK4AaHEUdCbWox/5UZvaaZVkM2GYInek5x4MO4CFVtziph7pY37MxbkTcBZhO7AK77A9pKdZL6lKBglwWdM8nS6hUGjIjZDvRheBJubCZAnZpfM05zXx6EmTtI1jK9gLaHIPEHqeUCsz1HMkFGbu/H0AII+JGnP2DHIGUavCy6ndox1IExi+lHwoddjfU1AeCjMOZaaMYSjYwRtZ8r7EbUiIxuwoH5bhiF6PsnPuggyrc8I0WjHEOHYeUQojZm+lQYyLSSd+DTrZfZOQR4Su4TyshQjo0lqVhonsoYw+YZ2K9Qe8pngbDafx/P9k9mHwQ=="

#network.tf

vpc_ip       = "10.0.0.0/16"
public_ip    = "10.0.0.0/24"
private-1-ip = "10.0.1.0/24"
private-2-ip = "10.0.2.0/24"
zona-1a      = "us-east-1a"
zona-1b      = "us-east-1b"


#Bastion
ami  = "ami-0cff7528ff583bf9a"
type = "t2.micro"


#Cluster

lab-role = "arn:aws:iam::081593047351:role/LabRole"