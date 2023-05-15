#!/bin/bash

FMT_GREEN=$(printf '\033[32m')
FMT_RESET=$(printf '\033[0m')

echo "[*] ${FMT_GREEN}Installing pre-requisites (tmux, zsh, grc, git, curl, xsel)${FMT_RESET}"
sudo apt update && sudo apt install tmux zsh grc git curl xsel -y || exit 1

echo "[*] ${FMT_GREEN}Installing oh-my-zsh and plugins${FMT_RESET}"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo "[*] ${FMT_GREEN}Changing the default shell to zsh${FMT_RESET}"
chsh -s $(which zsh) "$USER"

echo "[*] ${FMT_GREEN}Overwriting ~/.zshrc and ~/.tmux.conf with remote copies${FMT_RESET}"
curl -fsSL "https://raw.githubusercontent.com/zw00sh/dotfiles/main/.zshrc" > ~/.zshrc
curl -fsSL "https://raw.githubusercontent.com/zw00sh/dotfiles/main/.tmux.conf" > ~/.tmux.conf

echo "[*] ${FMT_GREEN}Installing FiraCode Nerd Font for tmux theme${FMT_RESET}"
mkdir ~/.fonts/ && curl -fsSL "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/FiraCodeNerdFont-Regular.ttf" > ~/.fonts/FiraCodeNerdFont-Regular.ttf

echo "[*] ${FMT_GREEN}Installing tmux plugins${FMT_RESET}"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux source ~/.tmux.conf
~/.tmux/plugins/tpm/bin/install_plugins

echo "[*] ${FMT_GREEN}Configuring tmux to use zsh by default${FMT_RESET}"
echo "set -g default-shell $(which zsh)" >> ~/.tmux.conf

echo "[*] ${FMT_GREEN}Reloading zsh${FMT_RESET}"
zsh -c "source ~/.zshrc" && zsh
