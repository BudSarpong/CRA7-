#tenacity-IT-group vpc

resource "aws_vpc" "tenacity-IT-group" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "tenacity-IT-Group"
  }
}


#subnets-tenacity-IT-group

resource "aws_subnet" "prod-pub-sub1" {
  vpc_id     = aws_vpc.tenacity-IT-group.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "prod-pub-sub1"
  }
}

resource "aws_subnet" "prod-pub-sub2" {
  vpc_id     = aws_vpc.tenacity-IT-group.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "prod-pub-sub2"
  }
}

resource "aws_subnet" "prod-priv-sub1" {
  vpc_id     = aws_vpc.tenacity-IT-group.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "prod-priv-sub1"
  }
}

resource "aws_subnet" "prod-priv-sub2" {
  vpc_id     = aws_vpc.tenacity-IT-group.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "prod-priv-sub2"
  }
}


#rout table

resource "aws_route_table" "prod-pub-route-table" {
  vpc_id = aws_vpc.tenacity-IT-group.id


  tags = {
    Name = "prod-pub-route-table"
  }
}



resource "aws_route_table" "prod-priv-route-table" {
  vpc_id = aws_vpc.tenacity-IT-group.id


  tags = {
    Name = "prod-priv-route-table"
  }
}

#Associatiions


resource "aws_route_table_association" "prod-pub-association1" {
  subnet_id      = aws_subnet.prod-pub-sub1.id
  route_table_id = aws_route_table.prod-pub-route-table.id
}


resource "aws_route_table_association" "prod-pub-association2" {
  subnet_id      = aws_subnet.prod-pub-sub2.id
  route_table_id = aws_route_table.prod-pub-route-table.id
} 


resource "aws_route_table_association" "prod-priv-association1" {
  subnet_id      = aws_subnet.prod-priv-sub1.id
  route_table_id = aws_route_table.prod-priv-route-table.id
}


resource "aws_route_table_association" "prod-priv-association2" {
  subnet_id      = aws_subnet.prod-priv-sub2.id
  route_table_id = aws_route_table.prod-priv-route-table.id
}


#internet-gateway

resource "aws_internet_gateway" "Prod-igw" {
  vpc_id = aws_vpc.tenacity-IT-group.id

  tags = {
    Name = "Prod-igw"
  }
}



#Associate the internet gateway with the public route table.

resource "aws_route" "prod-igw-association" {
  route_table_id            = aws_route_table.prod-pub-route-table.id
  gateway_id                = aws_internet_gateway.Prod-igw.id
  destination_cidr_block    = "0.0.0.0/0"
}

#Nat-gateway

resource "aws_nat_gateway" "Prod-Nat-gateway" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.prod-pub-sub1.id
   tags = {
    Name = "Prod-Nat-gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.Prod-igw]
}


resource "aws_route" "prod-Ngw-association" {
  route_table_id            = aws_route_table.prod-priv-route-table.id
  gateway_id                = aws_internet_gateway.Prod-igw.id
  destination_cidr_block    = "0.0.0.0/0"

}

