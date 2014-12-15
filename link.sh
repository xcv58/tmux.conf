#!/bin/bash
unamestr=`uname`
if [ "$unamestr" = 'Darwin' ]; then
    lnCommand="ln -hf"
else
    lnCommand="ln -Pf"
fi
for config_file in $(find . -name "*.conf"); do
    home_file=${HOME}/$(echo ${config_file} | sed -e "s/^.\//./g")
    echo "${lnCommand} ${PWD}${config_file:1} ${home_file}"
    ${lnCommand} ${PWD}${config_file:1} ${home_file}
done
