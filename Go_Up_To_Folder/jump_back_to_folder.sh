#!/bin/bash
  
# Go from your current folder up to the directory where file/folder with 
# the name given in argument $1 exists. 
# Similar effect with croot function defined in <android>/build/envsetup.sh. 
# But it only goes up to the top of the aosp repo tree.
#
# Ref: https://unix.stackexchange.com/a/13474

function __usage()
{
cat << EOF
usage: cdup <folder name>
-c    | --containing-folder      (Optional)     Go to containing folder
-s    | --silent                 (Optional)     Go to folder without confirmation
-h    | --help                                  Brings up this menu
EOF
return 0
}

function __upsearch () {
  found=""
  slashes=${PWD//[^\/]/}
  directory="$PWD"

  for (( n=${#slashes}; n>0; --n ))
  do
    test -d "$directory/$1" && found="$directory" && break
    directory="$directory/.."
  done
  echo $found
}

function __ask_for_permission ()
{
    read -p "Are you sure? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "y"
        # do dangerous stuff
    fi
    echo ""
}


function cdup () {
    local target_folder
    local containing_folder
    local silent
    while [ "$1" != "" ]; do
        case $1 in
            -c | --containing-folder )
                containing_folder=1
                shift # Shift to next word after space to get service name
            ;;
            -s | --silent )
                silent=1
                shift
            ;;
            -h | --help )
                __usage
                return
            ;;
            * )
                [[ -z $target_folder ]] && target_folder="$1";
                shift
        esac
    done

    found=$(__upsearch $target_folder)
    [[ ! -z $found ]] && { [[ -z $containing_folder ]] && found="$found/$target_folder"; }
    [[ -z $found ]] && echo "Not found!!" && return
    [[ -z $silent ]] && { [ "$(__ask_for_permission)" == "y" ] && cd $found; } || cd $found
    return
}
