resource "aws_instance" "bastion-1" {
  ami           = var.ami
  instance_type = var.type
  subnet_id                   = aws_subnet.publica-1a.id
  vpc_security_group_ids      = [aws_security_group.sg-bastion.id]
  key_name                    = "ssh-key"
  associate_public_ip_address = "true"
  
  user_data       = data.template_file.startup.rendered
  tags = {
    Name = "bastion-1"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/ssh-key.pem")
    host        = self.public_ip
  }

  depends_on = [aws_eks_node_group.worker_obl]

}

data "template_file" "startup" {
    template = file("./startup.tpl")
    vars = {
      region_cli = var.region
      access_cli = var.access
      secret_cli = var.secret
      token_cli = var.token
  }
 }