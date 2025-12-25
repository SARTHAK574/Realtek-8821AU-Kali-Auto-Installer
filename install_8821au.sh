#!/bin/bash
# Full auto installer for Realtek 8821AU WiFi driver on Kali Linux
# - Installs dependencies
# - Cleans old DKMS entries
# - Clones morrownr 8821au repo
# - Runs its install-driver.sh (DKMS based)
# Chipsets: rtl8821au (and some 8811/8812 variants)

set -e

echo "=================================================="
echo "  Realtek 8821AU WiFi Driver FULL Auto-Installer"
echo "                  (Kali Linux)"
echo "=================================================="
echo

# ---- Root check ----
if [ "$EUID" -ne 0 ]; then
  echo "[!] Please run as root:"
  echo "    sudo $0"
  exit 1
fi

# ---- Show kernel version ----
KVER="$(uname -r)"
echo "[*] Current kernel: $KVER"
echo

# ---- Update & install dependencies ----
echo "[*] Updating package list..."
apt update -y

echo "[*] Installing required packages (git, dkms, build-essential, bc, headers)..."
if ! apt install -y git dkms build-essential bc linux-headers-"$KVER"; then
  echo
  echo "[!] Some packages (probably linux-headers-$KVER) could not be installed."
  echo "    - Run:  apt update && apt full-upgrade"
  echo "    - Reboot"
  echo "    - Then run this script again."
  exit 1
fi

# ---- Clean old drivers (common names) ----
echo
echo "[*] Cleaning any old rtl8812au/rtl8821au DKMS modules (if present)..."
dkms remove rtl8812au/5.6.4.2 --all 2>/dev/null || true
dkms remove 8821au/1.0 --all 2>/dev/null || true
dkms remove rtl8821au/5.12.5.2 --all 2>/dev/null || true

# Also clean old dkms dirs if they exist
rm -rf /var/lib/dkms/rtl8812au 2>/dev/null || true
rm -rf /var/lib/dkms/rtl8821au 2>/dev/null || true
rm -rf /var/lib/dkms/8821au* 2>/dev/null || true

# ---- Working directory & repo info ----
WORKDIR="/usr/src/8821au-installer"
REPO_URL="https://github.com/morrownr/8821au-20210708.git"
REPO_DIR="$WORKDIR/8821au-20210708"

echo
echo "[*] Using work directory: $WORKDIR"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

# ---- Remove old clone ----
if [ -d "$REPO_DIR" ]; then
  echo "[*] Old repo found, removing..."
  rm -rf "$REPO_DIR"
fi

# ---- Clone repo ----
echo "[*] Cloning driver repository from:"
echo "    $REPO_URL"
git clone "$REPO_URL"

if [ ! -d "$REPO_DIR" ]; then
  echo "[!] Failed to clone repository. Check your internet connection."
  exit 1
fi

cd "$REPO_DIR"

# ---- Remove previous install via repo script (if any) ----
if [ -f "./remove-driver.sh" ]; then
  echo "[*] Removing any previous install via remove-driver.sh..."
  bash ./remove-driver.sh || true
fi

# ---- Main install via repo script ----
if [ -f "./install-driver.sh" ]; then
  echo "[*] Running install-driver.sh (this sets up DKMS automatically)..."
  bash ./install-driver.sh
else
  echo "[!] install-driver.sh not found in repo. Falling back to manual make install..."
  make
  make install
fi

echo
echo "[*] Trying to load 8821au module..."
modprobe 8821au 2>/dev/null || true

echo
echo "=================================================="
echo " [+] Installation finished!"
echo "=================================================="
echo "[*] Check if driver is loaded:"
echo "      lsmod | grep 8821au"
echo
echo "[*] Check wireless interfaces:"
echo "      iwconfig"
echo
echo "[*] If WiFi not visible yet, reboot your system once and try again."
echo

