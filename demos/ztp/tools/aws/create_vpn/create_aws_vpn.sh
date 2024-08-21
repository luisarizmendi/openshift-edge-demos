#!/bin/bash

pip install boto boto3 botocore
ansible-galaxy collection install community.aws


echo "localhost ansible_python_interpreter=$(which python)  ansible_connection=local ansible_ssh_common_args='-o StrictHostKeyChecking=no'" > ansible/inventory


ansible-playbook -i ansible/inventory -vv ansible/create_aws_vpn.yaml

echo ""
echo "Download the config file AWS"
echo ""

#ansible-playbook -i ansible/inventory -e vpn_config_file=~/Downloads/vpn-aws.txt -vv ansible/translate_generic_to_libreswan.yaml