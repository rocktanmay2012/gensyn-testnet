#!/bin/bash

BOLD="\e[1m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
NC="\e[0m"

# ================= CẤU HÌNH BẮT BUỘC PHẢI THAY ĐỔI =================
TELEGRAM_GROUP_ID="-1001984600875"           # ID nhóm Telegram (bắt đầu bằng -100)
TELEGRAM_BOT_TOKEN="7851698229:AAF2xWcurmrvXjwt_XT8KpeiaUR6o2qgaQg"  # Token bot
TELEGRAM_GROUP_LINK="https://t.me/Nexgencxplore"      # Link tham gia nhóm
# ===================================================================

SWARM_DIR="$HOME/rl-swarm"
API_URL="https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN"

# Hàm kiểm tra và cài đặt các phụ thuộc
install_dependencies() {
    echo -e "${BLUE}[1/5] Kiểm tra và cài đặt dependencies...${NC}"
    sudo apt update
    sudo apt install -y curl jq python3 python3-pip python3-venv git
}

# Hàm kiểm tra thành viên nhóm Telegram (ĐÃ FIX)
check_telegram_member() {
    local user_id="$1"
    
    echo -e "${BLUE}[*] Đang xác minh ID Telegram: $user_id...${NC}"
    
    # Kiểm tra kết nối Internet
    if ! ping -c 1 api.telegram.org >/dev/null 2>&1; then
        echo -e "${RED}✖ Lỗi kết nối mạng! Vui lòng kiểm tra Internet.${NC}"
        return 1
    fi

    # Gọi API Telegram
    response=$(curl -s "$API_URL/getChatMember?chat_id=$TELEGRAM_GROUP_ID&user_id=$user_id")
    
    # Debug (có thể bỏ comment để kiểm tra)
    # echo -e "${YELLOW}[DEBUG] API Response: $response${NC}"
    
    # Kiểm tra lỗi API
    if ! echo "$response" | jq -e '.ok' >/dev/null 2>&1; then
        echo -e "${RED}✖ Lỗi khi gọi Telegram API!${NC}"
        return 1
    fi

    # Phân tích trạng thái
    status=$(echo "$response" | jq -r '.result.status')
    
    case "$status" in
        "creator"|"administrator"|"member")
            echo -e "${GREEN}✔ Đã xác nhận là thành viên nhóm!${NC}"
            return 0
            ;;
        *)
            echo -e "${YELLOW}"
            echo "===================================================="
            echo " BẠN CHƯA THAM GIA NHÓM TELEGRAM BẮT BUỘC!"
            echo ""
            echo " Vui lòng tham gia nhóm sau:"
            echo -e "${BOLD}${CYAN}👉 $TELEGRAM_GROUP_LINK 👈${NC}${YELLOW}"
            echo ""
            echo " Sau đó nhấn phím bất kỳ để kiểm tra lại!"
            echo "===================================================="
            echo -e "${NC}"
            read -n 1 -s -r -p ""
            return 1
            ;;
    esac
}

# Hàm lấy ID Telegram
get_telegram_id() {
    while true; do
        echo -e "${BOLD}${YELLOW}"
        echo "Để tiếp tục, vui lòng cung cấp ID Telegram của bạn:"
        echo ""
        echo -e "${NC}1. Mở Telegram, tìm ${BOLD}@userinfobot${NC}"
        echo "2. Gửi lệnh /start cho bot"
        echo "3. Sao chép ID của bạn (dãy số)"
        echo -e "${BOLD}${YELLOW}"
        read -p "Nhập ID Telegram của bạn: " tg_id
        
        if [[ "$tg_id" =~ ^[0-9]+$ ]]; then
            echo -e "${BLUE}[*] Đang xác minh ID Telegram...${NC}"
            return "$tg_id"
        else
            echo -e "${RED}✖ ID không hợp lệ! Chỉ nhập số.${NC}"
        fi
    done
}

# Hàm xử lý swarm.pem
handle_swarm_pem() {
    echo -e "${BLUE}[3/5] Xử lý swarm.pem...${NC}"
    
    if [ -f "$SWARM_DIR/swarm.pem" ]; then
        echo -e "${YELLOW}Found existing swarm.pem. Choose:${NC}"
        echo "1) Giữ file cũ"
        echo "2) Xóa và tạo mới"
        read -p "Lựa chọn (1/2): " choice
        
        case "$choice" in
            1) 
                mv "$SWARM_DIR/swarm.pem" "$HOME/"
                rm -rf "$SWARM_DIR"
                git clone https://github.com/whalepiz/rl-swarm.git
                mv "$HOME/swarm.pem" "$SWARM_DIR/"
                ;;
            2) 
                rm -rf "$SWARM_DIR"
                git clone https://github.com/whalepiz/rl-swarm.git
                ;;
            *) 
                echo -e "${RED}Lựa chọn không hợp lệ!${NC}"
                exit 1
                ;;
        esac
    else
        git clone https://github.com/whalepiz/rl-swarm.git
    fi
}

# Hàm thiết lập môi trường
setup_environment() {
    echo -e "${BLUE}[4/5] Thiết lập môi trường Python...${NC}"
    cd "$SWARM_DIR" || exit 1
    
    python3 -m venv .venv
    source .venv/bin/activate
    pip install --upgrade pip
    pip install torch==2.2.1 torchvision==0.17.1 torchaudio==2.2.1 --index-url https://download.pytorch.org/whl/cpu
}

# Hàm khởi động
start_application() {
    echo -e "${BLUE}[5/5] Khởi động ứng dụng...${NC}"
    cd "$SWARM_DIR" || exit 1
    ./run_rl_swarm.sh
}

# ================= MAIN SCRIPT =================
clear
echo -e "${BOLD}${CYAN}"
echo " ###################################################"
echo " #   KIỂM TRA THÀNH VIÊN NHÓM TELEGRAM TRƯỚC KHI   #"
echo " #         CÀI ĐẶT HỆ THỐNG RL-SWARM               #"
echo " ###################################################"
echo -e "${NC}"

# 1. Cài đặt dependencies
install_dependencies

# 2. Kiểm tra Telegram
while true; do
    get_telegram_id
    user_id=$?
    
    if check_telegram_member "$user_id"; then
        break
    fi
done

# 3. Xử lý swarm.pem
handle_swarm_pem

# 4. Thiết lập môi trường
setup_environment

# 5. Khởi động ứng dụng
start_application

echo -e "${GREEN}"
echo "===================================================="
echo " CÀI ĐẶT HOÀN TẤT!"
echo " Cảm ơn bạn đã tham gia nhóm Telegram!"
echo "===================================================="
echo -e "${NC}"
