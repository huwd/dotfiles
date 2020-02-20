#!/bin/sh

if [ ! -d "$HOME/.dotfiles" ]; then
    echo "Installing Dotfiles for the first time"
    git clone --depth=1 https://github.com/huwd/dotfiles.git "$HOME/.dotfiles"
    cd "$HOME/.dotfiles"
    [ "$1" = "ask" ] && export ASK="true"
    rake install
else
    echo "Dotfiles are already installed"
fi
