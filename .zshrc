if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
fi

#HISTORY
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000 
setopt SHARE_HISTORY  #share history across all open terminals 
setopt HIST_IGNORE_DUPS  # don't store immediate duplicate
setopt HIST_IGNORE_SPACE # commands starting with space aren't recorded
setopt GLOB_STAR_SHORT

autoload -Uz compinit
compinit

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 


# Source custom alias files if you keep them separate
[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases
[ -f ~/.bash_aliases ] && source ~/.bash_aliases

alias claude-personal='CLAUDE_CONFIG_DIR=$HOME/.claude-personal claude'
alias claude-work='CLAUDE_CONFIG_DIR=$HOME/.claude-work claude'
alias ls='eza --icons --color=always --group-directories-first'
alias la='eza -a --icons --color=always --group-directories-first'
alias ll='eza -l --icons --color=always --group-directories-first'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(fc -ln -1 | sed -e '\''s/^\s*//;s/[;&|]\s*alert$//'\'')"'
alias cd='z'

# Grep colors
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
# if [ "$(tty)" = "/dev/tty1" ] ;
# then
# 	exec start-hyprland
# fi

export PATH="$HOME/.local/npm/bin:$PATH"
