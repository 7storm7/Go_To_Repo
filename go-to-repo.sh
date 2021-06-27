#!/bin/bash
#set -xv

ask_for_path_option_in_macos()
{
    COMMAND='osascript'
    if ! command -v $COMMAND &> /dev/null
    then
        echo "Command not found!!"
        exit
    fi

    repo_paths=$1
# echo ">>> Script started..."

# About assigning output of a heredoc value:
# https://stackoverflow.com/questions/1167746/how-to-assign-a-heredoc-value-to-a-variable-in-bash
    selected_path=`osascript <<-APPLESCRIPT
        if "$@" is "" then -- use args array
            set arg_list to "$(printf '%s\n' "${repo_paths[@]}")"
            log (count of arg_list)
            log (arg_list)

        else -- use cli arguments
            set arg_list to "$(printf '%s\n' "$@")"
        end if

        set AppleScript's text item delimiters to ","
        set theList to every text item of (arg_list)
        set selected to {choose from list theList}

        return selected
APPLESCRIPT -- this should be at the beginning of line
`
    # echo ">>> Script ended..."
    echo $selected_path
}


ask_for_path_option_in_linux()
{
    echo "TBD"

    # OPTIONS=(1 "Option 1"
    #         2 "Option 2"
    #         3 "Option 3")

    # choice=$(dialog --clear \
    #                 --backtitle "$BACKTITLE" \
    #                 --title "$TITLE" \
    #                 --menu "$MENU" \
    #                 $HEIGHT $WIDTH $CHOICE_HEIGHT \
    #                 "${OPTIONS[@]}" \
    #                 2>&1 >/dev/tty)

    # echo choice
}

ask_for_path_option()
{
    if [ -z "$1" ]
    then
        echo "No repo name supplied."
        echo -e "\nUsage: $0 <repo name> \n"
        exit
    fi

    if [[ $(uname -s) -eq "Darwin" ]]
    then
        echo $(ask_for_path_option_in_macos $1)
    else
        echo $(ask_for_path_option_in_linux $1)
    fi
}


# Main Function

repo_name=$1

REPO_MANIFESTS_RELATIVE_PATH=".repo/manifests/"

if ! cd $REPO_MANIFESTS_RELATIVE_PATH ; then
    echo "Failed to enter folder ${REPO_MANIFESTS_RELATIVE_PATH}"
    echo "Make sure you are in correct location in aosp that contains .repo folder."
    echo "Aborting"
    exit 1
fi

# For replacing spaces with commas: https://unix.stackexchange.com/questions/338116/turning-separate-lines-into-a-comma-separated-list-with-quoted-entries
repo_path=$(grep -R "$repo_name" .  |  sed 's/.*path="//; s/" .*//' | paste -sd, -)
echo "Going to " $repo_path " ..."

path=$(ask_for_path_option $repo_path)

cd -  > /dev/null 2>&1
cd $path
exec $SHELL

