resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  tags = {
    Name        = "hub-vpc"
    Environment = "Dev"
  }
}

resource "aws_flow_log" "this" {
  log_destination_type = "s3"
  log_destination      = aws_s3_bucket.this.arn
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.this.id
  destination_options {
    per_hour_partition = true
  }
  tags = {}
}

resource "aws_s3_bucket" "this" {
  bucket        = "hub-vpc-flowlogs"
  force_destroy = true
  tags = {
    Name        = "hub-vpc-flow"
    Environment = "Dev"
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidr_block)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr_block[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name                                            = "hub-public-subnet"
    "kubernetes.io/role/elb"                        = 1
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    Environment                                     = "Dev"
    git_repo                                        = "sa-lab"
    yor_trace                                       = "f051ff53-68a7-4047-97e6-ecf441511b3b"
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidr_block)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidr_block[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name                                            = "hub-private-subnet"
    "kubernetes.io/role/internal-elb"               = 1
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    Environment                                     = "Dev"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name      = "hub-igw"
  }
}

resource "aws_eip" "this" {
  count      = length(var.public_subnet_cidr_block)
  depends_on = [aws_internet_gateway.this]
  tags = {}
}

resource "aws_nat_gateway" "this" {
  count         = length(var.public_subnet_cidr_block)
  subnet_id     = aws_subnet.public[count.index].id
  allocation_id = aws_eip.this[count.index].id
  tags = {
    Name      = "hub-nat-gateway"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    Name      = "public-route-table"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidr_block)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  count  = length(var.private_subnet_cidr_block)
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.this[count.index].id
  }
  tags = {
    Name      = "private-route-table"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidr_block)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# resource "aws_security_group" "source_sg" {
#   name   = "source-ingress-sg"
#   vpc_id = aws_vpc.this.id

#   dynamic "ingress" {
#     for_each = toset(var.allowed_ingress_cidrs)
#     content {
#       from_port   = 0
#       to_port     = 0
#       protocol    = "-1"
#       cidr_blocks = [ingress.key]
#     }
#   }

#   egress {
#       from_port   = 0
#       to_port     = 0
#       protocol    = "-1"
#       cidr_blocks = [ "0.0.0.0/0" ]
#   }

#   tags = {
#     Name = "source-ingress-sg"
#   }
# }

# resource "aws_security_group_rule" "ingress" {
#   for_each = var.ingress_rules

#   type              = "ingress"
#   from_port         = each.value["from_port"]
#   to_port           = each.value["to_port"]
#   protocol          = each.value["protocol"]

#   security_group_id = aws_vpc.this.default_security_group_id
#   source_security_group_id = aws_security_group.source_sg.id
# }

# resource "aws_security_group_rule" "ingress" {
#   type              = "ingress"
#   from_port         = "22"
#   to_port           = "22"
#   protocol          = "tcp"
#   cidr_blocks       = var.allowed_ingress_cidrs

#   security_group_id = aws_vpc.this.default_security_group_id

# }

# resource "aws_security_group_rule" "optional" {
#   for_each = var.ingress_rules

#   type              = "ingress"
#   from_port         = each.value["from_port"]
#   to_port           = each.value["to_port"]
#   protocol          = each.value["protocol"]
#   cidr_blocks       = [ "0.0.0.0/0" ]

#   security_group_id = aws_vpc.this.default_security_group_id
# }