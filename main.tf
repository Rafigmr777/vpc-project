

resource "aws_vpc" "project-vpc" {
    cidr_block = var.cidr
  
}

resource "aws_subnet" "subnet1" {
    vpc_id = aws_vpc.project-vpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true

    tags = {
        Name = "subnet1"
    }
  
}

resource "aws_subnet" "subnet2" {
    vpc_id = aws_vpc.project-vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true

    tags = {
      Name = "Subnet2"
    }
  
}
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.project-vpc.id

    tags = {
      Name = "internet-gateway"
    }
  
}

resource "aws_route_table" "rt-table" {
    vpc_id = aws_vpc.project-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
  
}

resource "aws_route_table_association" "rta1" {
    subnet_id = aws_subnet.subnet1.id
    route_table_id = aws_route_table.rt-table.id
}

resource "aws_route_table_association" "rta2" {
    subnet_id = aws_subnet.subnet2.id
    route_table_id = aws_route_table.rt-table.id
  
}

resource "aws_security_group" "sg1" {
    name = "web"
    description = "Allow TLS inbound traffic and all outbound traffic"
    vpc_id = aws_vpc.project-vpc.id

    ingress  {
        description = "Allow http"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress  {
        description = " Allow ssh"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]


    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]

    }
    tags = {
    Name = "Web-sg"
  }
}

resource "aws_s3_bucket" "web-bucket" {
    bucket = "rafigmrbucket1503202519471998"
  
}

resource "aws_instance" "web1" {
    ami = "ami-04b4f1a9cf54c11d0"
    instance_type = "t2.micro"
    vpc_security_group_ids = [ aws_security_group.sg1.id ]
    subnet_id = aws_subnet.subnet1.id
    user_data              = base64encode(file("userdata.sh"))
  
}


resource "aws_instance" "web2" {
    ami = "ami-04b4f1a9cf54c11d0"
    instance_type = "t2.micro"
    vpc_security_group_ids = [ aws_security_group.sg1.id ]
    subnet_id = aws_subnet.subnet2.id
    user_data = base64encode(file("userdata1.sh"))
  
}


resource "aws_lb" "myalb" {
    name = "myalb"
    internal = false
    load_balancer_type = "application"

    security_groups = [ aws_security_group.sg1.id ]
    subnets = [aws_subnet.subnet1.id,aws_subnet.subnet2.id]

    tags = {
      name = "application load balance"
    }
  
}

resource "aws_lb_target_group" "tg1" {

    name = "my-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.project-vpc.id

    health_check {
    path = "/"
    port = "traffic-port"
  }
  
}

resource "aws_lb_target_group_attachment" "attach1" {
    target_group_arn = aws_lb_target_group.tg1.arn
    target_id = aws_instance.web1.id
    port = 80
}

resource "aws_lb_target_group_attachment" "attach2" {
    target_group_arn = aws_lb_target_group.tg1.arn
    target_id = aws_instance.web2.id
    port = 80
}

resource "aws_lb_listener" "mylistener" {
    load_balancer_arn = aws_lb.myalb.arn
    port = 80
    protocol = "HTTP"
    default_action {
        target_group_arn = aws_lb_target_group.tg1.arn
        type = "forward"
      
    }
  
}


output "loadbalancerdns" {
  value = aws_lb.myalb.dns_name

}