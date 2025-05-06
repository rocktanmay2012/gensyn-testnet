#!/bin/bash

BOLD="\e[1m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
NC="\e[0m"

SWARM_DIR="$HOME/rl-swarm"
TEMP_DATA_PATH="$SWARM_DIR/modal-login/temp-data"
HOME_DIR="$HOME"

# Hàm kiểm tra và cài đặt Python 3.10
install_python310() {
    echo -e "${BOLD}${YELLOW}[!] Installing Python 3.10...${NC}"
    sudo add-apt-repository ppa:deadsnakes/ppa -y
    sudo apt update
    sudo apt install -y python3.10 python3.10-venv
}

cd $HOME

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
    cd $HOME && [ -d rl-swarm ] && rm -rf rl-swarm; git clone https://github.com/whalepiz/rl-swarm.git > /dev/null 2>&1
fi

cd rl-swarm || { echo -e "${BOLD}${RED}[✗] Failed to enter rl-swarm directory. Exiting.${NC}"; exit 1; }

if [ -n "$VIRTUAL_ENV" ]; then
    echo -e "${BOLD}${YELLOW}[✓] Deactivating existing virtual environment...${NC}"
    deactivate
fi

# Cài đặt Python 3.10 nếu chưa có
if ! command -v python3.10 &> /dev/null; then
    install_python310 || {
        echo -e "${RED}Fallback to python3${NC}"
        PYTHON_CMD="python3"
    }
else
    PYTHON_CMD="python3.10"
fi

# Tạo virtual environment
$PYTHON_CMD -m venv .venv
source .venv/bin/activate

# Cài đặt PyTorch 2.6.0 và các phụ thuộc
pip install --upgrade --no-cache-dir \
    torch==2.6.0 \
    torchvision==0.16.0 \
    torchaudio==2.6.0 \
    --index-url https://download.pytorch.org/whl/cpu

# Fix lỗi Hivemind training
cat > hivemind_fix.py <<EOF
from transformers import TrainerCallback

class FixCacheCallback(TrainerCallback):
    def on_train_begin(self, args, state, control, **kwargs):
        model = kwargs.get('model')
        if model:
            model.config.use_cache = False
            if not hasattr(model.config, 'gradient_checkpointing'):
                model.config.gradient_checkpointing = True

    def on_step_end(self, args, state, control, **kwargs):
        outputs = kwargs.get('outputs')
        if outputs and 'loss' not in outputs:
            raise ValueError("Missing training outputs - check data paths")
EOF

# Chạy training với fix
echo -e "${GREEN}Starting training with fixes...${NC}"
python -c "
from hivemind_fix import FixCacheCallback
from transformers import TrainingArguments

args = TrainingArguments(
    output_dir='./results',
    gradient_checkpointing=True,
    per_device_train_batch_size=4,
    logging_steps=10
)

trainer = YourTrainerClass(
    model=model,
    args=args,
    train_dataset=train_data,
    callbacks=[FixCacheCallback()]
)

trainer.train()
"

./run_rl_swarm.sh
