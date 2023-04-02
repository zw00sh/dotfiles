#!/bin/bash

FMT_GREEN=$(printf '\033[32m')
FMT_RESET=$(printf '\033[0m')

echo "[*] ${FMT_GREEN}Installing pre-requisites (tmux, zsh, grc, git, curl)${FMT_RESET}"
sudo apt update && sudo apt install tmux zsh grc git curl -y || exit 1

echo "[*] ${FMT_GREEN}Installing oh-my-zsh and plugins${FMT_RESET}"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
echo "[*] ${FMT_GREEN}Changing the default shell to zsh${FMT_RESET}"
chsh -s $(which zsh) "$USER"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo "[*] ${FMT_GREEN}Overwriting ~/.zshrc, ~/.tmux.conf, ~/.grc/grc.conf with remote copies${FMT_RESET}"
curl -fsSL "https://raw.githubusercontent.com/zw00sh/dotfiles/main/.zshrc" > ~/.zshrc
curl -fsSL "https://raw.githubusercontent.com/zw00sh/dotfiles/main/.tmux.conf" > ~/.tmux.conf
mkdir ~/.grc/
curl -fsSL "https://raw.githubusercontent.com/zw00sh/dotfiles/main/.grc/grc.conf" > ~/.grc/grc.conf

echo "[*] ${FMT_GREEN}Reloading zsh${FMT_RESET}"
zsh -c "source ~/.zshrc"

echo "[*] ${FMT_GREEN}Installing tmux plugins${FMT_RESET}"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux source ~/.tmux.conf
~/.tmux/plugins/tpm/bin/install_plugins

echo "[*] ${FMT_GREEN}Reloading zsh${FMT_RESET}"
zsh -c "source ~/.zshrc" && zsh
