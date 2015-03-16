#!/bin/bash
export PATH=$PATH:/usr/local/bin

# abort if we're already inside a TMUX session
[ "$TMUX" == "" ] || exit 0

# startup a "default" session if none currently exists
tmux has-session -t _default || tmux new-session -s _default -d

connect() {
    tmux attach-session -t "${@//-/ }"
    exit
}

contains() {
    for i in ${options[@]}
    do
        if [[ ${1} == ${i} ]]; then
            return 0
        fi
    done
    return 1
}

options=($(tmux list-sessions -F "#S" | sed -e "s/ /-/g"))
if [[ $# > 0 ]]; then
    argument=$(echo ${*})
    argument=${argument// /-}
    contains ${argument} && connect ${argument} || echo ${argument}
            contains ${options[$argument]} && connect ${options[$argument]} || connect ${options[0]}
    exit
fi

# present menu for user to choose which workspace to open
PS3="Please choose your session: "

options+=("NEW SESSION" "zsh")

echo "Available sessions"
echo "------------------"
echo " "
select opt in "${options[@]}"
do
    case ${opt} in
        "NEW SESSION")
            read -p "Enter new session name: " SESSION_NAME
            tmux new -s "$SESSION_NAME"
            break;;
        "zsh")
            zsh --login
            break;;
        *)
            contains ${opt} && connect ${opt} || connect ${options[0]}
            break;;
    esac
done
