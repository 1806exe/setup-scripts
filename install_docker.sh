#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Updating the package list..."
sudo apt-get update

echo "Installing prerequisites..."
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

echo "Adding Docker’s official GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

echo "Adding Docker APT repository..."
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

echo "Updating the package list again..."
sudo apt-get update

echo "Installing Docker..."
sudo apt-get install -y docker-ce

echo "Checking Docker version..."
docker --version

echo "Starting Docker service..."
sudo systemctl start docker

echo "Enabling Docker to start on boot..."
sudo systemctl enable docker

echo "Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

echo "Making Docker Compose executable..."
sudo chmod +x /usr/local/bin/docker-compose

echo "Checking Docker Compose version..."
docker-compose --version

echo "Adding the current user to the docker group..."
sudo usermod -aG docker $USER

echo "Changing permissions on the Docker socket..."
sudo chmod 666 /var/run/docker.sock

echo "Docker and Docker Compose installation and setup completed successfully!"
echo "You may need to log out and log back in for the group changes to take effect."
