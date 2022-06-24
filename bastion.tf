resource "aws_instance" "bastion-1" { # Este recurso que permite crear la instancia bastion que utilizaremos para desplegar los deployment de kubernetes
  ami           = var.ami 
  instance_type = var.type
  subnet_id                   = aws_subnet.publica-1a.id #Le indicamos mediante variables definidas la subnet en la cual se va encontrar la instancia.
  vpc_security_group_ids      = [aws_security_group.sg-bastion.id] #Le indicamos el SG que va a utilizar la instancia.
  key_name                    = var.ssh-key # En caso de tener otro nombre de ssh-key cambiar el nombre en variable.tfvars
  associate_public_ip_address = "true" # Le asigna una IP publica dentro de la VPC.
  
  user_data       = data.template_file.startup.rendered # Este parametro permite ejecutar operaciones definidas en un template despues de que la instancia provisone
  tags = {                                              # Renderiza el template startup.tpl definido en el recurso template_file y ejecutando los comandos en el.
    Name = "bastion-1"                                  # Indicamos nu nombre para poder idetificar la instancia.
  }

  connection {                          # Definimos como terraform va a conectarse al bastion.
    type        = "ssh"                 # Definimos el protocolo que debe utilizar.
    user        = "ec2-user"            # Se define el usuario con cual conectarse.
    private_key = file(var.ssh-pah)     # Indicamos el ssh file y el path local del mismo. 
    host        = self.public_ip        # Se le indica que el host a conectar es el mismo bastion y la IP por cual conectarse por ssh.
  }

  depends_on = [aws_eks_node_group.worker_obl] # Le indicamos a terraform que debe esperar a que los workers del cluser se creen para poder crear el bastion.
                                                # ya que terraform por defecto crea primero el bastion y la secuencia de comandos en el startap.tpl son
                                                # ejecutados contra el cluster.
}

data "template_file" "startup" {     # Creamos el template "startup" que sera ejecutado luego de que el bastion este en estado "Running". 
    template = file("./startup.tpl") # Se le indica a que path debe ir a buscar el archivo startup.tpl
    vars = {                          
      region_cli = var.region        # Definimos las variables para que las credenciales sean tomadas por el startap.tpl
      access_cli = var.access        
      secret_cli = var.secret
      token_cli = var.token
  }
 }