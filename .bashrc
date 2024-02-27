set -o vi
# PS1='[\u@\h \W]\$ '
export HISTFILE=~/.histfile
export HISTSIZE=25000
export SAVEHIST=25000
export HISTCONTROL=ignorespace

HISTTIMEFORMAT="%F %T "

export BASH_SILENCE_DEPRECATION_WARNING=1

# Aliases
alias sshtu='ssh tdam-3090-tunel'
alias ssha='eval $(ssh-agent) && ssh-add'

alias l="ls -lh"
alias wl="watch -n 1 ls -lh"
alias vim="nvim"
# ----------------------
export PATH=/opt/homebrew/bin:$PATH
export PATH=$PATH:~/bin
# ----------------------

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/oleksandrkovalyk/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/oleksandrkovalyk/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/oleksandrkovalyk/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/oleksandrkovalyk/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# ~~~~~~~~~~~~~~~ Prompt ~~~~~~~~~~~~~~~~~~~~~~~~

# export GIT_PS1_SHOWDIRTYSTATE=1
# export GIT_PS1_SHOWSTASHSTATE=1
# export GIT_PS1_SHOWUNTRACKEDFILES=1
# # Explicitly unset color (default anyhow). Use 1 to set it.
# export GIT_PS1_SHOWCOLORHINTS=1
# export GIT_PS1_DESCRIBE_STYLE="branch"
# # export GIT_PS1_SHOWUPSTREAM="auto git"
# 
# # if [[ -f "$XDG_CONFIG_HOME/bash/gitprompt.sh" ]]; then
# # 	source "$XDG_CONFIG_HOME/bash/gitprompt.sh"
# # fi
# 
# # PROMPT_COMMAND='__git_ps1 "\u@\h:\W" " \n$ "'
# # colorized prompt
# PROMPT_COMMAND='__git_ps1 "\[\e[33m\]\u\[\e[0m\]@\[\e[34m\]\h\[\e[0m\]:\[\e[35m\]\W\[\e[0m\]" " \n$ "'

# The __git_ps1 function prompt is provided by the bash completion installed by brew. See https://github.com/mischavandenburg/dotfiles/issues/5

PROMPT_LONG=20
PROMPT_MAX=95
PROMPT_AT=@

__ps1() {
    local P='$' dir="${PWD##*/}" B countme short long double conda_env \
        r='\[\e[31m\]' g='\[\e[32m\]' h='\[\e[34m\]' \
        u='\[\e[33m\]' p='\[\e[34m\]' w='\[\e[35m\]' \
        b='\[\e[36m\]' x='\[\e[0m\]' 

    [[ $EUID == 0 ]] && P='#' && u=$r && p=$u  # If user is root, use # and change colors
    [[ $PWD = / ]] && dir=/
    [[ $PWD = "$HOME" ]] && dir='~'

    B=$(git branch --show-current 2>/dev/null)
    [[ $dir = "$B" ]] && B=.
    countme="$USER$PROMPT_AT$(hostname):$dir($B)\$ "
    bc="$b"
    [[ $B == master || $B == main ]] && b="$r"
    [[ -n "$B" ]] && B="$g($b$B$g)"
    
    # Add Conda Environment to the Prompt
    if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
        conda_env="$g[$bc$CONDA_DEFAULT_ENV$g]"  # Conda environment at the beginning in green
    else
        conda_env=""
    fi

    short="${conda_env} $u\u$g$PROMPT_AT$h\h$g:$w$dir$B$p$P$x "
    long="$g╔${conda_env} $u\u$g$PROMPT_AT$h\h$g:$w$dir$B\n$g╚$p$P$x "
    double="$g╔${conda_env} $u\u$g$PROMPT_AT$h\h$g:$w$dir\n$g║$B\n$g╚$p$P$x "

    if ((${#countme} + ${#conda_env} > PROMPT_MAX)); then
        PS1="$double"
    elif ((${#countme} + ${#conda_env} > PROMPT_LONG)); then
        PS1="$long"
    else
        PS1="$short"
    fi
}

PROMPT_COMMAND="__ps1"
. "$HOME/.cargo/env"
