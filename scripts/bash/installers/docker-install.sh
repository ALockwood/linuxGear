#!/bin/bash
set -e
# NOTE: Installs Docker Engine, not Docker Desktop
# Source: https://docs.docker.com/engine/install/ubuntu/

# Cleanup
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
sudo apt-get autoremove

# Add Docker's official GPG key:
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install Docker packages (latest)
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

## PERMISSIONS TO MANAGE AS NON-ROOT
#Create docker group if not already done, add current user to it
if [ $(getent group docker) ]; then
  echo "docker group exists"
else
   sudo groupadd docker
fi

#Add current user to docker group
sudo usermod -aG docker $USER

#Avoid logout & login to update group membership
newgrp docker

#Test
docker run hello-world

#Set docker to start on boot
sudo systemctl enable docker