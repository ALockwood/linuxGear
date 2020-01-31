#!/bin/bash
set -e

#All this via: https://docs.docker.com/install/linux/docker-ce/ubuntu/
sudo apt update && sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

#Fails if not found thanks to set -e
sudo apt-key fingerprint 0EBFCD88 | grep "9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88"

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt update && sudo apt-get install docker-ce docker-ce-cli containerd.io

sudo docker run hello-world


## PERMISSIONS TO MANAGE AS NON-ROOT
#Create docker group, add current user to it
sudo groupadd docker
sudo usermod -aG docker $USER

#Avoid logout & login to update group membership
newgrp docker

#Test
docker run hello-world

#Set docker to start on boot
sudo systemctl enable docker