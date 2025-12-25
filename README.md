# 🔧 Realtek 8821AU WiFi Driver – Full Auto Installer (Kali Linux)

This repository provides a **fully automated installation script** for the **Realtek 8821AU WiFi adapter** on **Kali Linux**.

It is designed to **solve DKMS build errors**, **kernel mismatch issues**, and **driver conflicts** commonly faced while installing Realtek drivers manually.

---

## ✅ Supported Chipsets

- RTL8821AU  
- RTL8811AU  
- RTL8812AU (some variants)

---

## 🚀 Features

✔ Fully automated (one-command install)  
✔ DKMS-based (safe across kernel updates)  
✔ Cleans old/broken drivers automatically  
✔ Handles missing kernel headers  
✔ Uses **morrownr’s stable 8821au driver**  
✔ Works with latest Kali rolling kernels  

---

## 🧠 What This Script Does

1. Checks for root permissions  
2. Detects running kernel version  
3. Installs required dependencies  
4. Removes old/conflicting DKMS modules  
5. Clones the official **morrownr 8821au driver repository**  
6. Runs `install-driver.sh` (DKMS based installation)  
7. Loads the `8821au` kernel module  

---

## 📦 Requirements

- Kali Linux (Rolling recommended)
- Working internet connection
- Supported USB WiFi adapter (RTL8821AU chipset)
- Kernel headers available

---

## 🛠 Installation (Step-by-Step)

### Step 1: Clone the Repository
```bash
git clone https://github.com/YOUR_USERNAME/Realtek-8821AU-Kali-Auto-Installer.git

Step 2: Enter the Directory
cd Realtek-8821AU-Kali-Auto-Installer

Step 3: Make Script Executable
chmod +x install_8821au.sh

Step 4: Run the Installer
sudo ./install_8821au.sh


