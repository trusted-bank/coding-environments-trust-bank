module "aws-prod" {
  source      = "../../../infra"
  instance    = "t2.micro"
  us-east_aws = "us-east-1"
  key_name    = "key-prod-trust-bank"
  my_ip       = var.my_ip
}

output "instance_private_ip-prod" {
  value = module.aws-prod.instance_private_ip_private_server
}

output "instance_private_ip-web-server-prod" {
  value = module.aws-prod.instance_private_ip_web_server
}

output "instance_public_ip-bastion-prod" {
  value = module.aws-prod.instance_public_ip_bastion
}
