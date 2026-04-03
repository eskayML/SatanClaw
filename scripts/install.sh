#!/bin/bash

# SatanClaw Agent Installer
# Forked from Hermes Agent, Weaponized by Samuel Kalu

set -e

RED='\033[0;31m'
NC='\033[0m'
BOLD='\033[1m'

echo -e "${RED}${BOLD}"
cat << "EOF"
                ,      ,
               /(.-""-.)\
           |\  \/      \/  /|
           | \ / =    = \ / |
           \( \   o  o   / )/
            \_, '-==-' ,_/
               /  '--'  \
              / _      _ \
             / / \    / \ \
            / /   \__/   \ \
            \ \          / /
             \ \        / /
              \ \      / /
               \ \    / /
                \ \  / /
                 \ \/ /
                  \  /
                   \/
EOF
echo -e "      ⚕ SATANCLAW AGENT ⚕"
echo -e "${NC}"

echo -e "[*] Initializing SatanClaw Installation..."

# Check dependencies
if ! command -v git &> /dev/null; then
    echo -e "[!] Git not found. Install it first."
    exit 1
fi

if ! command -v python3 &> /dev/null; then
    echo -e "[!] Python3 not found. Install it first."
    exit 1
fi

# Determine installation directory
INSTALL_DIR="$HOME/SatanClaw"

if [ -d "$INSTALL_DIR" ]; then
    echo -e "[*] Updating existing SatanClaw installation..."
    cd "$INSTALL_DIR"
    git pull origin main
else
    echo -e "[*] Cloning SatanClaw from eskayML..."
    git clone https://github.com/eskayML/SatanClaw.git "$INSTALL_DIR"
    cd "$INSTALL_DIR"
fi

# Setup Virtual Environment
echo -e "[*] Setting up Hellfire Environment..."
python3 -m venv venv
source venv/bin/activate

# Install requirements
echo -e "[*] Injecting dependencies..."
pip install --upgrade pip
pip install -r requirements.txt
pip install -e .

# Create the global symlink
echo -e "[*] Establishing global 'satanclaw' command..."
sudo ln -sf "$INSTALL_DIR/satanclaw" /usr/local/bin/satanclaw

echo -e "\n${RED}${BOLD}[✓] SATANCLAW INSTALLED SUCCESSFULLY.${NC}"
echo -e "[*] You can now ignite the core using: ${BOLD}satanclaw${NC}"
echo -e "[*] To configure your targets, run: ${BOLD}satanclaw setup${NC}"
