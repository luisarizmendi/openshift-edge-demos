#!/bin/bash

#pip install boto boto3 botocore
ansible-galaxy collection install amazon.aws
ansible-galaxy collection install community.aws

ansible-playbook -i ansible/inventory ansible/create_aws_vpn.yaml

ansible-playbook  ansible/translate_generic_to_libreswan.yaml