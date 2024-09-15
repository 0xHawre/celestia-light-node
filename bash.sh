#!/bin/bash

sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make ncdu -y

cd $HOME
VER="1.22.3"
wget "https://golang.org/dl/go$VER.linux-amd64.tar.gz"
sudo tar -C /usr/local -xzf "go$VER.linux-amd64.tar.gz"
rm "go$VER.linux-amd64.tar.gz"

[ ! -f ~/.bash_profile ] && touch ~/.bash_profile
echo "export PATH=$PATH:/usr/local/go/bin:~/go/bin" >> ~/.bash_profile
source $HOME/.bash_profile

[ ! -d ~/go/bin ] && mkdir -p ~/go/bin

go version

cd $HOME
rm -rf celestia-node
git clone https://github.com/celestiaorg/celestia-node.git
cd celestia-node/
git checkout tags/v0.15.0-rc0
make build
make install
make cel-key


echo "Installation complete!"
celestia version



read -p "Do you already have a cryptocurrency wallet set up? (yes/no): " has_wallet

if [[ "$has_wallet" == "no" || "$has_wallet" == "n" ]]; then
    read -p "Please enter a name for your new wallet key: " key_name
    ./cel-key add $key_name --keyring-backend test --node.type light --p2p.network celestia
elif [[ "$has_wallet" == "yes" || "$has_wallet" == "y" ]]; then
    read -p "Please enter the name for your existing wallet key: " key_name
    ./cel-key add $key_name --recover --keyring-backend test --node.type light --p2p.network celestia
    else echo "reeei"
fi

sudo tee <<EOF >/dev/null /etc/systemd/system/celd.service
[Unit]
Description=celestia-light
After=network-online.target
 
[Service]
User=$USER
ExecStart=$(which celestia) light start --core.ip rpc.celestia.pops.one --p2p.network celestia
Restart=on-failure
RestartSec=3
LimitNOFILE=4096
 
[Install]
WantedBy=multi-user.target
EOF


sudo systemctl daemon-reload
sudo systemctl enable celd
sudo systemctl start celd 

echo "Check service:  sudo systemctl status celd"
echo "Check logs: sudo journalctl -u celd -f  "

