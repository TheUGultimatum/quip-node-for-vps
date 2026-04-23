#!/bin/bash

clear

echo "======================================"
echo "   QUIP NODE FULL CLEANUP SCRIPT 🧹"
echo "======================================"
echo ""

# --- Root check ---
if [ "$EUID" -ne 0 ]; then
  echo "❌ Run as root: sudo bash cleanup.sh"
  exit 1
fi

echo "🧹 Removing Quip node container..."
docker rm -f quip-node 2>/dev/null

echo "📁 Removing Quip data..."
rm -rf ~/quip-data

echo "🧼 Cleaning Docker containers..."
docker container prune -f 2>/dev/null

echo "🧼 Cleaning Docker images..."
docker image prune -a -f 2>/dev/null

echo "🧼 Cleaning Docker volumes..."
docker volume prune -f 2>/dev/null

echo "🗑️ Removing Docker completely..."
apt purge -y docker.io

echo "🧹 Removing unused packages..."
apt autoremove -y

echo "🧹 Removing Docker leftover files..."
rm -rf /var/lib/docker
rm -rf /etc/docker

echo ""
echo "======================================"
echo "✅ CLEANUP COMPLETE"
echo "======================================"
echo ""
echo "Your VPS is now fresh 🚀"
