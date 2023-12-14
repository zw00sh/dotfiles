# plugins
plugins=(
	z
	zsh-syntax-highlighting
	zsh-autosuggestions
	sudo
)

ZSH_THEME="robbyrussell"
LESS='-R --mouse --wheel-lines=3' # enable scrollwheel in less

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh
export PATH=$PATH:/home/kali/.local/bin

# aliases
alias sudo='sudo '	# https://askubuntu.com/questions/22037/aliases-not-available-when-using-sudo
if command -v grc &> /dev/null
then
	alias nmap='grc nmap'
	alias ping='grc ping'
	alias netstat='grc netstat'
	alias ps='grc ps'
fi

setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt
setopt sharehistory
setopt incappendhistory

WORDCHARS=${WORDCHARS//\/} # Don't consider certain characters part of the word

# hide EOL sign ('%')
PROMPT_EOL_MARK=""

# add some extra goodies to the robbyrussel theme
if [[ $ZSH_THEME -eq "robbyrussell" ]]
then
	TARGET='$(if [ -n "$target" ]; then echo "[%{$fg[magenta]%}$target%{$reset_color%}] "; fi)'
	PROMPT="%{$fg[cyan]%}%T%{$reset_color%} $TARGET$PROMPT "	# prepend target info if $target set
fi

# update target before printing the prompt
_update_target() {
    if [ "$?" -eq 0 ]; then
        eval "target=$(tmux showenv | grep "^target-$(tmux display-message -p '#I')=" | cut -d '=' -f2)"
    fi
}
if [[ -n "$TMUX" ]]; then
    add-zsh-hook preexec _update_target
    add-zsh-hook precmd _update_target
fi

# configure some key bindings
bindkey ' ' magic-space						# do history expansion on space
bindkey '^U' backward-kill-line					# ctrl + U
bindkey '^[[1;5C' forward-word					# ctrl + ->			(important)
bindkey '^[[1;5D' backward-word					# ctrl + <-			(important)
bindkey '^[[1~' beginning-of-line				# home
bindkey '^[[4~' end-of-line					# end
bindkey '^[[Z' undo						# shift + tab undo last action
bindkey '^ ' autosuggest-accept					# shift + space accept autosuggestion

# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=20000
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=40
ZSH_AUTOSUGGEST_HISTORY_IGNORE="?(#c250,)"		# limit history suggestions to 250 chars and less
setopt hist_expire_dups_first		# delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       		# ignore duplicated commands history list
setopt hist_ignore_space      		# ignore commands that start with space
setopt hist_verify            		# show command with history expansion to user before running it
setopt share_history          		# share command history data

# force zsh to show the complete history
alias history="history 0"

# configure `time` format
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

# Set GRC aliases
[[ -s "/etc/grc.zsh" ]] && source /etc/grc.zsh

# If not running interactively, do not do anything
[[ $- != *i* ]] && return

# Start tmux logging
[[ -n "$TMUX_PANE" ]] && [[ "$TMUX_PANE_AUTORUN" != "0" ]] && mkdir -p $HOME/logs/$(date '+%Y-%m-%d') && [[ -n "$(tmux show -Aq @autolog | grep 1)" ]] && ~/.tmux/plugins/tmux-logging/scripts/toggle_logging.sh

# Add a hook to save tmux session on exit
# trap '[[ ! -z "$TMUX" ]] && ~/.tmux/plugins/tmux-resurrect/scripts/save.sh &' EXIT
#
# Otherwise start tmux
#[[ -z "$TMUX" ]] && cd ~ && exec tmux new-session -As main
