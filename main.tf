terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.57.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "eu-west-3"
}

# fetch ubuntu ami id for version 22.04
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# iam role
resource "aws_iam_role" "ec2_role" {
  name = "my-ec2-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

# instance profile
resource "aws_iam_instance_profile" "tfe_profile" {
  name = "my-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# fetch the arn of the SecurityComputeAccess policy
data "aws_iam_policy" "SecurityComputeAccess" {
  name = "SecurityComputeAccess"
}

# add the SecurityComputeAccess policy to IAM role connected to your EC2 instance
resource "aws_iam_role_policy_attachment" "SSM" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = data.aws_iam_policy.SecurityComputeAccess.arn
}

resource "aws_instance" "tfe" {
  ami                    = data.aws_ami.ubuntu.image_id
  instance_type          = "t2.micro"
  iam_instance_profile   = aws_iam_instance_profile.tfe_profile.name

  tags = {
    Name = "my-ec2-with-ssm"
  }
}