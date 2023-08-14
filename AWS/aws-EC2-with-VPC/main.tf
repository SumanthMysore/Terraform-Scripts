resource "aws_instance" "myinstance" {
  ami           = var.instance.ami
  instance_type = var.instance.instance_type
  root_block_device {
    volume_size = var.instance.storage
  }
  tags = {
    "Name"        = var.instance.name
    "Created By"  = var.instance.tags["Created By"]
    "Description" = var.instance.tags["Description"]
  }
  key_name               = aws_key_pair.my-key.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  subnet_id              = data.aws_subnet.existing_subnet.id
}

data "aws_vpc" "existing_vpc" {
  id = var.instance.vpc["vpc_id"]
}

data "aws_subnet" "existing_subnet" {
  vpc_id = data.aws_vpc.existing_vpc.id
  id     = var.instance.vpc["subnet_id"]
}

resource "aws_key_pair" "my-key" {
  public_key = file("${var.public_key}")
}

resource "aws_security_group" "my_sg" {
  vpc_id = data.aws_vpc.existing_vpc.id
}

resource "aws_security_group_rule" "inbound_rules" {
  count = length(var.inbound_rules)

  type              = "ingress"
  from_port         = var.inbound_rules[count.index].from_port
  to_port           = var.inbound_rules[count.index].to_port
  protocol          = var.inbound_rules[count.index].protocol
  cidr_blocks       = [var.inbound_rules[count.index].cidr_block]
  security_group_id = aws_security_group.my_sg.id
}

resource "aws_security_group_rule" "outbound_rules" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.my_sg.id
}
