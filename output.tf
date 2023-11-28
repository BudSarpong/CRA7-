
#VPC

resource "aws_vpc" "CRC-CLIENT" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "CRC-CLIENT"
  }
}


#SUBNETS

resource "aws_subnet" "web-public-subnets-1" {
  vpc_id            = aws_vpc.CRC-CLIENT.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "eu-west-2a"
  tags = {
    Name = "web-public-subnets-1"
  }
}

resource "aws_subnet" "app-private-subnets-1" {
  vpc_id            = aws_vpc.CRC-CLIENT.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-2b"
  tags = {
    Name = "app-private-subnets-1"
  }
}


resource "aws_subnet" "web-public-subnets-2" {
  vpc_id            = aws_vpc.CRC-CLIENT.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "eu-west-2c"
  tags = {
    Name = "web-public-subnets-2"
  }
}


resource "aws_subnet" "app-private-subnets-2" {
  vpc_id            = aws_vpc.CRC-CLIENT.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "eu-west-2a"
  tags = {
    Name = "app-private-subnets-2"
  }
}


#ROUTE-TABLES

resource "aws_route_table" "CRC-private" {
  vpc_id = aws_vpc.CRC-CLIENT.id

}


resource "aws_route_table" "CRC-public" {
  vpc_id = aws_vpc.CRC-CLIENT.id

}


#ROUTE-TABLE-ASSOCIATIONS


resource "aws_route_table_association" "CRC-private-association-1" {
  subnet_id      = aws_subnet.app-private-subnets-1.id
  route_table_id = aws_route_table.CRC-private.id
}



resource "aws_route_table_association" "CRC-private-association-2" {
  subnet_id      = aws_subnet.app-private-subnets-2.id
  route_table_id = aws_route_table.CRC-private.id
}



resource "aws_route_table_association" "CRC-public-assosition-1" {
  subnet_id      = aws_subnet.web-public-subnets-1.id
  route_table_id = aws_route_table.CRC-public.id
}


resource "aws_route_table_association" "CRC-public-assosition-2" {
  subnet_id      = aws_subnet.web-public-subnets-2.id
  route_table_id = aws_route_table.CRC-public.id
}

#IGW
resource "aws_internet_gateway" "CRC-igw" {
  vpc_id = aws_vpc.CRC-CLIENT.id

  tags = {
    Name = "CRC-igw"
  }
}

#ROUTE-IGW

resource "aws_route" "CRC-route-igw" {
  route_table_id         = aws_route_table.CRC-public.id
  gateway_id             = aws_internet_gateway.CRC-igw.id
  destination_cidr_block = "0.0.0.0/0"


}

#EIP
resource "aws_eip" "elastic-eip" {
 
}



#NGW

resource "aws_nat_gateway" "CRC-ngw" {
  allocation_id = aws_eip.CRA-eip.id
  subnet_id = aws_subnet.web-public-subnets-1.id

  tags = {
    Name = "CRC-ngw"
  }

}