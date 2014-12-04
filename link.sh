#!/bin/bash
for config_file in $(find . -name "*.conf"); do
    home_file=${HOME}/$(echo ${config_file} | sed -e "s/^.\//./g")
    echo "ln -hf ${PWD}${config_file:1} ${home_file}"
    ln -hf ${PWD}${config_file:1} ${home_file}
done
