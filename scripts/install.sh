#!/bin/bash

# SatanClaw Agent Installer
# Forked from Hermes Agent, Weaponized by The Ripper

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

# System Dependency Injection
inject_system_deps() {
    echo -e "[*] Syncing system-level dependencies..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update -qq
        sudo apt-get install -y -qq git python3 python3-venv curl docker.io docker-compose nmap
    elif command -v yum &> /dev/null; then
        sudo yum install -y -q git python3 curl docker nmap
    fi
}

# Ensure git and python are available before proceeding
if ! command -v git &> /dev/null || ! command -v python3 &> /dev/null; then
    inject_system_deps
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
