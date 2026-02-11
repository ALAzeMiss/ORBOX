#!/usr/bin/env bash
sudo apt-get update
sudo apt-get upgrade
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs
sudo apt install -y npm

