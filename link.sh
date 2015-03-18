#!/bin/bash
unamestr=`uname`
if [ "$unamestr" = 'Darwin' ]; then
    lnCommand="ln -hf"
    command -v reattach-to-user-namespace >/dev/null 2>&1 || brew install reattach-to-user-namespace
else
    lnCommand="ln -Pf"
fi
for config_file in $(find . -name "*.conf"); do
    home_file=${HOME}/$(echo ${config_file} | sed -e "s/^.\//./g")
    echo "${lnCommand} ${PWD}${config_file:1} ${home_file}"
    ${lnCommand} ${PWD}${config_file:1} ${home_file}
done
