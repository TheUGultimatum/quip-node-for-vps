#!/bin/bash

# ASCII Banner
echo "======================================"
echo "      __  .__                         
_/  |_|  |__   ____  __ __  ____  
\   __\  |  \_/ __ \|  |  \/ ___\ 
 |  | |   Y  \  ___/|  |  / /_/  >
 |__| |___|  /\___  >____/\___  / 
           \/     \/     /_____/       "
echo "   QUIP NODE BY THEUGULTIMATUM 🚀"
echo "======================================"
echo ""

# Update system
echo "🔄 Updating system..."
apt update && apt upgrade -y

# Install Docker if not installed
if ! command -v docker &> /dev/null
then
    echo "🐳 Installing Docker..."
    apt install docker.io -y
    systemctl enable docker
    systemctl start docker
else
    echo "✅ Docker already installed"
fi

# Create data directory
echo "📁 Creating data directory..."
mkdir -p ~/quip-data

# User input
echo ""
read -p "👉 Enter your Node Name: " NODENAME
read -p "👉 Enter your Wallet Address (EVM): " WALLET

FULL_NAME="${NODENAME}-${WALLET}"

echo ""
echo "✅ Node Identity: $FULL_NAME"
echo ""

# Remove old container
echo "🧹 Cleaning old container..."
docker rm -f quip-node 2>/dev/null

# Run node
echo "🚀 Starting Quip Node..."
docker run -d --name quip-node \
-p 20049:20049/udp \
-p 20049:20049/tcp \
-v ~/quip-data:/data \
-e QUIP_NODE_NAME=$FULL_NAME \
registry.gitlab.com/quip.network/quip-protocol/quip-network-node-cpu:latest

# Show logs
sleep 3
echo ""
echo "📊 Node Logs (CTRL+C to exit):"
docker logs -f quip-node
