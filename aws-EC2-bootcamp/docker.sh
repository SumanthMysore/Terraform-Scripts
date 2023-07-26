#!/bin/bash

sudo apt-get update

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" -y

sudo apt-get update

apt-cache policy docker-ce

sudo apt-get install -y docker-ce

sudo apt install docker-compose -y

sudo service docker start

sudo usermod -aG docker $USER

exit 