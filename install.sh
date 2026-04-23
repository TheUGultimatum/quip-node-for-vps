#!/bin/bash

clear

# ASCII Banner
echo " __  .__                         "
echo "_/  |_|  |__   ____  __ __  ____ "
echo "\   __\  |  \_/ __ \|  |  \/ ___\\"
echo " |  | |   Y  \  ___/|  |  / /_/  >"
echo " |__| |___|  /\___  >____/\___  / "
echo "           \/     \/     /_____/  "
echo ""
echo "🚀 QUIP NODE BY THEUGULTIMATUM"
echo "======================================"
echo ""

# --- Root check ---
if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run as root: sudo bash install.sh"
  exit 1
fi

# --- OS check ---
if ! command -v apt &> /dev/null; then
  echo "❌ Only Ubuntu/Debian supported"
  exit 1
fi

# --- Update system ---
echo "🔄 Updating system..."
apt update -y && apt upgrade -y

# --- Install dependencies ---
echo "📦 Installing dependencies..."
apt install -y curl wget ca-certificates

# --- Docker check/install ---
if command -v docker &> /dev/null; then
    echo "✅ Docker already installed"
    if ! systemctl is-active --quiet docker; then
        echo "⚠️ Starting Docker..."
        systemctl start docker
        systemctl enable docker
    fi
else
    echo "🐳 Installing Docker..."
    apt install -y docker.io
    systemctl enable docker
    systemctl start docker

    if ! command -v docker &> /dev/null; then
        echo "❌ Docker install failed"
        exit 1
    fi
fi

# --- Firewall setup BEFORE node ---
if command -v ufw &> /dev/null; then
    echo "🔓 Configuring firewall..."
    ufw allow 20049/tcp
    ufw allow 20049/udp
    ufw reload
else
    echo "ℹ️ UFW not found, skipping firewall"
fi

# --- Directory setup ---
echo "📁 Creating data directory..."
mkdir -p ~/quip-data

# --- User input ---
echo ""
read -p "👉 Enter your Node Name: " NODENAME
read -p "👉 Enter your Wallet Address (EVM): " WALLET

if [ -z "$NODENAME" ] || [ -z "$WALLET" ]; then
    echo "❌ Node name or wallet cannot be empty"
    exit 1
fi

FULL_NAME="${NODENAME}-${WALLET}"

echo ""
echo "✅ Node Identity: $FULL_NAME"
echo ""

# --- Remove old container ---
if docker ps -a --format '{{.Names}}' | grep -Eq "^quip-node$"; then
    echo "🧹 Removing old container..."
    docker rm -f quip-node
fi

# --- Pull latest image ---
echo "📥 Pulling latest image..."
docker pull registry.gitlab.com/quip.network/quip-protocol/quip-network-node-cpu:latest

if [ $? -ne 0 ]; then
    echo "❌ Image pull failed"
    exit 1
fi

# --- Run node ---
echo "🚀 Starting node..."

docker run -d --name quip-node \
-p 20049:20049/udp \
-p 20049:20049/tcp \
-v ~/quip-data:/data \
-e QUIP_NODE_NAME=$FULL_NAME \
--restart unless-stopped \
registry.gitlab.com/quip.network/quip-protocol/quip-network-node-cpu:latest

if [ $? -ne 0 ]; then
    echo "❌ Failed to start node"
    exit 1
fi

# --- Show logs ---
sleep 3
echo ""
echo "📊 Node Logs (CTRL+C to exit):"
docker logs -f quip-node
