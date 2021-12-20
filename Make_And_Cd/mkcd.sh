#!/bin/bash

# Script used to create and cd to a path
# which is provided as $1
# Arguments: $1 - path to a file. 

function __usage_of_mkcd()
{
cat << EOF
usage: mdcd <folder/path to be created>
-h    | --help      Brings up this usage info
EOF
return 0
}

function mkcd() {
    if [ $# -eq 0 ]
    then
        __usage_of_mkcd
        return 0
    fi
    mkdir -pv $1 && cd $1
}
