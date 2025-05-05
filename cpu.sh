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

# Xử lý swarm.pem
if [ -f "$SWARM_DIR/swarm.pem" ]; then
    echo -e "${BOLD}${YELLOW}Existing swarm.pem detected. Choose:${NC}"
    echo -e "1) Keep existing"
    echo -e "2) Delete and start fresh"
    read -p "Choice (1/2): " choice
    case $choice in
        1) 
            mv "$SWARM_DIR/swarm.pem" "$HOME_DIR/"
            rm -rf "$SWARM_DIR"
            git clone https://github.com/whalepiz/rl-swarm.git
            mv "$HOME_DIR/swarm.pem" rl-swarm/
            ;;
        2) 
            rm -rf "$SWARM_DIR"
            git clone https://github.com/whalepiz/rl-swarm.git
            ;;
        *) 
            echo -e "${RED}Invalid choice. Exiting.${NC}"
            exit 1
            ;;
    esac
else
    git clone https://github.com/whalepiz/rl-swarm.git
fi

cd rl-swarm || exit 1

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
rm -rf .venv/  # Linux/macOS
python3 -m venv .venv
source .venv/bin/activate
pip install torch==2.2.1 torchvision==0.17.1 torchaudio==2.2.1 --index-url https://download.pytorch.org/whl/cpu

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
