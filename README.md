<h2 align=center>Gensyn Testnet Node Guide </h2>



**Note: - For personal computers that have not installed Linux Ubuntu on Windows, follow this step. 
        - For computers that already have Linux Ubuntu on Windows or VPS, skip this step and proceed to the Installation NODE section.**


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
apt update && apt install -y sudo
```
2. **Install other dependencies**
```bash
sudo apt update && sudo apt install -y python3 python3-venv python3-pip curl wget screen git lsof nano unzip
```
3. **Install Node.js and npm`**
```bash
sudo apt-get update
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs
```
4. **Create a screen session**
```bash
screen -S gensyn
```
5. Delete Temp-data
```
[ -n "$(ls "$HOME/rl-swarm/modal-login/temp-data/"*.json 2>/dev/null)" ] && rm -f "$HOME/rl-swarm/modal-login/temp-data/"*.json 2>/dev/null || true
```
6. **Create a screen session**
```bash
cd $HOME && rm -rf gensyn-testnet && git clone https://github.com/whalepiz/gensyn-testnet.git && chmod +x gensyn-testnet/gensyn.sh && ./gensyn-testnet/gensyn.sh
```

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


