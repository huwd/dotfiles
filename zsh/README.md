ZSH
===

YADR has some really great aliases and ideas.
but without knowing what they are in advance or knowing the pain poitn they solve it seems premature to add them.

So they're recorded here as TODO for evaluation.

Any that are liked will be included.
Any that are not will be removed.

Deal is nothing gets added unless I can commit it with an explaination of what it does and why i want it.

zsh-aliases.zsh
---------------

```zsh
# Global aliases
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g C='| wc -l'
alias -g H='| head'
alias -g L="| less"
alias -g N="| /dev/null"
alias -g S='| sort'
alias -g G='| grep' # now you can do: ls foo G something

# Functions
#
# (f)ind by (n)ame
# usage: fn foo
# to find all files containing 'foo' in the name
function fn() { ls **/*$1* }
```

zvm.zsh
-------

```zsh
# Use zmv, which is amazing
autoload -U zmv
alias zmv="noglob zmv -W"
```

> is zmv amazing? why, what does it do?

0_path.zsh
----------

```zsh
# path, the 0 in the filename causes this to load first

pathAppend() {
  # Only adds to the path if it's not already there
  if ! echo $PATH | egrep -q "(^|:)$1($|:)" ; then
    PATH=$PATH:$1
  fi
}

# Remove duplicate entries from PATH:
PATH=$(echo "$PATH" | awk -v RS=':' -v ORS=":" '!a[$1]++{if (NR > 1) printf ORS; printf $a[$1]}')

pathAppend "$HOME/.dotfiles/bin"
pathAppend "$HOME/.dotfiles/bin/dotfiles"
```

> Still not clear why i need the stuff in bin, plus it seems out of date

fasd.zsh
--------

```zsh
#
# only init if installed.
fasd_cache="$HOME/.fasd-init-bash"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  eval "$(fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install zsh-wcomp zsh-wcomp-install)" >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache


# jump to recently used items
alias a='fasd -a' # any
alias s='fasd -si' # show / search / select
alias d='fasd -d' # directory
alias f='fasd -f' # file
alias z='fasd_cd -d' # cd, same functionality as j in autojump
alias zz='fasd_cd -d -i' # interactive directory jump
```

> What is fasd, why do i need it?

vi-mode.zsh
-----------

```zsh
set -o vi
export EDITOR=vim
export VISUAL=vim
```

> Add this back in when you know what editors you want to commit to

key-bindings.zsh
----------------

```zsh
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Zle-Builtins
# http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Standard-Widgets

bindkey -v                                          # Use vi key bindings
bindkey '^r' history-incremental-search-backward    # [Ctrl-r] - Search backward incrementally for a specified string. The string may begin with ^ to anchor the search to the beginning of the line.

# emacs style
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

# Make numpad enter work
bindkey -s "^[Op" "0"
bindkey -s "^[Ol" "."
bindkey -s "^[OM" "^M"
```

> Might make sense... but i want to check i don't like the defaults first