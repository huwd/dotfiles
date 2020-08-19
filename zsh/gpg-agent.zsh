# Set SSH to use gpg-agent
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
 export SSH_AUTH_SOCK="~/.gnupg/S.gpg-agent.ssh"
fi

eval $(ssh-agent) &>/dev/null
ssh-add ~/.ssh/* &>/dev/null
