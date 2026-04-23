# 🚀 Quip Node VPS Auto Installer

**by TheUGultimatum**

Run a Quip node on your VPS in **one command** — fully automated setup (Docker + Node + Logs).

---

## ⚡ One-Line Installation

```bash
curl -O https://raw.githubusercontent.com/TheUGultimatum/quip-node-for-vps/main/install.sh
chmod +x install.sh
sudo ./install.sh
```

---

## 🧠 What This Script Does

* ✅ Updates your VPS
* 🐳 Installs Docker (if not installed)
* 🔓 Opens required ports (TCP/UDP 20049)
* 📁 Creates node data directory
* 👤 Prompts for:

  * Node Name
  * Wallet Address (EVM)
* 🚀 Runs Quip node
* 📊 Shows live logs

---

## 📌 Requirements

## ✅ Recommended Setup

Best performance and stability:

- VPS (Ubuntu 22.04 / 24.04)
- Minimum:
  - 4 CPU
  - 8GB RAM
- Open port: 20049 (TCP + UDP)

⚠️ Avoid:
- Mobile hotspot
- CGNAT networks
- WSL without Docker Desktop

---

## 🖥️ Example Setup

```text
Node Name: theug
Wallet: 0xabc123...
```

👉 Final Node Identity:

```text
theug-0xabc123...
```

---

## 🔍 Check Node Status

```bash
docker ps
```

👉 If you see `quip-node` running → ✅ Success

---

## 📊 View Logs Anytime

```bash
docker logs -f quip-node
```

---

## 🔁 Restart Node

```bash
docker restart quip-node
```

---

## 🛑 Stop Node

```bash
docker stop quip-node
```

---

## ❌ Remove Node

```bash
docker rm -f quip-node
rm -rf ~/quip-data
```

---

## 🧹 Full Cleanup (Optional)

```bash
curl -fsSL https://raw.githubusercontent.com/TheUGultimatum/quip-node-for-vps/main/cleanup.sh | sudo bash
```

---

## ⚠️ Notes

* This is a **testnet project** → network may be unstable
* Keep VPS running 24/7 for best results
* Do NOT delete `quip-data` unless resetting node
* Rewards are not guaranteed (early stage)

---

## 🔥 Features

* Beginner-friendly 💡
* Fully automated ⚙️
* Error-handled script 🛡️
* One-command install 🚀

---

## 💬 Support

If you face issues:

* Check logs first
* Ensure ports are open
* Re-run script if needed

---

## ⭐ Credits

Built with ❤️ by **TheUGultimatum**

---

## 🚀 Done

Your Quip node is now running — welcome to the network 🔥
