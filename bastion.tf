resource "aws_instance" "bastion-1" {
  ami           = var.ami
  instance_type = var.type

  subnet_id                   = aws_subnet.subnet-public.id
  vpc_security_group_ids      = [aws_security_group.sg-bastion.id]
  key_name                    = "ssh-key"
  associate_public_ip_address = "true"

  #user_data       = "${file("startup.sh")}" #Ejecuta el script en la instancia
  user_data       = data.template_file.wp.rendered
  tags = {
    Name = "bastion-1"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/ssh-key.pem")
    host        = self.public_ip
  }
 
}
data "template_file" "wp" {
    template = file("./startup.tpl")
    vars = {
      region_cli = var.region
      access_cli = var.access
      secret_cli = var.secret
      token_cli = var.token
  }
 }