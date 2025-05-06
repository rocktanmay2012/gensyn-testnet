#!/bin/bash

BOLD="\e[1m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
NC="\e[0m"

SWARM_DIR="$HOME/rl-swarm"
TEMP_DATA_PATH="$SWARM_DIR/modal-login/temp-data"
HOME_DIR="$HOME"

cd $HOME || exit

# Hàm cài đặt Python 3.10
install_python310() {
    echo -e "${BOLD}${YELLOW}[!] Installing Python 3.10...${NC}"
    
    # Thử cài từ deadsnakes PPA trước
    if ! sudo add-apt-repository ppa:deadsnakes/ppa -y > /dev/null 2>&1; then
        echo -e "${BOLD}${RED}[✗] Failed to add deadsnakes PPA${NC}"
        return 1
    fi
    
    sudo apt update > /dev/null 2>&1
    if ! sudo apt install -y python3.10 python3.10-venv > /dev/null 2>&1; then
        echo -e "${BOLD}${RED}[✗] Failed to install Python 3.10 from PPA${NC}"
        return 1
    fi
    
    return 0
}

# Xử lý swarm.pem
if [ -f "$SWARM_DIR/swarm.pem" ]; then
    echo -e "${BOLD}${YELLOW}You already have an existing ${GREEN}swarm.pem${YELLOW} file.${NC}\n"
    echo -e "${BOLD}${YELLOW}Do you want to:${NC}"
    echo -e "${BOLD}1) Use the existing swarm.pem${NC}"
    echo -e "${BOLD}${RED}2) Delete existing swarm.pem and start fresh${NC}"

    while true; do
        read -p $'\e[1mEnter your choice (1 or 2): \e[0m' choice
        if [ "$choice" == "1" ]; then
            echo -e "\n${BOLD}${YELLOW}[✓] Using existing swarm.pem...${NC}"
            mv "$SWARM_DIR/swarm.pem" "$HOME_DIR/"
            mv "$TEMP_DATA_PATH/userData.json" "$HOME_DIR/" 2>/dev/null
            mv "$TEMP_DATA_PATH/userApiKey.json" "$HOME_DIR/" 2>/dev/null

            rm -rf "$SWARM_DIR"

            echo -e "${BOLD}${YELLOW}[✓] Cloning fresh repository...${NC}"
            cd $HOME && git clone https://github.com/whalepiz/rl-swarm.git > /dev/null 2>&1

            mv "$HOME_DIR/swarm.pem" rl-swarm/
            mv "$HOME_DIR/userData.json" rl-swarm/modal-login/temp-data/ 2>/dev/null
            mv "$HOME_DIR/userApiKey.json" rl-swarm/modal-login/temp-data/ 2>/dev/null
            break
        elif [ "$choice" == "2" ]; then
            echo -e "${BOLD}${YELLOW}[✓] Removing existing folder and starting fresh...${NC}"
            rm -rf "$SWARM_DIR"
            cd $HOME && git clone https://github.com/whalepiz/rl-swarm.git > /dev/null 2>&1
            break
        else
            echo -e "\n${BOLD}${RED}[✗] Invalid choice. Please enter 1 or 2.${NC}"
        fi
    done
else
    echo -e "${BOLD}${YELLOW}[✓] No existing swarm.pem found. Cloning repository...${NC}"
    cd $HOME && { [ -d rl-swarm ] && rm -rf rl-swarm; } && git clone https://github.com/whalepiz/rl-swarm.git > /dev/null 2>&1
fi

cd rl-swarm || { echo -e "${BOLD}${RED}[✗] Failed to enter rl-swarm directory. Exiting.${NC}"; exit 1; }

if [ -n "$VIRTUAL_ENV" ]; then
    echo -e "${BOLD}${YELLOW}[✓] Deactivating existing virtual environment...${NC}"
    deactivate
fi

echo -e "${BOLD}${YELLOW}[✓] Setting up Python virtual environment...${NC}"

# Kiểm tra và cài đặt Python 3.10 nếu cần
if ! command -v python3.10 &> /dev/null; then
    echo -e "${BOLD}${RED}[✗] python3.10 not found. Attempting to install...${NC}"
    
    # Thử cài đặt Python 3.10
    if ! install_python310; then
        echo -e "${BOLD}${YELLOW}[!] Falling back to available Python version...${NC}"
        PYTHON_CMD=$(command -v python3 || command -v python)
        
        if [ -z "$PYTHON_CMD" ]; then
            echo -e "${BOLD}${RED}[✗] No Python interpreter found. Please install Python manually.${NC}"
            exit 1
        fi
        
        echo -e "${BOLD}${YELLOW}[!] Using ${PYTHON_CMD} instead of python3.10${NC}"
        python3 -m venv .venv || {
            echo -e "${BOLD}${RED}[✗] Failed to create virtual environment${NC}"
            exit 1
        }
    fi
fi

# Tạo virtual environment
python3.10 -m venv .venv || {
    echo -e "${BOLD}${RED}[✗] Failed to create virtual environment with python3.10, trying fallback...${NC}"
    python3 -m venv .venv || {
        echo -e "${BOLD}${RED}[✗] Completely failed to create virtual environment${NC}"
        exit 1
    }
}

source .venv/bin/activate || {
    echo -e "${BOLD}${RED}[✗] Failed to activate virtual environment${NC}"
    exit 1
}

echo -e "${BOLD}${YELLOW}[✓] Removing previous PyTorch installations...${NC}"
pip uninstall -y torch torchvision torchaudio 2>/dev/null || true

echo -e "${BOLD}${YELLOW}[✓] Installing fresh PyTorch packages...${NC}"
pip install --upgrade --no-cache-dir torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu || {
    echo -e "${BOLD}${RED}[✗] Failed to install PyTorch${NC}"
    exit 1
}

echo -e "${BOLD}${YELLOW}[✓] Running rl-swarm...${NC}"
./run_rl_swarm.sh
