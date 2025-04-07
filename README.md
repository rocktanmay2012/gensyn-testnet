<h2 align=center>Gensyn Testnet Node Guide - CPU </h2>

**Follow Me: https://x.com/WhalePiz**

## 💻 System Requirements

| Requirement                        | Details                                                                                      |
|-------------------------------------|---------------------------------------------------------------------------------------------|
| **CPU Architecture**                | `arm64` or `amd64`                                                                          |
| **Recommended RAM**                 | 25 GB                                                                                       |

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

## 📥 Installation

1. **Install `sudo`**
```bash
sudo apt update && sudo apt install -y sudo
```
2. **Install other dependencies**
```bash
sudo apt update && sudo apt install -y python3 python3-venv python3-pip curl wget screen git lsof && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && sudo apt update && sudo apt install -y yarn
```
3. **Install Node.js and npm if not installed already**  
```bash
curl -sSL https://raw.githubusercontent.com/whalepiz/installation/main/node.sh | bash
```
4. **Clone this repository [ For CPU, you use this command ]**
```bash
cd $HOME && [ -d rl-swarm ] && rm -rf rl-swarm; git clone https://github.com/whalepiz/rl-swarm.git && cd rl-swarm
```
5. **Clone this repository [For GPU, you use this command]**
```bash
cd $HOME && [ -d rl-swarm ] && rm -rf rl-swarm; git clone https://github.com/whalepiz/GPU_rl-swarm.git rl-swarm && cd rl-swarm
```

6. **Create a `screen` session**
```bash
screen -S gensyn
```
7. **Run the swarm**
```bash
python3 -m venv .venv && . .venv/bin/activate && ./run_rl_swarm.sh
```
- It will ask some questions, you should send response properly
- ```Would you like to connect to the Testnet? [Y/n]``` : Write `Y`
- ```Would you like to push models you train in the RL swarm to the Hugging Face Hub? [y/N]``` : Write `N`
- When you will see interface like this, you can detach from this screen session

![Screenshot 2025-04-01 061641](https://github.com/user-attachments/assets/b5ed9645-16a2-4911-8a73-97e21fdde274)

