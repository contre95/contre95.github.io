#!/usr/bin/env nix-shell
#!nix-shell -i bash -p git gnupg vim

echo "
Remember to:
1. Create the machines/<machine_name>.nix and add machine to configuration.nixi
2. Have your GPG smart card connected.
3. Have interenet connection "
sleep 3 &&
read -r -p  "Enter machine name: " MACHINE &&
sudo rm -rf /home/canus &&
sudo mkdir /home/canus &&
sudo chown contre /home/canus &&
pushd /home/canus/ &&
gpg --import <(curl https://github.com/contre95.gpg)  &&
gpg --card-status &&
git config --global user.email lucascontre95@gmail.com
git clone https://github.com/contre95/.dotfiles.git /home/canus/ &&
echo "{ pkgs, ... }:{}" > "/home/canus/dotfiles/nixos/machines/$MACHINE.nix".
git remote -v &&
git remote set-url origin git@github.com:contre95/.dotfiles.git
# Backup /etc/nixos
sudo cp /etc/nixos/hardware-configuration.nix /home/contre && \
sudo rm -rf /etc/nixos/ && sudo mkdir /etc/nixos && \
sudo find /home/canus/dotfiles/nixos/ -mindepth 1 -maxdepth 1 -exec ln -vs "{}" /etc/nixos ';'
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz home-manager  && \
sudo nix-channel --add https://nixos.org/channels/nixos-25.05 nixos  && \
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable  && \
sudo cp /home/contre/hardware-configuration.nix /etc/nixos/hardware-configuration.nix && \
sudo WHICH_MACHINE="$MACHINE" nixos-rebuild switch --upgrade

