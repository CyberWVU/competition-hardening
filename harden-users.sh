#!/bin/bash
# ls /home/ >> users-to-lock.txt 
# remove yourself and any important users that might need shell access
usage()
{
cat <<EOF
    Usage:
        harden-users.sh -f users.txt [ -r ] [ -h ]
        
        -h	Show the help menu
        -r	Lock the root account
        -f 	File of usernames to lock

    Description:
 	  This script takes in a list of user accounts and locks them, deletes their
	  passwords, removes their shell access, etc.

EOF
}

# Print help if -h or no args specified
[ "${1}" == "-h" ] && usage && exit 0
[ "$#" -eq 0 ] && usage && exit 0

# Make sure only root can execute this script.
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root." 1>&2
   exit 1
fi

LOCK_ROOT="FALSE"
USERS_FILE=""
while [ "$1" != "" ]; do
    
    if [ "$1" == "-f" ]; then
	USERS_FILE="${2}"; shift

    elif [ "$1" == "-r" ]; then
	LOCK_ROOT="TRUE"; shift
	
    fi
    
    shift
    
done

for u in "$(cat ${USERS_FILE})"
do
    echo $u
    passwd -d $u
    passwd -l $u
    usermod -s /sbin/nologin $u
    chown -R root:root /home/$u
    chmod 700 /home/$u

done
