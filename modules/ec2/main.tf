data "aws_ami" "aws_linux" {
  most_recent = true
  filter {
    name   = "product-code"
    values = ["8acfvh6bldsr1ojb0oe3n8je5"]
  }
}

resource "aws_instance" "this" {
  for_each = { for host in var.vmhosts : host.name => host }

  ami                    = data.aws_ami.aws_linux.id
  instance_type          = each.value.instance_type ? each.value.instance_type : "t2.small"
  key_name               = var.key_name
  subnet_id              = var.public_subnet_id[0]
  private_ip             = each.value.private_ip ? each.value.private_ip : null
  vpc_security_group_ids = [aws_security_group.instance_sg[each.key].id]
  root_block_device {
    volume_size = 20
  }
  associate_public_ip_address = true

  iam_instance_profile = var.instance_profile

  lifecycle {
    ignore_changes = [associate_public_ip_address]
  }

  user_data = file(each.value["install_script"])
  tags = merge(each.value.tags, { Name = each.value.name }, {})

}

resource "aws_security_group" "instance_sg" {
  for_each = { for host in var.vmhosts : host.name => host }

  name        = "${each.value.name}-sg"
  description = "Security Group for ${each.value.name}"
  vpc_id      = var.vpcId

  dynamic "ingress" {
    for_each = { for port in each.value.ports : port => port }

    content {
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = "tcp"
      cidr_blocks = each.value.cidrs
      description = "Allow inbound traffic on port ${ingress.key}"
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(each.value.tags, { Name = "${each.value.name}-sg" }, {})
}