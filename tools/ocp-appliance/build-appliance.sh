#!/bin/bash

cd ansible

ansible-playbook -vv build-image-base.yaml

ansible-playbook -vv build-image-config.yaml

cd ..