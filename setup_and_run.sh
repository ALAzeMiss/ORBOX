#!/usr/bin/env bash
set -e

echo "=== Détection de la plateforme ==="
PLATFORM=$(uname -m)
OS_NAME=$(uname -s)
IS_RPI=false

if [ -f /proc/cpuinfo ]; then
    if grep -q "BCM" /proc/cpuinfo; then
        IS_RPI=true
    fi
fi

echo "OS: $OS_NAME, Architecture: $PLATFORM, Raspberry Pi: $IS_RPI"

# ------------------------------
# Mettre à jour les paquets
# ------------------------------
echo "=== Mise à jour des paquets ==="
sudo apt update
sudo apt upgrade -y

# ------------------------------
# Installer les dépendances
# ------------------------------
echo "=== Installation des dépendances système ==="

# Dépendances communes
sudo apt install -y build-essential git cmake pkg-config libgtk2.0-dev \
    libavcodec-dev libavformat-dev libswscale-dev espeak-ng curl

# OpenCV
sudo apt install -y libopencv-dev

# Node.js 18 LTS
if ! command -v node &> /dev/null || [ "$(node -v | cut -d. -f1)" -lt 18 ]; then
    echo "Installation de Node.js 18 LTS"
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt install -y nodejs
fi

echo "Node version: $(node -v)"
echo "NPM version:  $(npm -v)"

# GPIO pour Raspberry Pi
if [ "$IS_RPI" = true ]; then
    echo "=== Installation pigpio pour Raspberry Pi ==="
    if ! dpkg -s pigpio &> /dev/null; then
        sudo apt install -y pigpio python3-pigpio
    fi
    echo "Pigpio installé"
else
    echo "VM détectée : GPIO mock sera utilisé"
fi

# ------------------------------
# Compiler ImgProcML
# ------------------------------
echo "=== Compilation d'ImgProcML ==="
cd ImgProcML
rm -rf build
mkdir build
cd build
cmake ..
make -j$(nproc)

# ------------------------------
# Installer les packages Node.js
# ------------------------------
echo "=== Installation des packages Node.js ==="
cd ../../WebServer
npm install

# --------------------

