<h2 align=center>Gensyn Testnet Node Guide </h2>


****Buy cheap GPU at : [ACCESS](https://clore.ai?ref_id=qfv4gytu)****

**Follow Me: https://x.com/WhalePiz**

**Telegram Group: https://t.me/Nexgenexplore**
## PLEASE SELECT THE HARDWARE YOU WANT TO RUN ON


## 💻 System Requirements

| Requirement                        | Details                                                                                      |
|-------------------------------------|---------------------------------------------------------------------------------------------|
| **CPU Architecture**                | `arm64` or `amd64`                                                                          |
| **Recommended RAM**                 | 25 GB                                                                                       |
| **CUDA Devices (Recommended)**      | `RTX 3090`, `RTX 4090`, `A100`, `H100`                                                      |
| **Python Version**                  | Python >= 3.10 (For Mac, you may need to upgrade)                                                                                     |

## 💻 Run node 
1. **Install `sudo`**
```bash
apt update && apt upgrade -y
```
2. **Install other dependencies**
```bash
apt install screen curl iptables build-essential git wget lz4 jq make gcc nano automake autoconf tmux htop nvme-cli libgbm1 pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip libleveldb-dev  -y
```
3. **Install Python**
```bash
apt install python3 python3-pip python3-venv python3-dev -y
```
4.**Install Node.js and  yarn**
```bash
apt update
curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
apt install -y nodejs
node -v
npm install -g yarn
yarn -v
```
5. **Install Yarn**
```bash
curl -o- -L https://yarnpkg.com/install.sh | bash
```
```bash
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
```
```bash
source ~/.bashrc
```
6. **Create a screen session**
```bash
screen -S gensyn
```
7. **Clone the Repository and Run**
```bash
cd $HOME && rm -rf gensyn-testnet && git clone https://github.com/whalepiz/gensyn-testnet.git && chmod +x gensyn-testnet/gensyn.sh && ./gensyn-testnet/gensyn.sh
```
<img width="467" height="146" alt="image" src="https://github.com/user-attachments/assets/0203120d-1d0d-4e12-8ff0-8b2e1e42d8cc" />

- You will get a link like this slick-cars-shake.loca.lt
- Access the website and enter your IP address as I have highlighted in red
- Then log in with your email and return to the original terminal to continue the process

**Answer prompts:**
* `Would you like to push models you train in the RL swarm to the Hugging Face Hub? [y/N]` >>> Press `N` to join testnet
  * `HuggingFace` needs `2GB` upload bandwidth for each model you train, you can press `Y`, and enter your access-token.
* `Enter the name of the model you want to use in huggingface repo/name format, or press [Enter] to use the default model.` >>> For default model, press `Enter`  or choose one of these (More model parameters (B) need more vRAM):
  * `Gensyn/Qwen2.5-0.5B-Instruct`
  * `Qwen/Qwen3-0.6B`
  * `nvidia/AceInstruct-1.5B`
  * `dnotitia/Smoothie-Qwen3-1.7B`
  * `Gensyn/Qwen2.5-1.5B-Instruct`

# Backup Instructions for `swarm.pem`

## VPS:
1. Use **Mobaxterm** to establish a connection to your VPS.
2. Once connected, transfer the `swarm.pem` file from the following directory to your local machine:
   ```
   /root/rl-swarm/swarm.pem
   ```

## WSL (Windows Subsystem for Linux):
1. Open **Windows Explorer** and search for `\wsl.localhost` to access your Ubuntu directories.
2. The primary directories are:
   - If installed under a specific username:
     ```
     \wsl.localhost\Ubuntu\home\<your_username>\rl-swarm
     ```
   - If installed under root:
     ```
     \wsl.localhost\Ubuntu\root\rl-swarm
     ```
3. Locate the `swarm.pem` file within the `rl-swarm` folder.

## GPU Servers (e.g., Hyperbolic):
1. Open **Windows PowerShell** and execute the following command to connect to your GPU server:
   ```
   sftp -P PORT ubuntu@xxxx.hyperbolic.xyz
   ```
   - Replace `ubuntu@xxxx.hyperbolic.xyz` with your GPU server's hostname.
   - Replace `PORT` with the specific port from your server's SSH connection details.
   - The username might vary (e.g., `root`), depending on your server configuration.

2. After establishing the connection, you will see the `sftp>` prompt.
3. To navigate to the folder containing `swarm.pem`, use the `cd` command:
   ```
   cd /home/ubuntu/rl-swarm
   ```

4. To download the file, use the `get` command:
   ```
   get swarm.pem
   ```
   The file will be saved in the directory where you ran the `sftp` command, typically:
   - If you executed the command in PowerShell, the file will be stored in `C:\Users\<your_pc_username>`.

5. Once the download is complete, type `exit` to close the connection.

---

You've successfully backed up the `swarm.pem` file from your VPS, WSL, or GPU server.

Update coming soon...


