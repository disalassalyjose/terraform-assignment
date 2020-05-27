resource "aws_vpc" "vpc_terraform" {
  cidr_block                       = var.cidr
  instance_tenancy                 = var.instance_tenancy
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_dns_support               = var.enable_dns_support
  enable_classiclink               = var.enable_classiclink

  tags = {
      Name = var.tags
    }
}

###### Creating IG ################################

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc_terraform.id

  tags = {
    Name = "internet-gateway-vpc-terraform"
  }
}

######## Creating Subnet##########################

resource "aws_subnet" "public_1" {
  vpc_id     = aws_vpc.vpc_terraform.id
  map_public_ip_on_launch = true
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "public_1_vpc_terraform"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id     = aws_vpc.vpc_terraform.id
  map_public_ip_on_launch = false
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "private_1_vpc_terraform"
  }
}

##########33 Creating Route Table Public ##########

resource "aws_route_table" "route-public" {
  vpc_id = aws_vpc.vpc_terraform.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public_route_table_vpc_terraform"
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.route-public.id
}



################ Creating Route Table Private ######

resource "aws_route_table" "route-private" {
  vpc_id = aws_vpc.vpc_terraform.id

  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${aws_instance.terraform-nat.id}"
  }

  tags = {
    Name = "private_route_table_vpc_terraform"
  }
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.route-private.id
}
