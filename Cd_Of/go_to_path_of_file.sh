# Script used to change directory of the file/folder
# whose path is given in $1
# Arguments: $1: path to a file. 

cdof() {
    cd $(dirname "$1")
}
