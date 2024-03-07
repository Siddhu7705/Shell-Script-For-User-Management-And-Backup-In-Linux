#!/bin/bash
# Function to display usage information and available options

{
    echo "Usage: $0 [OPTIONS]"
    echo "options:"
    echo "  -c, --create  Create a new user account."
    echo "  -d, --delete  Delete an existing user account."
    echo "  -r, --reset   Reset password for an existing user account."
    echo "  -l, --list    List all user accounts on the system."
    echo "  -h, --help    Display this help and exit."
}

# ---------------------------------------------------------------------------

function create_account {
    echo "Enter your fav. :) username to create new user-account:"
    read username
    egrep "^$username" /etc/passwd >/dev/null
    if [ $? -eq 0 ]; then
        echo "This username already exists, try another one :("
        exit 1
    else
        echo "Enter the password for $username:"
        read password
        pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
       sudo useradd -m -p $pass $username
        [ $? -eq 0 ] && echo "User has been added to system!" || echo "Sorry failed to add a user!"
    fi
}
# -------------------------------------------------------------------------------

function delete_account {
    echo "Enter the username of the account to be deleted:"
    read username
    egrep "^$username" /etc/passwd >/dev/null
    if [ $? -eq 0 ]; then
       sudo userdel -r $username
        [ $? -eq 0 ] && echo "User has been removed from system!" || echo "Failed to remove user!"
    else
        echo "No such user $username"
        exit 1
    fi
}

# -----------------------------------------------------------------------------------

function reset_password {
    echo "Enter the username for password reset:"
    read username
    egrep "^$username" /etc/passwd >/dev/null
    if [ $? -eq 0 ]; then
        echo "Enter the new password:"
        read password
        echo "$username:$password" | sudo chpasswd
        [ $? -eq 0 ] && echo "User password has been changed!" || echo "Failed to change user password!"
    else
        echo "No such user $username"
        exit 1
    fi
}

# --------------------------------------------------------------------------------------

function list_accounts {
    echo "User accounts:"
    cut -d: -f1,3 /etc/passwd
}

function usage {
    echo "Usage: $0 {--create|-c|--delete|-d|--reset|-r|--list|-l|--help|-h}"
    exit 1
}

case "$1" in
--create|-c)
    create_account
    ;;
--delete|-d)
    delete_account
    ;;
--reset|-r)
    reset_password
    ;;
--list|-l)
    list_accounts
    ;;
--help|-h)
    usage
    ;;
*)
    usage
    ;;
esac
# -------------EOF----------------------xx---------------------------------------------
