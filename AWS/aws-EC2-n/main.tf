resource "aws_instance" "myinstance" {
  count         = var.ec2-instances.count
  ami           = var.ec2-instances.ami[count.index]
  instance_type = var.ec2-instances.instance_type[count.index]
  root_block_device {
    volume_size = var.ec2-instances.storage[count.index]
  }
  tags = {
    "Name"        = var.ec2-instances.name[count.index]
    "Created By"  = var.ec2-instances.tags["Created By"]
    "Description" = var.ec2-instances.tags["Description"]
  }
  key_name               = aws_key_pair.my-key.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
}

resource "aws_key_pair" "my-key" {
  public_key = file("${var.public_key}")
}

resource "aws_security_group" "my_sg" {
  name = "my-sg2"
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
