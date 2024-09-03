resource "random_string" "this" {
  lower   = true
  upper   = false
  special = false
  length  = 6
}


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
  bucket        = "hub-flowlogs-${random_string.this.id}"
  force_destroy = true
  tags = {
    Name        = "hub-flow-logs"
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