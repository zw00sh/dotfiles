# plugins
plugins=(
	z
	zsh-syntax-highlighting
	zsh-autosuggestions
	sudo
	dirhistory
)

ZSH_THEME="robbyrussell"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# aliases
alias sudo='sudo '	# https://askubuntu.com/questions/22037/aliases-not-available-when-using-sudo
if command -v grc &> /dev/null
then
	alias nmap='grc nmap'
	alias ping='grc ping'
	alias netstat='grc netstat'
	alias ps='grc ps'
fi
alias venv='python3 -m venv'

setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt

WORDCHARS=${WORDCHARS//\/} # Don't consider certain characters part of the word

# hide EOL sign ('%')
PROMPT_EOL_MARK=""

# add some extra goodies to the robbyrussel theme
if [[ $ZSH_THEME -eq "robbyrussell" ]]
then
	TARGET='$(if [ -n "$target" ]; then echo "[%{$fg[magenta]%}$target%{$reset_color%}] "; fi)'
	PROMPT="%{$fg[cyan]%}%T%{$reset_color%} $TARGET$PROMPT "	# prepend target info if $target set
fi

# configure key keybindings
bindkey ' ' magic-space							# do history expansion on space
bindkey '^U' backward-kill-line					# ctrl + U
bindkey '^[[1;5C' forward-word					# ctrl + ->			(important)
bindkey '^[[1;5D' backward-word					# ctrl + <-			(important)
bindkey '^H' backward-kill-word					# ctrl + backspace	(important)
bindkey '^[[3;5~' kill-word						# ctrl + Supr
bindkey '^[[3~' delete-char						# delete
bindkey '^[[1~' beginning-of-line				# home
bindkey '^[[4~' end-of-line						# end
bindkey '^[[Z' undo								# shift + tab undo last action
bindkey '^ ' autosuggest-accept					# shift + space accept autosuggestion

# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=20000
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=40
ZSH_AUTOSUGGEST_HISTORY_IGNORE="?(#c100,)"		# limit history suggestions to 100 chars and less

setopt hist_expire_dups_first		# delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       		# ignore duplicated commands history list
setopt hist_ignore_space      		# ignore commands that start with space
setopt hist_verify            		# show command with history expansion to user before running it
setopt share_history          		# share command history data

# force zsh to show the complete history
alias history="history 0"

# configure `time` format
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

# The following block is surrounded by two delimiters.
# These delimiters must not be modified. Thanks.
# START KALI CONFIG VARIABLES
PROMPT_ALTERNATIVE=twoline
NEWLINE_BEFORE_PROMPT=no
# STOP KALI CONFIG VARIABLES

# add .local to PATH
#export PATH="$PATH:/home/zach/.local/bin/"
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# tmux: ctrl+n to create a new session named after a target
function create_target_session() {
	tmux command-prompt -Fp 'Target:' "run-shell -bC 'new-session -e \"target\"=\"%1\" -s \"%1\""
}
zle -N create_target_session
bindkey '^N' create_target_session

# Set GRC aliases
[[ -s "/etc/grc.zsh" ]] && source /etc/grc.zsh

# If not running interactively, do not do anything
[[ $- != *i* ]] && return
# Otherwise start tmux
[[ -z "$TMUX" ]] && cd ~ && exec tmux new-session -As main
#[[ -z "$TMUX" ]] && exec tmux new-session
