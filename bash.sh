#!/bin/bash


sudo apt update && sudo apt upgrade -y
echo "Installing Docker on Ubuntu..."

    # Update existing list of packages
    sudo apt update

    # Install required packages
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

    # Add Docker's official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    # Add Docker repository
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

    # Update the package database
    sudo apt update

    # Install Docker
    sudo apt install -y docker-ce

    # Start Docker and enable it to start at boot
    sudo systemctl start docker
    sudo systemctl enable docker

    echo "Docker installation complete! Verifying installation..."
    sudo docker run hello-world

sudo apt update && sudo apt upgrade -y
export NETWORK=celestia
export NODE_TYPE=light
export RPC_URL=rpc.celestia.pops.one

docker run -e NODE_TYPE=$NODE_TYPE -e P2P_NETWORK=$NETWORK \
    ghcr.io/celestiaorg/celestia-node:v0.16.0 \
    celestia $NODE_TYPE start --core.ip $RPC_URL --p2p.network $NETWORK


