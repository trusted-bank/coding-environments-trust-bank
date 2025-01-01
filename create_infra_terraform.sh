#!/bin/bash

read -p "Digite o nome da sua chave AWS: " KEY_NAME

MY_IP=$(curl -s -4 ifconfig.me)
if [[ -z "$MY_IP" ]]; then
    echo "Erro ao obter o endereço IP."
    exit 1
fi
echo "Seu endereço IP público é: $MY_IP"

terraform init
terraform apply -var="key_name=${KEY_NAME}" -var="my_ip=${MY_IP}" -auto-approve

if [ $? -eq 0 ]; then
echo "Terraform apply completed successfully."

read -p "Digite o caminho completo para sua chave privada: " DIR_PRIVATE_KEY_NAME

chmod 400 "${DIR_PRIVATE_KEY_NAME}"

INSTANCE_PUBLIC_IP=$(terraform output -raw instance_public_ip)
INSTANCE_PRIVATE_IP=$(terraform output -raw instance_private_ip)

eval "$(ssh-agent -s)"
ssh-add "${DIR_PRIVATE_KEY_NAME}"

BASTION_SSH_CONNECTION_STRING="ssh -A -t -i ${DIR_PRIVATE_KEY_NAME} admin@${INSTANCE_PUBLIC_IP}"
PRIVATE_SSH_CONNECTION_STRING="ssh admin@${INSTANCE_PRIVATE_IP}"
eval "${BASTION_SSH_CONNECTION_STRING}" "${PRIVATE_SSH_CONNECTION_STRING}"
else
echo "Terraform apply failed"
exit 1
fi