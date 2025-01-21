module "aws-hml" {
  source      = "../../../infra"
  instance    = "t2.micro"
  us-east_aws = "us-east-1"
  key_name    = "key-hml-trust-bank"
  my_ip       = var.my_ip
}

output "instance_private_ip-hml" {
  value = module.aws-hml.instance_private_ip_private_server
}

output "instance_private_ip-web-server-hml" {
  value = module.aws-hml.instance_private_ip_web_server
}

output "instance_public_ip-bastion-hml" {
  value = module.aws-hml.instance_public_ip_bastion
}