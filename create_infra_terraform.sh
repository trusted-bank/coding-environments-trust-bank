#!/bin/bash

IP=$(curl -s -4 ifconfig.me)
echo "Seu endereço IP público é: $IP"
terraform init
terraform apply -var="my_ip=${IP}" -auto-approve