#!/bin/bash

CONFIG_PATH="$(pwd)/sushy-tools/sushy-emulator.conf"

container_exists=$(podman ps -a --format "{{.Names}}" | grep -w sushy-tools)

if [ "$container_exists" ]; then
  echo "sushy-tools container exists."
  
  container_running=$(podman ps --format "{{.Names}}" | grep -w sushy-tools)
  if [ "$container_running" ]; then
    echo "sushy-tools container is already running."
  else
    echo "Starting the sushy-tools container..."
    sudo podman start sushy-tools
  fi
else
  echo "sushy-tools container does not exist. Creating and running it..."
  sudo podman run -d --privileged --rm --name sushy-tools \
    -v "$CONFIG_PATH:/etc/sushy/sushy-emulator.conf:Z" \
    -v /var/run/libvirt:/var/run/libvirt:Z \
    -e SUSHY_EMULATOR_CONFIG=/etc/sushy/sushy-emulator.conf \
    -p 8000:8000 \
    quay.io/metal3-io/sushy-tools:latest sushy-emulator
fi


sudo firewall-cmd --add-port=8000/tcp 
sudo firewall-cmd --add-port=8000/tcp --zone libvirt 



