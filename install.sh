#!/bin/sh
command -v git >/dev/null 2>&1 || { echo >&2 "I require git but it's not installed.  Aborting."; exit 1; }
command -v rake >/dev/null 2>&1 || { echo >&2 "I require rake but it's not installed.  Aborting."; exit 1; }

if [ ! -d "$HOME/.dotfiles" ]; then
    echo "Installing Dotfiles for the first time"
    git clone --depth=1 https://github.com/huwd/dotfiles.git "$HOME/.dotfiles"
    cd "$HOME/.dotfiles"
    [ "$1" = "ask" ] && export ASK="true"
    rake install
else
    echo "Dotfiles are already installed"
fi
