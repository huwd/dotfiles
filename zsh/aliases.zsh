# Aliases in this file are bash and zsh compatible

# Don't change. The following determines where dotfiles is installed.
dotfiles=$HOME/.dotfiles

# Get operating system
platform='unknown'
unamestr=$(uname)
if [[ $unamestr == 'Linux' ]]; then
  platform='linux'
elif [[ $unamestr == 'Darwin' ]]; then
  platform='darwin'
fi

# Show human friendly numbers and colors
alias df='df -h'
alias du='du -h -d 2'

