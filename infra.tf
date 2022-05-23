resource "aws_key_pair" "my_key" {
  key_name   = "rke-node-key"
  public_key = file("${var.ssh_key_location}.pub")
}

resource "aws_security_group" "allow-all" {
  name        = "rke-default-security-group"
  description = "rke"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "rancher_servers" {
  depends_on = [
    aws_security_group.allow-all,
    aws_key_pair.my_key,
  ]

  count         = 1
  ami           = data.aws_ami.sles.id
  instance_type = "t2.medium"
  key_name      = aws_key_pair.my_key.key_name

  subnet_id = "${tolist(data.aws_subnets.aws_subnets.ids)[count.index % 3]}"
  vpc_security_group_ids = [aws_security_group.allow-all.id]

  lifecycle {
    ignore_changes = [ami]
  }

  provisioner "remote-exec" {
    connection {
      host        = coalesce(self.public_ip, self.private_ip)
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.ssh_key_location)
    }

    inline = [
      "bash -c 'curl https://get.k3s.io | INSTALL_K3S_EXEC=\"server --node-external-ip ${aws_instance.rancher_servers[0].public_ip} --node-ip ${aws_instance.rancher_servers[0].private_ip}\" INSTALL_K3S_VERSION=${var.rancher_kube_version} sh -'"
    ]
  }
}

resource "ssh_resource" "retrieve_config" {
  depends_on = [
    aws_instance.rancher_servers
  ]
  host = aws_instance.rancher_servers[0].public_ip
  commands = [
    "sudo sed \"s/127.0.0.1/${aws_instance.rancher_servers[0].public_ip}/g\" /etc/rancher/k3s/k3s.yaml"
  ]
  user        = "ec2-user"
  private_key = file("${var.ssh_key_location}")
}

resource "local_file" "rancher_cluster_yaml" {
  depends_on = [
    ssh_resource.retrieve_config
  ]

  filename = var.kube_config_location
  content  = "${ssh_resource.retrieve_config.result}"
}
