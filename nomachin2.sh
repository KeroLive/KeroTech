#!/bin/bash

# Install dependencies
sudo su &
sudo apt update
apt install ruby openvpn figlet ruby wget unzip -y

# Check if the lolcat files are already unzipped
if [ ! -d "lolcat-master" ]; then
  wget https://github.com/busyloop/lolcat/archive/master.zip
  unzip master.zip
  cd lolcat-master/bin/
  gem install lolcat
else
  echo "lolcat files already exist, skipping unzip step."
  cd lolcat-master/bin/
fi

pip install git+https://github.com/tehmaze/lolcat.git
apt install figlet -y

save_config() {
    echo "$content" > "$0.txt"  # Save content to a temporary file
    sudo mv "$0.txt" "$file_name"  # Move the temporary file to replace the script itself
    sudo cp "$file_name" "/etc/openvpn/client.conf"
    echo "Configuration saved."
}

# Prompt user for the URL to download
figlet  "Please paste the URL of the webpage or file you want to download:" -c  | lolcat -f
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

DOCKER_CMD="docker run --rm -d --network host --privileged --name nomachine-xfce4 -e PASSWORD=123456 -e USER=kero --cap-add=SYS_PTRACE --shm-size=1g thuonghai2711/nomachine-ubuntu-desktop:windows10"

eval $DOCKER_CMD
clear
sleep 10
figlet  "The Username Is : kero" -c  | lolcat -a
figlet  "The Password Is : 123456" -c  | lolcat -a
figlet  "Thanks For You From Kyrolos Hany Enjoy Your RDP :)" -c  | lolcat -a

OPENVPN_CMD="sudo openvpn --config /etc/openvpn/client.conf"

eval $OPENVPN_CMD | lolcat -f
