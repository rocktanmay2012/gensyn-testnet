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
TELEGRAM_GROUP_LINK="https://t.me/your_telegram_group"  # Thay bằng link Telegram thực tế

clear
echo -e "${BOLD}${CYAN}"
echo "###################################################"
echo "#   KIỂM TRA THÀNH VIÊN NHÓM TELEGRAM TRƯỚC KHI   #"
echo "#         TIẾP TỤC CÀI ĐẶT RL-SWARM               #"
echo "###################################################"
echo -e "${NC}"
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

# Hàm kiểm tra và cài đặt các gói cần thiết
install_dependencies() {
    echo -e "${BOLD}${YELLOW}[!] Cài đặt các phụ thuộc cần thiết...${NC}"
    sudo apt update
    sudo apt install -y git python3 python3-venv python3-pip
}

# Hàm kiểm tra và cài đặt Python 3.10
install_python310() {
    echo -e "${BOLD}${YELLOW}[!] Installing Python 3.10...${NC}"
    sudo add-apt-repository ppa:deadsnakes/ppa -y
    sudo apt update
    sudo apt install -y python3.10 python3.10-venv
}

# Kiểm tra và xử lý thư mục đã tồn tại
if [ -d "$SWARM_DIR" ]; then
    echo -e "${BOLD}${YELLOW}Phát hiện thư mục rl-swarm đã tồn tại. Chọn:${NC}"
    echo -e "1) Giữ lại và cập nhật"
    echo -e "2) Xóa và cài đặt mới"
    read -p "Lựa chọn (1/2): " choice
    
    case $choice in
        1)
            # Di chuyển swarm.pem nếu tồn tại
            if [ -f "$SWARM_DIR/swarm.pem" ]; then
                echo -e "${YELLOW}Đã phát hiện swarm.pem, đang sao lưu...${NC}"
                mv "$SWARM_DIR/swarm.pem" "$HOME_DIR/"
            fi
            
            echo -e "${YELLOW}Đang xóa thư mục cũ...${NC}"
            rm -rf "$SWARM_DIR"
            
            echo -e "${GREEN}Đang tải xuống phiên bản mới nhất...${NC}"
            git clone https://github.com/whalepiz/rl-swarm.git "$SWARM_DIR"
            
            # Khôi phục swarm.pem nếu có
            if [ -f "$HOME_DIR/swarm.pem" ]; then
                echo -e "${YELLOW}Đang khôi phục swarm.pem...${NC}"
                mv "$HOME_DIR/swarm.pem" "$SWARM_DIR/"
            fi
            ;;
        2)
            echo -e "${YELLOW}Đang xóa thư mục cũ...${NC}"
            rm -rf "$SWARM_DIR"
            
            echo -e "${GREEN}Đang tải xuống phiên bản mới nhất...${NC}"
            git clone https://github.com/whalepiz/rl-swarm.git "$SWARM_DIR"
            ;;
        *)
            echo -e "${RED}Lựa chọn không hợp lệ. Thoát.${NC}"
            exit 1
            ;;
    esac
else
    echo -e "${GREEN}Đang tải xuống rl-swarm...${NC}"
    git clone https://github.com/whalepiz/rl-swarm.git "$SWARM_DIR"
fi

# Chuyển vào thư mục làm việc
cd "$SWARM_DIR" || {
    echo -e "${RED}Không thể chuyển vào thư mục $SWARM_DIR${NC}"
    exit 1
}

# Cài đặt Python 3.10 nếu chưa có
if ! command -v python3.10 &> /dev/null; then
    install_python310 || {
        echo -e "${RED}Không thể cài đặt Python 3.10, sử dụng Python 3 thay thế${NC}"
        PYTHON_CMD="python3"
    }
else
    PYTHON_CMD="python3.10"
fi

# Tạo virtual environment
echo -e "${BOLD}${YELLOW}[!] Đang tạo môi trường ảo...${NC}"
rm -rf .venv/
$PYTHON_CMD -m venv .venv
source .venv/bin/activate

# Cài đặt các phụ thuộc
echo -e "${BOLD}${YELLOW}[!] Đang cài đặt các thư viện cần thiết...${NC}"
pip install --upgrade pip
pip install torch==2.2.1 torchvision==0.17.1 torchaudio==2.2.1 --index-url https://download.pytorch.org/whl/cpu
pip install -r requirements.txt

# Fix lỗi Hivemind training
echo -e "${BOLD}${YELLOW}[!] Đang áp dụng bản sửa lỗi Hivemind...${NC}"
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
echo -e "${GREEN}Đang bắt đầu training với các bản sửa lỗi...${NC}"
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

# Chạy script chính
echo -e "${BOLD}${GREEN}Đang khởi chạy RL-Swarm...${NC}"
chmod +x run_rl_swarm.sh
./run_rl_swarm.sh
