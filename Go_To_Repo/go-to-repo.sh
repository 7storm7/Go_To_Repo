#!/bin/bash
#set -xv

ask_for_path_option_in_macos_gui()
{
    local COMMAND='osascript'
    if ! command -v $COMMAND &> /dev/null
    then
        echo "GUI command not found." >&2
        return 0
    fi

    repo_paths=$1

    # About assigning output of a heredoc value:
    # https://stackoverflow.com/questions/1167746/how-to-assign-a-heredoc-value-to-a-variable-in-bash
    local selected_path=`osascript <<-APPLESCRIPT
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
APPLESCRIPT -- Important: This should be at the beginning of line
`
    echo $selected_path
}


ask_for_path_option_in_linux_gui()
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

ask_for_path_option_in_commadline()
{
    local paths=($(echo $1 | tr "," "\n"))

    # Use variable content as multiple case condition by using Extended Globbing
    # Ref: https://unix.stackexchange.com/questions/234264/how-can-i-use-a-variable-as-a-case-condition
    shopt -s extglob
    local valid_cases=$(echo $1 | tr "," "|")
    local valid_cases='@('$valid_cases')'

    # >&2 : Redirect the variable content to standard output instead of being captured as return of the function
    echo  "Valid options:" $valid_cases>&2

    PS3='Choose the path (0: Exit): '
    select path in "${paths[@]}"; do
        case $path in
            $valid_cases)
                echo "Americans eat roughly 100 acres of $path each day!">&2
                echo $path
                break;
                ;;
            "0")
                echo "Exiting as requested..."
                exit
                ;;
            *) echo "Invalid option $REPLY">&2;;
        esac
    done
}

ask_for_path_option()
{
    if [ -z "$1" ]
    then
        echo "No repo name supplied."
        echo -e "\nUsage: $0 <repo name> \n"
        exit
    fi

    selected_path=""
    if [[ $(uname -s) -eq "Darwin" ]]
    then
        selected_path=$(ask_for_path_option_in_macos_gui $1)
    else
        selected_path=$(ask_for_path_option_in_linux_gui $1)
    fi

    # If there is something wrong with the OS specıfıc GUI, then try bash commandline menu
    if [[ "$selected_path" == "0" ]]
    then
        echo $(ask_for_path_option_in_commadline $1)
    else
       echo $selected_path
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

path=$(ask_for_path_option $repo_path)

echo "Going to " $path " ..."

cd -  > /dev/null 2>&1
cd $path
exec $SHELL
