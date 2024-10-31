# Settings
set -o vi
export EDITOR=nvim
# Exporting
export HISTFILE=~/.histfile
export HISTSIZE=25000
export SAVEHIST=25000
export HISTCONTROL=ignorespace
export BASH_SILENCE_DEPRECATION_WARNING=1
# export BASH_COMPLETION_DEBUG=true
# Export PATHs
export PATH=$PATH:~/bin
if [[ $(uname) == "Darwin" ]]; then
    export DBUS_SESSION_BUS_ADDRESS="unix:path=$DBUS_LAUNCHD_SESSION_BUS_SOCKET" 
    export PATH=/opt/homebrew/bin:$PATH
    export PATH=$PATH:$HOME/go/bin/
    # export PATH="/usr/local/bin:$PATH"
fi

# Aliases
alias l='ls -lhaFS'
alias wl='watch -n 1 ls -lh'
alias v='nvim'
alias vf='nvim $(fzf)'
alias ctop='TERM="${TERM/#tmux/screen}" ctop'

# fzf
export FD_OPTIONS="--follow --exclude .git --exclude node_modules"
export FZF_DEFAULT_OPTS="--no-mouse --height 50% --reverse --border --multi --inline-info --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -300' --preview-window='right:hidden:wrap' --bind='f3:execute(bat --style=numbers {} || less -f {}),f2:toggle-preview,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-a:select-all+accept,ctrl-y:execute-silent(echo {+} | pbcopy)'"
export FZF_DEFAULT_COMMAND="git ls-files --cached --others --exclude-standard | fd --type f --type l $FD_OPTIONS"
export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS"
export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS"

# bat
export BAT_PAGER="less -R"

# Eval
# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"

# git 
source ~/dotfiles/.git-prompt.sh

# Misc
HISTTIMEFORMAT="%F %T "
PROMPT_LONG=20
PROMPT_MAX=95
PROMPT_AT=@


if [[ $(uname) == "Darwin" ]]; then
    alias ssha='eval $(ssh-agent) && ssh-add'
    alias cdupct="cd $HOME/Library/CloudStorage/OneDrive-UniversidadPolitécnicadeCartagena"
    alias cdic="cd $HOME/Library/Mobile\ Documents/com~apple~CloudDocs"
    alias cdr="cd $HOME/Library/CloudStorage/"
    # Aliases for project loading
    alias cda="cd $HOME/Library/CloudStorage/OneDrive-UniversidadPolitécnicadeCartagena/Escritorio/PAPILA_articles/RIF_clinical_paper/Elsevier_git/"
    alias cdo="cd $HOME/external_brain/"
    alias cw="cd $HOME/workspace/"

    # Bash completion
    [[ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]] && . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
    # pomo complete
    complete -C pomo pomo

# Ubuntu stuff
# elif [[ $(grep -E "^(ID|NAME)=" /etc/os-release | grep -q "ubuntu")$? == 0 ]]; then

#     alias k9s="/snap/k9s/current/bin/k9s"
#     # kubectl autocompletion
#     source <(kubectl completion bash)
fi

if [[ $(uname) == "Darwin" ]]; then
    # Conda
    __conda_setup="$("$HOME/miniconda3/bin/conda" 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
            . "$HOME/miniconda3/etc/profile.d/conda.sh"
        else
            export PATH="$HOME/miniconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup

fi

####################################################################################################
# Prompt function
#      ✓ ✗
####################################################################################################

function __failed_cmd {
    if [[ $? -eq 0 ]]; then
        printf "\033[32m✓"
    else
        printf "\033[31m✗"
    fi
}

GREEN="\[\033[32m\]"
BLUE="\[\033[34m\]"
MAGENTA="\[\033[35m\] "
RESET="\[\033[0m\]"
RED="\[\033[31m\]"


if [[ $(uname) == "Darwin" ]]; then
    PS1=" "
else
    PS1=" "
fi
# PS1=" "
PS1+="${GREEN}\u[\h]"
PS1+="${BLUE}  \w"
PS1+="${MAGENTA}\$(__git_ps1 '(%s )')\n"
PS1+='$(__failed_cmd) '
PS1+="${RESET}"
