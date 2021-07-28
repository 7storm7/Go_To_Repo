#!/bin/bash
  
# Go from your current folder up to the directory where file/folder with 
# the name given in argument $1 exists. 
# Similar effect with croot function defined in <android>/build/envsetup.sh. 
# But it only goes up to the top of the aosp repo tree.
#
# Ref: https://unix.stackexchange.com/a/13474

function __search_backward(){
    local current_dir_name=${PWD##*/}
#    echo ">Current dir: $current_dir_name"
#    echo ">Base dir: $2"
    test "$current_dir_name" == "$2" && echo "$1: Not found!!" && return || test -e "$1" && echo "found: " "$PWD" && return || cd .. && __search_backward "$1" "$2"
}

function upsearch () {
    base_dir_name=$(echo "$(dirs +0)"| cut -d "/" -f2)
    __search_backward $1 $base_dir_name
}
