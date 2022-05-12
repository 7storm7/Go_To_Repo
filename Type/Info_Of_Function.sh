# Function extending type command to give path 
# information of a bash function. 
#
# Arguments: $1: name of the command/function 
# Output: 
#    <Function name> <line number> <file path>
#    <$1> is a <function|shell builtin>
#    <Function content>
function type() {
    command shopt -s extdebug
    command declare -F $1
    command type "$1"
}
