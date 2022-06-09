# Function extending git to get log or status 
# of a repo in another path 
#
# Arguments: $1: path of the repo
# Output: git log of the repo
# Usage:
#   git log /my/git/repo/path/
#   git status /my/git/repo/path/

function git() {
#   set -xv
    if [ ! "$2" == "" ]; then
        if [[ "$1" = @("log"|"status") ]]; then
#       if [[ "$1" == "log"] || ["$1" == "status" ]]; then
            command git --git-dir "$2/.git" log

            return;
        fi
    fi
    command git $@
#   set +xv
}
