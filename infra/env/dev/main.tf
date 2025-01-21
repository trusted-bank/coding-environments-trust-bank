module "aws-dev" {
  source      = "../../../infra"
  instance    = "t2.micro"
  us-east_aws = "us-east-1"
  key_name    = "key-dev-trust-bank"
  my_ip       = var.my_ip
}

output "instance_private_ip-dev" {
  value = module.aws-dev.instance_private_ip_private_server
}

output "instance_private_ip-web-server-dev" {
  value = module.aws-dev.instance_private_ip_web_server
}

output "instance_public_ip-bastion-dev" {
  value = module.aws-dev.instance_public_ip_bastion
}