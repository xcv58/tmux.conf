#!/bin/zsh
#
SCRIPT_FILE=$0
SCRIPT_PATH=$(dirname $SCRIPT_FILE)
cd ${SCRIPT_PATH}

unamestr=`uname`
if [ "$unamestr" = 'Darwin' ]; then
    lnCommand="ln -hf"
    command -v reattach-to-user-namespace >/dev/null 2>&1 || brew install reattach-to-user-namespace
else
    lnCommand="ln -Pf"
fi

for config_file in ${PWD}/*.conf; do
    link_command="${lnCommand} ${config_file} ${HOME}/.${config_file:t}"
    echo ${link_command}
    eval ${link_command}
done

link_command="ln -sf ${PWD}/tmux.start.sh /usr/local/bin/t"
echo ${link_command}
eval ${link_command}

link_command="ln ${PWD}/tmux ${HOME}/.tmux"
echo ${link_command}
eval ${link_command}
