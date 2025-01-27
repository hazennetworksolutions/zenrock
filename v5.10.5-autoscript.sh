#!/bin/bash
LOG_FILE="/var/log/zenrock_node_install.log"
exec > >(tee -a "$LOG_FILE") 2>&1

printGreen() {
    echo -e "\033[32m$1\033[0m"
}

printLine() {
    echo "------------------------------"
}

# Function to print the node logo
function printNodeLogo {
    echo -e "\033[32m"
    echo "          
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
██████████████████████████████████████████████        ██████████████████████████████████████████████
███████████████████████████████████████████              ███████████████████████████████████████████
████████████████████████████████████████                    ████████████████████████████████████████
█████████████████████████████████████                          █████████████████████████████████████
█████████████████████████████████                                  █████████████████████████████████
██████████████████████████████             █             █            ██████████████████████████████
████████████████████████████           █████             ████           ████████████████████████████
████████████████████████████          ██████             ██████         ████████████████████████████
████████████████████████████          ██████             ██████          ███████████████████████████
████████████████████████████          ███████            ██████          ███████████████████████████
████████████████████████████          ██████████         ██████          ███████████████████████████
████████████████████████████          █████████████      ██████          ███████████████████████████
████████████████████████████             █████████████     ████          ███████████████████████████
████████████████████████████          █     █████████████     █          ███████████████████████████
████████████████████████████          █████     ████████████             ███████████████████████████
████████████████████████████          ██████       ████████████          ███████████████████████████
████████████████████████████          ██████          █████████          ███████████████████████████
████████████████████████████          ██████             ██████          ███████████████████████████
████████████████████████████          ██████             ██████          ███████████████████████████
████████████████████████████          ██████             ██████         ████████████████████████████
████████████████████████████            ████             ███            ████████████████████████████
██████████████████████████████                                        ██████████████████████████████
█████████████████████████████████                                  █████████████████████████████████
█████████████████████████████████████                           ████████████████████████████████████
████████████████████████████████████████                    ████████████████████████████████████████
███████████████████████████████████████████              ███████████████████████████████████████████
██████████████████████████████████████████████        ██████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
████████████████████████████████████████████████████████████████████████████████████████████████████
Hazen Network Solutions 2025 All rights reserved."
    echo -e "\033[0m"
}

# Show the node logo
printNodeLogo

# User confirmation to proceed
echo -n "Type 'yes' to start the installation Zenrock v5.10.5 and press Enter: "
read user_input

if [[ "$user_input" != "yes" ]]; then
  echo "Installation cancelled."
  exit 1
fi

# Function to print in green
printGreen() {
  echo -e "\033[32m$1\033[0m"
}

printGreen "Starting installation..."
sleep 1

printGreen "If there are any, clean up the previous installation files"

sudo systemctl stop zenrockd
sudo systemctl disable zenrockd
sudo rm -rf /etc/systemd/system/zenrockd.service
sudo rm $(which zenrockd)
sudo rm -rf $HOME/.zrchain
sudo rm -rf $HOME/.zenrock-validators
sed -i "/zenrockd_/d" $HOME/.bash_profile

# Update packages and install dependencies
printGreen "1. Updating and installing dependencies..."
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install curl git wget htop tmux build-essential jq make lz4 gcc unzip -y

# User inputs
read -p "Enter your MONIKER: " MONIKER
echo 'export MONIKER='$MONIKER
read -p "Enter your PORT (2-digit): " PORT
echo 'export PORT='$PORT

# Setting environment variables
echo "export MONIKER=$MONIKER" >> $HOME/.bash_profile
echo "export ZENROCK_CHAIN_ID=\"gardia-3\"" >> $HOME/.bash_profile
echo "export ZENROCK_PORT=$PORT" >> $HOME/.bash_profile
source $HOME/.bash_profile

printLine
echo -e "Moniker:        \e[1m\e[32m$MONIKER\e[0m"
echo -e "Chain ID:       \e[1m\e[32m$ZENROCK_CHAIN_ID\e[0m"
echo -e "Node custom port:  \e[1m\e[32m$ZENROCK_PORT\e[0m"
printLine
sleep 1

# Install Go
printGreen "2. Installing Go..." && sleep 1
cd $HOME
VER="1.23.1"
wget "https://golang.org/dl/go$VER.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$VER.linux-amd64.tar.gz"
rm "go$VER.linux-amd64.tar.gz"
[ ! -f ~/.bash_profile ] && touch ~/.bash_profile
echo "export PATH=$PATH:/usr/local/go/bin:~/go/bin" >> ~/.bash_profile
source $HOME/.bash_profile
[ ! -d ~/go/bin ] && mkdir -p ~/go/bin

# Version check
echo $(go version) && sleep 1

# Download Prysm protocol binary
printGreen "3. Downloading Zenrock binary and setting up..." && sleep 1
cd $HOME
mkdir -p $HOME/.zrchain/cosmovisor/upgrades/v5rev4/bin
wget -O zenrockd.zip https://github.com/Zenrock-Foundation/zrchain/releases/download/v5.10.5/zenrockd.zip
unzip zenrockd.zip
rm zenrockd.zip
chmod +x $HOME/zenrockd
mv $HOME/zenrockd $HOME/.zrchain/cosmovisor/upgrades/v5rev4/bin/

sudo ln -sfn $HOME/.zrchain/cosmovisor/upgrades/v5rev4 $HOME/.zrchain/cosmovisor/current
sudo ln -sfn $HOME/.zrchain/cosmovisor/current/bin/zenrockd /usr/local/bin/zenrockd

go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.6.0

# Create service file
sudo tee /etc/systemd/system/zenrockd.service > /dev/null << EOF
[Unit]
Description=zenrock node service
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.zrchain"
Environment="DAEMON_NAME=zenrockd"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.zrchain/cosmovisor/current/bin"

[Install]
WantedBy=multi-user.target
EOF



# Enable the service
sudo systemctl daemon-reload
sudo systemctl enable zenrockd
# Initialize the node
printGreen "7. Initializing the node..."
zenrockd init moniker-name --chain-id gardia-3
zenrockd config set client chain-id gardia-3
zenrockd config set client node tcp://localhost:${ZENROCK_PORT}657
sed -i -e '/^keyring-backend = /c\keyring-backend = "test"' $HOME/.zrchain/config/client.toml

# Download genesis and addrbook files
printGreen "8. Downloading genesis and addrbook..."
wget -O $HOME/.zrchain/config/genesis.json https://raw.githubusercontent.com/hazennetworksolutions/zenrock/refs/heads/main/genesis.json
wget -O $HOME/.zrchain/config/addrbook.json  https://raw.githubusercontent.com/hazennetworksolutions/zenrock/refs/heads/main/addrbook.json

rm -rf $HOME/.zrchain/config/app.toml
wget https://raw.githubusercontent.com/zenrocklabs/zenrock-validators/refs/heads/master/scaffold_setup/configs_testnet/app.toml -O $HOME/.zrchain/config/app.toml

rm -rf /root/.zrchain/config/config.toml
wget https://raw.githubusercontent.com/zenrocklabs/zenrock-validators/refs/heads/master/scaffold_setup/configs_testnet/config.toml -O $HOME/.zrchain/config/config.toml


sed -i "s/^moniker = .*/moniker = \"$MONIKER\"/" $HOME/.zrchain/config/config.toml


# Configure gas prices and ports
printGreen "9. Configuring custom ports and gas prices..." && sleep 1
sed -i 's|minimum-gas-prices =.*|minimum-gas-prices = "0urock"|g' $HOME/.zrchain/config/app.toml
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.zrchain/config/config.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.zrchain/config/config.toml

sed -i.bak -e "s%:1317%:${ZENROCK_PORT}317%g;
s%:8080%:${ZENROCK_PORT}080%g;
s%:9090%:${ZENROCK_PORT}090%g;
s%:9091%:${ZENROCK_PORT}091%g;
s%:8545%:${ZENROCK_PORT}545%g;
s%:8546%:${ZENROCK_PORT}546%g;
s%:6065%:${ZENROCK_PORT}065%g" $HOME/.zrchain/config/app.toml
# Configure P2P and ports
sed -i.bak -e "s%:26658%:${ZENROCK_PORT}658%g;
s%:26657%:${ZENROCK_PORT}657%g;
s%:6060%:${ZENROCK_PORT}060%g;
s%:26656%:${ZENROCK_PORT}656%g;
s%^external_address = \"\"%external_address = \"$(wget -qO- eth0.me):${ZENROCK_PORT}656\"%;
s%:26660%:${ZENROCK_PORT}660%g" $HOME/.zrchain/config/config.toml
# Set up seeds and peers
printGreen "10. Setting up peers and seeds..." && sleep 1
SEEDS="50ef4dd630025029dde4c8e709878343ba8a27fa@zenrock-testnet-seed.itrocket.net:56656"
PEERS="5458b7a316ab673afc34404e2625f73f0376d9e4@zenrock-testnet-peer.itrocket.net:11656,679e513d8f9734018d6019da66c54e19971ff1c3@65.109.22.211:26656,3e5fd53090ba6a9bfe178efeb8ca498b8070bcec@65.21.196.57:51656,38294f5212c42105eb6679eca9d8b432238ed2a1@65.109.80.26:26656,a412c87699b151a02d1385cbb68b6df396a81c3f@95.217.196.224:26656,fa8356510c907e62eed3c34e13ff26117e4fae6f@65.109.88.19:10056,ec21ec311953092fc6a4ce963c36ca9f46b756f5@65.109.112.148:26656,12f0463250bf004107195ff2c885be9b480e70e2@52.30.152.47:26656,07c672979d9f48ee9fcc53bfa4c2a84a180a059f@5.9.80.109:12656,8526d15efd1d3de6d46fba7748b62f3cb7ad4a8b@178.63.50.45:26656,2d3f2fd281d46fd280efda945f49d60baf9bffdb@195.201.206.154:26656,c3dd7a54afaf18c65cf9f10d48a2c615385936cb@109.199.109.133:56656,ee7d09ac08dc61548d0e744b23e57436b8c477fc@65.109.93.152:26906,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@213.239.207.162:18256,b5061f74f97208f878915d340f5d121481a1dc5c@149.50.116.81:57656,bf0e85ca3116919d4ddea3c52d3f71589251b211@[2a03:cfc0:8000:13::b910:27be]:14156,f00dcfe99d4853522bce067ab691a1269b8e7fcb@149.50.96.91:59656,8c0258cc19b5afc0879069a8250f36285d17f04e@149.50.96.58:61656,edb6f795aa39c3edefde96760ad87a2c108ab466@86.48.31.201:26656,6ef43e8d5be8d0499b6c57eb15d3dd6dee809c1e@34.246.15.243:26656,c2c5db24bb7aeb665cbf04c298ca53578043ceed@23.88.0.170:15671,491b015df1bbd409b3c8f9db7e34da66d6e09015@178.63.40.176:59656,cc0b7cd12a5b3b444af41d1c33f1fc0eda22fe79@89.208.6.139:26656,efeed048b1c1532fac09c8a7deed4463399e06f9@185.16.39.74:22656,a746910fab628e98402ca4ebecd4036cf02a2851@51.83.237.195:29556,e1ff342fb55293384a5e92d4bd3bed82ecee4a60@65.108.234.158:26356,c13c25929626d1410a57142ccc5bbf00589666fc@65.108.44.149:14656,2cb359d2dd2b40cea72612f226f9123bdaca6c98@109.199.97.58:35656,63014f89cf325d3dc12cc8075c07b5f4ee666d64@52.30.152.47:26656,b77eb04d0894d186281943ff6e576ae17acff7ca@213.239.198.181:19656,1dfbd854bab6ca95be652e8db078ab7a069eae6f@54.74.239.68:26656,ff03ca4bcb482e47d89cca7801af0cdcf2d67361@38.242.213.209:56656,a98484ac9cb8235bd6a65cdf7648107e3d14dab4@95.217.74.22:18256"
sed -i -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*seeds *=.*/seeds = \"$SEEDS\"/}" \
       -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*persistent_peers *=.*/persistent_peers = \"$PEERS\"/}" $HOME/.zrchain/config/config.toml

# Pruning Settings
sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.zrchain/config/app.toml 
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.zrchain/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"19\"/" $HOME/.zrchain/config/app.toml

# Download the snapshot
# printGreen "12. Downloading snapshot and starting node..." && sleep 1





# Start the node
printGreen "13. Starting the node..."
sudo systemctl start zenrockd

# Check node status
printGreen "14. Checking node status..."
sudo journalctl -u zenrockd -f -o cat

# Verify if the node is running
if systemctl is-active --quiet zenrockd; then
  echo "The node is running successfully! Logs can be found at /var/log/zenrock_node_install.log"
else
  echo "The node failed to start. Logs can be found at /var/log/zenrock_node_install.log"
fi
