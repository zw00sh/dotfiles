Includes configuration files for tmux and zsh. Installs:
- Zsh with oh-my-zsh, including syntax highlighting and autosuggestion plugins, and grc for colorisation
- `prefix+n` to name a new session. The session name is available within zsh as `$target`. Rename with `prefix+$`
- tmux logging can be enabled per-pane with `prefix+shift+p` or enabled for an entire session with `prefix+a` (`prefix+shift+a` to disable)
- tmux session saving whenever a zsh exits

# Kali Installation
Please backup your `~/.zshrc` and `~/.tmux.conf`  before running.
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zw00sh/dotfiles/main/setup.sh)"
```
