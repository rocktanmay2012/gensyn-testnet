#!/bin/bash

BOLD="\e[1m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
NC="\e[0m"

SWARM_DIR="$HOME/rl-swarm"
TEMP_DATA_PATH="$SWARM_DIR/modal-login/temp-data"
HOME_DIR="$HOME"

# Cấu hình Telegram (THAY ĐỔI THÔNG SỐ NÀY)
TELEGRAM_GROUP_ID="-10012345678"  # ID nhóm Telegram (số âm)
TELEGRAM_BOT_TOKEN="123456789:AAFmwqVHxX2yGZzSXyXyXyXyXyXyXyXyXyX"  # Token bot Telegram
TELEGRAM_GROUP_LINK="https://t.me/your_group_link"  # Link tham gia nhóm
API_URL="https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN"

# Hàm kiểm tra thành viên nhóm Telegram
check_telegram_member() {
    local user_id="$1"
    
    echo -e "${BLUE}[*] Đang kiểm tra thành viên nhóm Telegram...${NC}"
    
    # Kiểm tra kết nối Internet
    if ! ping -c 1 api.telegram.org >/dev/null 2>&1; then
        echo -e "${RED}✖ Lỗi kết nối mạng! Vui lòng kiểm tra Internet.${NC}"
        return 1
    fi

    # Gọi API Telegram để kiểm tra thành viên
    response=$(curl -s "$API_URL/getChatMember?chat_id=$TELEGRAM_GROUP_ID&user_id=$user_id")
    status=$(echo "$response" | jq -r '.result.status' 2>/dev/null)
    
    if [[ "$status" == "creator" || "$status" == "administrator" || "$status" == "member" ]]; then
        echo -e "${GREEN}✔ Đã xác nhận bạn là thành viên của nhóm!${NC}"
        return 0
    else
        echo -e "${YELLOW}"
        echo "===================================================="
        echo " BẠN CHƯA THAM GIA NHÓM TELEGRAM BẮT BUỘC!"
        echo ""
        echo " Vui lòng tham gia nhóm Telegram sau để tiếp tục:"
        echo ""
        echo -e "${BOLD}${CYAN}👉 $TELEGRAM_GROUP_LINK 👈${NC}${YELLOW}"
        echo ""
        echo " Sau khi tham gia, nhấn phím bất kỳ để kiểm tra lại!"
        echo "===================================================="
        echo -e "${NC}"
        read -n 1 -s -r -p ""
        return 1
    fi
}

# Hàm yêu cầu nhập ID Telegram
get_telegram_id() {
    while true; do
        echo -e "${BOLD}${YELLOW}"
        echo "Để tiếp tục, vui lòng cung cấp ID Telegram của bạn:"
        echo ""
        echo -e "${NC}1. Mở Telegram và tìm bot ${BOLD}@userinfobot${NC}"
        echo "2. Gửi lệnh /start cho bot"
        echo "3. Sao chép ID của bạn (dãy số)"
        echo -e "${BOLD}${YELLOW}"
        echo "Nhập ID Telegram của bạn (chỉ số, không chứa chữ cái):"
        echo -e "${NC}"
        read -p "ID Telegram: " tg_id
        
        if [[ "$tg_id" =~ ^[0-9]+$ ]]; then
            echo -e "${BLUE}[*] Đang xác minh ID Telegram: $tg_id...${NC}"
            return "$tg_id"
        else
            echo -e "${RED}✖ ID không hợp lệ! Vui lòng nhập chỉ số.${NC}"
            echo ""
        fi
    done
}

# Hàm kiểm tra và cài đặt Python 3.10
install_python310() {
    echo -e "${BOLD}${YELLOW}[!] Installing Python 3.10...${NC}"
    sudo add-apt-repository ppa:deadsnakes/ppa -y
    sudo apt update
    sudo apt install -y python3.10 python3.10-venv
}

# =================================================
# PHẦN CHÍNH CỦA SCRIPT
# =================================================

# 1. Kiểm tra tham gia nhóm Telegram trước
while true; do
    clear
    echo -e "${BOLD}${CYAN}"
    echo "###################################################"
    echo "#   KIỂM TRA THÀNH VIÊN NHÓM TELEGRAM TRƯỚC KHI   #"
    echo "#         TIẾP TỤC CÀI ĐẶT RL-SWARM               #"
    echo "###################################################"
    echo -e "${NC}"
    
    get_telegram_id
    user_id=$?
    
    if check_telegram_member "$user_id"; then
        break
    fi
done

# 2. Sau khi đã xác minh thành viên, tiếp tục xử lý swarm.pem
echo -e "${GREEN}"
echo "===================================================="
echo " ĐÃ XÁC MINH THÀNH CÔNG! TIẾP TỤC QUÁ TRÌNH CÀI ĐẶT"
echo "===================================================="
echo -e "${NC}"

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
