<h2 align=center>Gensyn Testnet Node Guide - CPU </h2>



**Note: - For personal computers that have not installed Linux Ubuntu on Windows, follow this step. 
        - For computers that already have Linux Ubuntu on Windows or VPS, skip this step and proceed to the Installation NODE section.**


**Follow Me: https://x.com/WhalePiz**

## 💻 System Requirements

| Requirement                        | Details                                                                                      |
|-------------------------------------|---------------------------------------------------------------------------------------------|
| **CPU Architecture**                | `arm64` or `amd64`                                                                          |
| **Recommended RAM**                 | 25 GB                                                                                       |
| **CUDA Devices (Recommended)**      | `RTX 3090`, `RTX 4090`, `A100`, `H100`                                                      |
| **Python Version**                  | Python >= 3.10 (For Mac, you may need to upgrade)                                                                                     |

# Install Linux Ubuntu on Windows using WSL

> Certain tasks, such as `Contribute Ceremony` or `Contract Deployments`, sometimes don't require a cloud server (VPS). Instead, installing a Linux distribution like Ubuntu on Windows can be sufficient
>
> In this Guide, I'll tell you how to Install Linux (Ubuntu distribution) on Windows using WSL

## Step 1: Enable WSL

1. Opening Windows Powershell Terminal
![Screenshot_357](https://github.com/user-attachments/assets/42e29c7f-9021-433c-87c4-2f76189b1322)

2. Run the WSL Installation Command:
```
wsl --install
```
* It may ask you to choose a username and password

3. Restart Your Computer:
  
After the installation completes, you may need to restart your computer

## Step 2: Install Ubuntu

1. Open Microsoft Store:

After restarting, open the Microsoft Store from the Start menu.

2. Search for Ubuntu:

In the Store, type "Ubuntu" in the search bar. You’ll see various versions like Ubuntu 20.04 LTS, Ubuntu 22.04 LTS, etc

3. Select and Install:

Click on the version you want to install, then click the Get or Install button

## Once Ubuntu Linux is installed on Windows, start running Node

## 📥 Installation NODE

1. **Install `sudo`**
```bash
apt update && apt install -y sudo
```
2. **Install other dependencies**
```bash
sudo apt update && sudo apt install -y python3 python3-venv python3-pip curl wget screen git lsof && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && sudo apt update && sudo apt install -y yarn
```
3. **Install Node.js and npm if not installed already**  
```bash
curl -sSL https://raw.githubusercontent.com/whalepiz/installation/main/node.sh | bash
```

4. **Create a `screen` session**
```bash
screen -S gensyn
```
5. **Clone this repository**
```bash
git clone https://github.com/whalepiz/rl-swarm.git/
cd rl-swarm
```
6. **Create a `screen` session**
```bash
python3 -m venv .venv
source .venv/bin/activate
./run_rl_swarm.sh
```
- It will ask some questions, you should send response properly
- ```Would you like to connect to the Testnet? [Y/n]``` : Write `Y`
- ```Would you like to push models you train in the RL swarm to the Hugging Face Hub? [y/N]``` : Write `N`
- When you will see interface like this, you can detach from this screen session

![Screenshot 2025-04-01 061641](https://github.com/user-attachments/assets/b5ed9645-16a2-4911-8a73-97e21fdde274)


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


