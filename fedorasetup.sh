#!/bin/bash

# Exit on error
set -e

echo "==== Fedora Setup Script Starting ===="

# 1. DNF Configuration
echo "Applying custom DNF configuration..."
sudo cp ./dnf.conf /etc/dnf/dnf.conf

# 2. Update System Base
echo "Refreshing system packages..."
sudo dnf upgrade --refresh -y

# 3. Enable RPM Fusion
echo "Enabling RPM Fusion repositories..."
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
                     https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1
sudo dnf update -y @core
sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing
sudo dnf update -y @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
sudo dnf install -y intel-media-driver
sudo dnf install -y rpmfusion-nonfree-release-tainted
sudo dnf --repo=rpmfusion-nonfree-tainted install -y "*-firmware"

# 4. Install Essential Packages
echo "Installing specified packages..."
sudo dnf install -y \
  java-21-openjdk \
  java-21-openjdk-devel \
  python3.11 \
  git \
  gh \
  vlc \
  timeshift \
  gcc \
  gcc-c++ \
  fastfetch \
  make \
  cmake \
  wget \
  curl \
  thermald \
  gnome-tweaks \
  p7zip \
  p7zip-plugins \
  htop \
  btop \
  afetch

# 5. Install auto-cpufreq
echo "Installing auto-cpufreq..."
git clone https://github.com/AdnanHodzic/auto-cpufreq.git
cd auto-cpufreq
sudo ./auto-cpufreq-installer
cd ..
rm -rf auto-cpufreq

echo "Configuring auto-cpufreq..."
sudo cp ./auto-cpufreq.conf /etc/auto-cpufreq.conf

sudo auto-cpufreq --install

# 6. Install Brave Browser
echo "Installing Brave browser..."
curl -fsS https://dl.brave.com/install.sh | sh

# 7. Install Visual Studio Code
echo "Installing Visual Studio Code..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf check-update
sudo dnf install -y code

# 8. Uninstall Firefox
echo "Removing Firefox..."
sudo dnf remove -y firefox

# 9. Install Microsoft Fonts
echo "Installing Microsoft TrueType fonts..."
sudo dnf upgrade --refresh -y
sudo dnf install -y curl cabextract xorg-x11-font-utils fontconfig
sudo rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm


echo "==== Fedora Setup Complete ===="

echo "==== Rebooting the System ===="
sudo reboot now