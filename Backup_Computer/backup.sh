#!/usr/local/bin/bash
#set -xv

# backup_config is the config file used by backup.sh that 
# should contain path - file name pairs with the following format: 
# path<SPACE>file_name 
DEFAULT_CONFIG_FILE_PATH="/Users/storm/Desktop/backup_config"
DEFAULT_BACKUP_FOLDER="/tmp"

script_name=$0

function usage {
    echo "usage: $script_name [backup full path] [backup config file full path]"
    echo "  Default backup full path            : $DEFAULT_BACKUP_FOLDER"
    echo "  Default backup config file full path: $DEFAULT_CONFIG_FILE_PATH"
    exit 1
}

function prepare_backup_location(){
    folder_name=$(date +"%m_%d_%Y-%H%M%S")
    backup_folder=$backup_folder/$folder_name
    echo "Backing up to $backup_folder"
    mkdir $backup_folder
}

function prepare_list_of_sources_to_backup(){
    declare -n ref=$1
    ref["/Users/storm"]=".bash_profile"
    ref["/blah/blah"]="blah.blah" 
}

function prepare_list_of_sources_to_backup_from_config(){
    declare -n ref=$1

    while read path file_name
    do
        [ -n "$path" ] && ref["$path"]="$file_name"       # Put a value into an associative array
    done < $config_file
}

function does_user_want_to_backup_folder(){
    local folder=$1

    echo "Do you still want to backup the whole folder?"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) return 1;;
            No ) return 0;;
        esac
    done
}

function backup_files(){
    declare -n files_to_backup=$1

    for path in "${!files_to_backup[@]}"
    do
        echo "Path: $path"
        echo "File: ${files_to_backup[$path]}"
        
        if [ ! -d $path ]; then 
            echo "[Warning] Folder $path doesn't exist!"
            continue 
        fi        

        if [ "*" == "${files_to_backup[$path]}" ]; then
            folder_content_size=$(du -skh $path | cut -f1)
            echo "Size of folder: $folder_content_size"
            if [ "$(does_user_want_to_backup_folder)" == "0" ]; then 
                continue 
            fi
            cp -a $path $backup_folder
        else
            if [ ! -f $path/${files_to_backup[$path]} ]; then 
                echo "[Warning] File ${files_to_backup[$path]} doesn't exist!"
                continue 
            fi
            cp $path/${files_to_backup[$path]} $backup_folder
        fi
    done
}

###################################################
# MAIN

config_file=$DEFAULT_CONFIG_FILE_PATH
backup_folder=$DEFAULT_BACKUP_FOLDER

# Backup folder argument content check
if [ -n "$1" ]; then
  backup_folder="$1"
else
  echo "Using default backup folder: $backup_folder"
fi

# Config file argument content check
if [ -n "$2" ]; then
  config_file="$2"
else
  echo "Using default config file path: $config_file"
fi

[ ! -f $config_file ] &&  { echo "[Error] Config file doesn't exist!"; usage; exit 1; }

prepare_backup_location

declare -A my_list # Create an associative array
# prepare_list_of_sources_to_backup my_list 
prepare_list_of_sources_to_backup_from_config my_list
backup_files my_list
