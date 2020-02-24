TMUX
===

YADR has some really great aliases and ideas.
but without knowing what they are in advance or knowing the pain poitn they solve it seems premature to add them.

So they're recorded here as TODO for evaluation.

Any that are liked will be included.
Any that are not will be removed.

Deal is nothing gets added unless I can commit it with an explaination of what it does and why i want it.

```zsh
## Need to work out why i added this setting in an old config
tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
      "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
      "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"
```
