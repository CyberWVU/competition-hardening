#!/bin/bash
# ls /home/ >> users.txt 
# awk -F: '($3 >= 1000 && $3 != 65534) {print $1 }' /etc/passwd >> users.txt
# ^ get a list of users on the system
# Could easily be changed to lock user accounts

# Usage:
#       ./harden-users.sh users.txt

# Make sure only root can execute this script.
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root." 1>&2
   exit 1
fi

USERS_FILE=$1
echo "$USERS_FILE"