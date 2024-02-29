# Settings
set -o vi

# Exporting
export HISTFILE=~/.histfile
export HISTSIZE=25000
export SAVEHIST=25000
export HISTCONTROL=ignorespace
export BASH_SILENCE_DEPRECATION_WARNING=1
if [[ $(uname) == "Darwin" ]]; then
    export DBUS_SESSION_BUS_ADDRESS="unix:path=$DBUS_LAUNCHD_SESSION_BUS_SOCKET" 
    export PATH=/opt/homebrew/bin:$PATH
    export PATH=$PATH:~/bin
fi

# Misc
HISTTIMEFORMAT="%F %T "
PROMPT_LONG=20
PROMPT_MAX=95
PROMPT_AT=@

# Aliases
alias l="ls -lh"
alias wl="watch -n 1 ls -lh"
alias vim="nvim"

if [[ $(uname) == "Darwin" ]]; then
    alias sshtu='ssh tdam-3090-tunel'
    alias ssha='eval $(ssh-agent) && ssh-add'

    alias cdupct="cd /Users/oleksandrkovalyk/Library/CloudStorage/OneDrive-UniversidadPolitécnicadeCartagena"
    alias cdic="cd /Users/oleksandrkovalyk/Library/Mobile\ Documents/com~apple~CloudDocs"
    alias cdr="cd /Users/oleksandrkovalyk/Library/CloudStorage/"
fi

# Aliases for project loading
alias cda="cd /Users/oleksandrkovalyk/Library/CloudStorage/OneDrive-UniversidadPolitécnicadeCartagena/Escritorio/PAPILA_articles/RIF_clinical_paper/Elsevier_git/"

if [[ $(uname) == "Darwin" ]]; then
    # Conda
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
fi
# Prompt function
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

    if [[ $(uname) == "Darwin" ]]; then
        PS1="${conda_env} $u\u$g$PROMPT_AT$h\h$g:$w$dir$B$p$P$x "
    else
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
    fi
}

PROMPT_COMMAND="__ps1"

if [[ $(uname) == "Darwin" ]]; then
    . "$HOME/.cargo/env"
fi
