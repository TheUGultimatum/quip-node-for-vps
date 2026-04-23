#!/bin/bash

clear

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

# --- Detect WSL ---
if grep -qi microsoft /proc/version; then
  echo "⚠️ Running inside WSL"
fi

# --- Root check ---
if [ "$EUID" -ne 0 ]; then
  echo "❌ Run as root: sudo bash"
  exit 1
fi

# --- Update ---
apt update -y && apt upgrade -y

# --- Install deps ---
apt install -y curl wget ca-certificates

# --- Install Docker if missing ---
if ! command -v docker &> /dev/null; then
  echo "🐳 Installing Docker..."
  apt install -y docker.io
fi

# --- Docker (WSL safe) ---
if command -v systemctl &> /dev/null; then
  systemctl start docker 2>/dev/null || true
  systemctl enable docker 2>/dev/null || true
fi

# --- INPUT FIX ---
echo ""
echo "👉 Enter details (or pass via env)"

if [ -z "$NODE_NAME" ]; then
  read -p "Node Name: " NODE_NAME
fi

if [ -z "$WALLET_ADDRESS" ]; then
  read -p "Wallet Address: " WALLET_ADDRESS
fi

# --- VALIDATION ---
if [ -z "$NODE_NAME" ] || [ -z "$WALLET_ADDRESS" ]; then
  echo "❌ Missing input!"
  echo "👉 Use this instead:"
  echo ""
  echo "NODE_NAME=yourname WALLET_ADDRESS=0xyourwallet bash install.sh"
  exit 1
fi

FULL_NAME="${NODE_NAME}-${WALLET_ADDRESS}"

echo "✅ Node Identity: $FULL_NAME"

# --- Setup dir ---
mkdir -p ~/quip-data

# --- Remove old ---
docker rm -f quip-node 2>/dev/null

# --- Pull ---
docker pull registry.gitlab.com/quip.network/quip-protocol/quip-network-node-cpu:latest

# --- Run ---
docker run -d --name quip-node \
-p 20049:20049/udp \
-p 20049:20049/tcp \
-v ~/quip-data:/data \
-e QUIP_NODE_NAME=$FULL_NAME \
--restart unless-stopped \
registry.gitlab.com/quip.network/quip-protocol/quip-network-node-cpu:latest

echo ""
echo "✅ Node started!"
echo "📊 Logs:"
docker logs -f quip-node
