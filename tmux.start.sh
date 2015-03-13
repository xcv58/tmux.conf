#!/bin/bash
export PATH=$PATH:/usr/local/bin

# abort if we're already inside a TMUX session
[ "$TMUX" == "" ] || exit 0

# startup a "default" session if none currently exists
tmux has-session -t _default || tmux new-session -s _default -d

connect() {
    tmux attach-session -t ${@}
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

# present menu for user to choose which workspace to open
PS3="Please choose your session: "
options=($(tmux list-sessions -F "#S") "NEW SESSION" "zsh")

if [[ $# > 0 ]]; then
    contains ${*} && connect ${opt} || connect ${options[0]}
    exit
fi

echo "Available sessions"
echo "------------------"
echo " "
select opt in "${options[@]}"
do
    case ${opt} in
        "NEW SESSION")
            read -p "Enter new session name: " SESSION_NAME
            tmux new -s "$SESSION_NAME"
            break
            ;;
        "zsh")
            zsh --login
            break;;
        *)
            contains ${opt} &&
                connect ${opt} || connect ${options[0]}
            break
            ;;
    esac
done
