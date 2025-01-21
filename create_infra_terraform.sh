#!/bin/bash

get_public_ip() {
local ip=$(curl -s -4 ifconfig.me)
if [[ -z "$ip" ]]; then
echo "Erro ao obter o endereço IP"
exit 1
fi
echo "$ip"
}

run_terraform() {
local env_dir=$1
local my_ip=$2

cd "$env_dir" || exit

terraform init
terraform apply -var="my_ip=${MY_IP}" -auto-approve

if [ $? -ne 0 ]; then
echo "Terraform apply failed"
exit 1
fi
}

setup_ssh_connection() {
local private_key=$1
local bastion_ip=$2
local webserver_ip=$3
local private_server_ip=$4

chmod 400 "$private_key"

echo "Conectando ao servidor web privado via bastion host..."
eval "$(ssh-agent -s)"
ssh-add "$private_key"

echo "Endereço IP do webserver: $webserver_ip"
echo "Endereço IP do private server: $private_server_ip"
echo "Para se conectar ao server web, execute o seguinte comando: ssh admin@${webserver_ip} a partir da máquina bastion host"
echo "Para se conectar ao servidor private server, execute o seguinte comando: ssh admin@${private_server_ip} a partir da máquina bastion host"

local bastion_ssh="ssh -A -t -i ${private_key} admin@${bastion_ip}"
eval "$bastion_ssh"
}

echo "Qual ambiente você quer inicializar ou atualizar?"
echo "1) dev"
echo "2) homol"
echo "3) prod"
read -p "Escolha uma opção (1, 2 ou 3): " ENV_OPTION

case $ENV_OPTION in
1) 
ENV_DIR="$(pwd)/infra/env/dev"
SUFFIX="dev"
;;
2) 
ENV_DIR="$(pwd)/infra/env/homol"
SUFFIX="hml"
;;
3) 
ENV_DIR="$(pwd)/infra/env/prod"
SUFFIX="prod"
;;
*)
echo "Opção inválida. Saindo..."
exit 1
;;
esac

MY_IP=$(get_public_ip)
echo "Seu endereço IP público é: $MY_IP"

run_terraform "$ENV_DIR" "$MY_IP"
echo "Terraform apply completed successfully."

read -p "Digite o caminho completo para sua chave privada: " DIR_PRIVATE_KEY_NAME

cd "$ENV_DIR" || exit

INSTANCE_PUBLIC_IP_BASTION=$(terraform output -raw instance_public_ip-bastion-$SUFFIX)
INSTANCE_PRIVATE_IP_WEBSERVER=$(terraform output -raw instance_private_ip-web-server-$SUFFIX)
INSTANCE_PRIVATE_IP_PRIVATE_SERVER=$(terraform output -raw instance_private_ip-$SUFFIX)

setup_ssh_connection "$DIR_PRIVATE_KEY_NAME" "$INSTANCE_PUBLIC_IP_BASTION" "$INSTANCE_PRIVATE_IP_WEBSERVER" "$INSTANCE_PRIVATE_IP_PRIVATE_SERVER"