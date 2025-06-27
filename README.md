<h2 align=center>Gensyn Testnet Node Guide </h2>

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
```bash
cd ~/rl-swarm
```
```bash
python3 -m venv .venv
source .venv/bin/activate
./run_rl_swarm.sh
```
![image](https://github.com/user-attachments/assets/8f309e0f-85a1-4474-91b9-49431b3409f0)

8. **Open login page in browser**

_**Use the below command in the new terminal**_

```bash
npm install -g localtunnel
```
```bash
curl https://loca.lt/mytunnelpassword
```
```bash
lt --port 3000
```
You will get a link like this smart-monkeys-rescue.loca.lt

![image](https://github.com/user-attachments/assets/850a5a13-2bd3-4b15-ac50-d51373e0e129)

- Access the website and enter your IP address as I have highlighted in red
- Then log in with your email and return to the original terminal to continue the process


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


