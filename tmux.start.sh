#!/bin/bash
export PATH=$PATH:/usr/local/bin

# abort if we're already inside a TMUX session
[ "$TMUX" == "" ] || exit 0

create() {
  tmux new -s "$1" -d
  tmux split-window -v
  tmux neww
  tmux split-window -v
  tmux select-window -t 1
  tmux select-pane -t 1
}

connect() {
  tmux attach-session -t "${@//-/ }"
  exit
}

contains() {
  for i in "${options[@]}"
  do
    if [[ ${1} == "${i}" ]]; then
      return 0
    fi
  done
  return 1
}

connect_or_default() {
  # shellcheck disable=SC2015
  contains "$1" && connect "$1" || connect "${options[0]}"
}

DEFAULT=_default
# startup a "default" session if none currently exists
tmux has-session -t "$DEFAULT" || create "$DEFAULT"

# shellcheck disable=SC2046
read -r -a options <<< $(tmux list-sessions -F '#S' | sed -e 's/ /-/g')
if [[ $# -gt 0 ]]; then
  argument="${*}"
  argument=${argument// /-}
  contains "${argument}" && connect "${argument}"
  # shellcheck disable=SC2015
  connect_or_default "${options[$argument]}"
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
      read -r -p "Enter new session name: " SESSION_NAME
      create "$SESSION_NAME"
      connect "$SESSION_NAME"
      break;;
    "zsh")
      zsh --login
      break;;
    *)
      connect_or_default "${opt}"
      break;;
  esac
done
