#!/bin/bash
export $(egrep -v '^#' .env | xargs)
terraform destroy
