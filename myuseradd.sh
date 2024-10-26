#! /bin/bash
#
# Author: Ezequiel Matias Tartaglia
#

# For Stage 1
# Use this function to print out the help message for -h
# or if the user does not provide a valid argument.
#
function print_usage () {
    echo "Usage: myuseradd.sh -a <login> <passwd> <shell> - add a user account"
    echo "       myuseradd.sh -d <login>  - remove a user account"
    echo "       myuseradd.sh -h          - display this usage message"
}


# For Stage 2:
# Use this function to delete users as described in the
# assignment instructions.
# 
# Arguments : userToDelete
#
function delete_user () {
    userToDelete="$1" 

    # The user exist in the system?
    if id "$userToDelete" &>/dev/null; then
        userdel "$userToDelete"
        echo "User '$userToDelete' has been deleted."
    else
        echo "ERROR: User '$userToDelete' does not exist."
    fi
}



# For Stage 3:
# Use this function to add users as described in the
# assignment instructions
#
# Arguments : userToAdd, userPassword, shell
#
function add_user () {
    userToAdd="$1"
    userPassword="$2"
    shell="$3"

    useradd -s "$shell" "$userToAdd"

    if [ $? -eq 0 ]; then
        echo "$userToAdd:$userPassword" | chpasswd
        echo "User '$userToAdd' has been added with shell '$shell'."
    else
        echo "ERROR: Failed to add user '$userToAdd'."
    fi
}

# For Stage1:
# Use this function to parse the command line arguments
# provided to this script to determine which function
# to call.  Example, if -h is used, print_usage
#
function parse_command_options() {
    if [ $# -eq 0 ]; then
        print_usage
        return
    fi

    case "$1" in
        -h)
            print_usage
            ;;
        -d)
            if [ $# -ne 2 ]; then
                echo "ERROR: Invalid number of arguments for -d"
                print_usage
            else
                delete_user "$2"  
            fi
            ;;
        -a)
            if [ $# -ne 4 ]; then
                echo "ERROR: Invalid number of arguments for -a"
                print_usage
            else
                add_user "$2" "$3" "$4"  
            fi
            ;;
        *)
            echo "ERROR: Invalid option: $1"
            print_usage
            ;;
    esac
}

#
# This will run and call the parse_command_options function
# and pass all of the arguments to that function
#
parse_command_options "$@"

