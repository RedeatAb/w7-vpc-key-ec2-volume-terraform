//creating VPC 

resource "aws_vpc" "my-vpc" {
  cidr_block           = "172.120.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default" // vpc is shared among other people 


  tags = {
    Name       = "utc-app1"
    env        = " dev"
    Team       = "wdp"
    app-name   = "utc"
    created_by = "Redeat"
  }
}


// creating internt gateway 
//internet gateway is to make our vpc public without this our vpc will be private  


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my-vpc.id # vpc getting attached to internet gateway

  tags = {
    Name = "dev-wdp-IGW"
  }
}


//creating public subnets 

resource "aws_subnet" "public1-subnet" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = "172.120.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "utc-public1-subnet"
  }
}

resource "aws_subnet" "public2-subnet" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = "172.120.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "utc-public2-subnet"
  }
  depends_on = [aws_vpc.my-vpc] #dependecies 
}

// creating private subnets
resource "aws_subnet" "private1-subnet" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "172.120.3.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name = "utc-private1-subnet"
  }
}


resource "aws_subnet" "private2-subnet" {
  vpc_id            = aws_vpc.my-vpc.id
  cidr_block        = "172.120.4.0/24"
  availability_zone = "us-east-1d"
  tags = {
    Name = "utc-private2-subnet"
  }
}


# nat gateway  
//we have nat gateway so that a private server can reach out to the internet 
// created so that server in the private subnet needs to pull out external resources 
resource "aws_eip" "eip" {


}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public1-subnet.id
  tags = {
    Name = "utc-NAT"
  }

}


#route table for private subnet 

resource "aws_route_table" "rtprivate" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
}


#route table for public subnet 

resource "aws_route_table" "rtpublic" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id


  }

}

#route table assocaiton public 
resource "aws_route_table_association" "rtal1" {
  subnet_id      = aws_subnet.public1-subnet.id
  route_table_id = aws_route_table.rtpublic.id
}

resource "aws_route_table_association" "rtal2" {
  subnet_id      = aws_subnet.public2-subnet.id
  route_table_id = aws_route_table.rtpublic.id
}




#route table association private 

resource "aws_route_table_association" "rta3" {
  subnet_id      = aws_subnet.private1-subnet.id
  route_table_id = aws_route_table.rtprivate.id
}
resource "aws_route_table_association" "rta4" {
  subnet_id      = aws_subnet.private2-subnet.id
  route_table_id = aws_route_table.rtprivate.id
}





