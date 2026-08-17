data "aws_ami" "app_ami" {
 most_recent = true
 filter {
   name   = "name"
   values = ["al2023-ami-*-x86_64"]
 }
 filter {
   name   = "virtualization-type"
   values = ["hvm"]
 }
 owners = ["amazon"]
}
data "aws_vpc" "default" {
 default = true
}

resource "aws_instance" "blog" {
 ami           = data.aws_ami.app_ami.id
 instance_type = var.instance_type
 vpc_security_group_ids = [module.blog_sg.security_group_id]
 
 tags = {
   Name = "Learning Terraform"
 }
}


module "blog_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"
  name = "blog_new"


  vpc_id = data.aws_vpc.default.id

  # ingress rules
  ingress_rules = ["http-80-tcp", "https-443-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  # egress tules
  egress_rules = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]
}