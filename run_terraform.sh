#!/bin/bash
export $(egrep -v '^#' .env | xargs)
terraform init
terraform apply
terraform output vm_external_ip # usado para imediatmente mostrar o IP externo da VM criada.