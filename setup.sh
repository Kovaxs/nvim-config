#!/bin/bash

# Specify the Git repository URL
GIT_REPO_URL="your_git_repo_url_here"

# The directory where the Git repository will be cloned
DOTFILES_DIR="$HOME/dotfiles"

# Clone the Git repository
if [ ! -d "$DOTFILES_DIR" ]; then
    git clone $GIT_REPO_URL $DOTFILES_DIR
else
    echo "Dotfiles directory already exists. Skipping cloning."
fi

curl -o ~/dotfiles/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

# Creating symbolic links
ln -sf "$DOTFILES_DIR/.alacritty.toml" "$HOME/.alacritty.toml"
ln -sf "$DOTFILES_DIR/.bash_profile" "$HOME/.bash_profile"
ln -sf "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
ln -sf "$DOTFILES_DIR/.condarc" "$HOME/.condarc"
ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"
ln -s /Users/kovaxs/dotfiles/nix ~/nix

echo "All dotfiles have been linked."
