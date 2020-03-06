# Get operating system
platform='unknown'
unamestr=$(uname)
if [[ $unamestr == 'Linux' ]]; then
  platform='linux'
elif [[ $unamestr == 'Darwin' ]]; then
  platform='darwin'
fi

if [[ $platform == 'linux' ]]; then
  source $HOME/.asdf/asdf.sh
elif [[ $platform == 'darwin' ]]; then
  source $(brew --prefix asdf)/asdf.sh
fi
