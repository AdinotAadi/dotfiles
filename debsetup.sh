#!/bin/bash

# Update and upgrade system
sudo apt update -y
sudo apt install -y nala
sudo nala update -y
sudo nala upgrade -y

# Remove unnecessary GNOME games and applications
sudo apt purge -y \
    iagno lightsoff four-in-a-row gnome-robots pegsolitaire gnome-2048 \
    hitori gnome-klotski gnome-mines gnome-mahjongg gnome-sudoku \
    quadrapassel swell-foop gnome-tetravex gnome-taquin aisleriot \
    gnome-chess five-or-more gnome-nibbles tali \
    && sudo apt autoremove -y

# Autopurge Firefox ESR
sudo apt autopurge -y firefox-esr

# Add Mozilla's repository and install Firefox
sudo install -d -m 0755 /etc/apt/keyrings
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
gpg -n -q --import --import-options import-show /etc/apt/keyrings/packages.mozilla.org.asc | awk '/pub/{getline; gsub(/^ +| +$/,"" ); if($0 == "35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3") print "\nThe key fingerprint matches ("$0").\n"; else print "\nVerification failed: the fingerprint ("$0") does not match the expected one.\n"}'
echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null
echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
' | sudo tee /etc/apt/preferences.d/mozilla
sudo nala update && sudo nala install -y firefox

# Enable experimental GNOME features
gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"

# Install essential packages
sudo nala install -y \
    build-essential openjdk-17-jdk openjdk-17-jre vlc libavcodec-extra \
    git gh gnome-tweaks python-is-python3 wget curl \
    yaru-theme-gnome-shell yaru-theme-gtk yaru-theme-icon \
    yaru-theme-sound papirus-icon-theme tlp tlp-rdw

# Install and configure Flatpak
sudo apt install -y flatpak
sudo apt install -y gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Install and configure auto-cpufreq
sudo cp ./auto-cpufreq.conf /etc/
cd /etc/
sudo git clone https://github.com/AdnanHodzic/auto-cpufreq
cd ./auto-cpufreq/
sudo ./auto-cpufreq-installer
sudo auto-cpufreq --install

# Reboot the system
sudo reboot now
