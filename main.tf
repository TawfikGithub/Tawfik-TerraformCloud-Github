terraform {
  cloud {
    organization = "tawfik-org"

    workspaces {
      name = "terraform-tawfik-getting-started"
    }
  }


  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.22.0"
    }
  }
}

provider "aws" {
    region = "us-east-1"
}

data "template_file" "user_data" {
    template = file("./user_data.sh")
}

resource "aws_s3_bucket" "test-bucket" {
    bucket = "myTF-test-bucket"

    tags = {
      "BucketOwner" = "Tawfik"
      "Env" = "Dev1"
    }
  
}

resource "aws_security_group" "my_TF_SG" {
    name = "TF-Allow_HTTP_SSH"
    description = "Allows HTTP port 80 and SSH port 22"
    vpc_id = "vpc-0284bc0f712592e00"


    ingress = [ {
      cidr_blocks = [ "108.80.136.120/32" ]
      description = "SSH access from my ip"
      from_port = 22
      ipv6_cidr_blocks = [ "::0/0" ]
      prefix_list_ids = [ ]
      protocol = "tcp"
      security_groups = [ ]
      self = false
      to_port = 22
    },
      {cidr_blocks = [ "0.0.0.0/0" ]
      description = "HTTP  access from the world"
      from_port = 80
      ipv6_cidr_blocks = [ "::0/0" ]
      prefix_list_ids = [ ]
      protocol = "tcp"
      security_groups = [ ]
      self = false
      to_port = 80
      }]

    egress = [ {
      cidr_blocks = [ "0.0.0.0/0" ]
      description = "egress to the world"
      from_port = 0
      ipv6_cidr_blocks = [ "::0/0" ]
      prefix_list_ids = [ ]
      protocol = "-1"
      security_groups = [ ]
      self = false
      to_port = 0
    } ]

}


resource "aws_instance" "mylocal-github-tfcloud" {
    ami = "ami-0022f774911c1d690"
    instance_type = "t2.micro"
    security_groups = [aws_security_group.my_TF_SG.name]
    user_data = data.template_file.user_data.rendered
    depends_on = [
      aws_security_group.my_TF_SG
    ]
    

    tags = {
      "Name" = "MyTF-Github-Instance"
    }
  
}



