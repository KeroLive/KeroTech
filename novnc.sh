#!/bin/bash

# Install dependencies
sudo su &
sudo apt update
apt-get install ruby -y
wget https://github.com/busyloop/lolcat/archive/master.zip
unzip master.zip
cd lolcat-master/bin/
gem install lolcat
sudo apt install figlet -y
pip install git+https://github.com/tehmaze/lolcat.git
sudo apt update
sudo apt install -y openvpn figlet ruby wget unzip

# Function to handle saving the configuration to the script itself
save_config() {
    echo "$content" > "$0.txt"  # Save content to a temporary file
    sudo mv "$0.txt" "$file_name"  # Move the temporary file to replace the script itself
    sudo cp "$file_name" "/etc/openvpn/client.conf"
    echo "Configuration saved."
}

# Prompt user for the URL to download
figlet "Please paste the URL of the webpage or file you want to download:" -c | lolcat -f
read -r user_url

# Define the base URL
base_url="https://raw.githubusercontent.com/KeroLive/KeroTech/main/config/"

# Extract file name from user-provided URL
file_name=$(basename "$user_url")

# Construct the full download URL
download_url="$base_url$file_name"

# Download the content from the URL using wget
echo "Downloading content from $download_url..."
content=$(wget -qO- "$download_url")

# Check if content download was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to download content from $download_url."
    exit 1
fi

# Call function to save downloaded content to the script itself
save_config

echo "Content downloaded successfully and script updated."

clear

# Docker command
docker run --privileged --shm-size 1g -d \
  -p 4000:10000 \
  -e VNC_PASSWD=kero \
  -e PORT=10000 \
  -e AUDIO_PORT=1699 \
  -e WEBSOCKIFY_PORT=6900 \
  -e VNC_PORT=5900 \
  -e SCREEN_WIDTH=1000 \
  -e SCREEN_HEIGHT=680 \
  -e SCREEN_DEPTH=24 \
  thuonghai2711/ubuntu-novnc-pulseaudio:20.04

clear
sleep 10
figlet "The Password Is : kero" -c | lolcat -a
figlet "Thanks For You From Kyrolos Hany Enjoy Your RDP :)" -c | lolcat -a

# OpenVPN command
OPENVPN_CMD="sudo openvpn --config /etc/openvpn/client.conf"

# Execute OpenVPN command
eval $OPENVPN_CMD | lolcat -f
