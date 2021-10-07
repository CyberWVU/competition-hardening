#!/bin/bash
# ls /home/ >> users-to-lock.txt 
# remove yourself and any important users that might need shell access
usage()
{
cat <<EOF
    Usage:
        harden-users.sh -f users.txt [ -r ] [ -h ]
        
        -h      Show the help menu
        -a      File of admin users to harden
        -u      File of low priv users to harden
        -r      Lock the root account
        -l      Lock user accounts

    Description:
          This script 

EOF
}

# Print help if -h or no args specified
[ "${1}" == "-h" ] && usage && exit 0
[ "$#" -eq 0 ] && usage && exit 0

# Make sure only root can execute this script.
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root or with sudo privileges." 1>&2
   exit 1
fi

LOCK_ROOT="FALSE"
LOCK_USERS="FALSE"

while [ "$1" != "" ]; do

    if [ "$1" == "-a" ]; then
        ADMINS_FILE="${2}"; shift

    elif [ "$1" == "-u" ]; then
        USERS_FILE="${2}"; shift

    elif [ "$1" == "-r" ]; then
        LOCK_ROOT="TRUE"; shift

    elif [ "$1" == "-l" ]; then
        LOCK_USERS="TRUE"; shift
    fi

    shift

done
#Check for empty passwords
awk -F: '($2 == "" ) { print $1 " does not have a password "}' /etc/shadow > password-audit.txt
#Lock the account until we know why it didn't have a password
for u in "$(cat password-audit.txt | cut -d " " -f1)"
    do
        echo $u
    done

if [ -u "$USERS_FILE" ]; then
    echo "user loop"
        for u in "$(cat ${USERS_FILE})"
            do
                echo "$u"
                chown -R root:root /home/$u
                chmod 750 /home/$u
                usermod -s /sbin/nologin $u
                if ["$LOCK_USERS" == "TRUE"]; then
                    passwd -d $u #Delete password
                    passwd -l $u #Lock password
                fi
                if id -nG $u | grep -w sudo; then
                    echo "user $u was in sudo" >> password-audit.txt
                    deluser $u sudo
                fi
            done
fi

#Check if root has *
# if $(cat /etc/shadow | grep root | cut -d : -f2) == "*"; then
#     echo "Root does not have a password set" >> password-audit.txt
# fi

#Check for root accounts - if there are aliases, get rid of them
awk -F: '($3 == 0) { print $1 " :root account found"}' /etc/passwd >> password-audit.txt

#Ensure root gid
usermod -g 0 root

#Check file permissions
#shadow
chmod 640 /etc/shadow
chown root:shadow /etc/shadow
chmod 640 /etc/shadow-
chown root:shadow /etc/shadow-
#gshadow
chmod 640 /etc/gshadow
chown root:shadow /etc/gshadow
chmod 640 /etc/gshadow-
chown root:shadow /etc/gshadow-
#passwd
chmod 644 /etc/passwd
chown root:root /etc/passwd
chmod 644 /etc/passwd-
chown root:root /etc/passwd-
#group
chmod 644 /etc/group
chown root:root /etc/group
chmod 644 /etc/group-
chown root:root /etc/group-
