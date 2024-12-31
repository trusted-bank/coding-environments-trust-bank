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
