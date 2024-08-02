#!/bin/bash

cd ansible

ansible-playbook -vv build-image.yaml

ansible-playbook -vv build-config-iso.yaml

cd ..