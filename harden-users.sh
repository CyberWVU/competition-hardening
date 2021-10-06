#!/bin/bash
# ls /home/ >> users-to-lock.txt 
# remove yourself and any important users that might need shell access
usage()
{
cat <<EOF
    Usage:
        lbm-inject -i iso -p preseed [ -t tar file ] [ -h ] [ -n ]
        
        -h	Show the help menu
        -i	The iso file to use
        -p 	The preseed file to inject 
        -t	The tar file to extract. Must NOT be compressed. 
        -n      Create net media.

    Description:
 	  This tool will inject files into a Ubuntu iso. Preseeds are 
	  automatically placed into the correct location to be used
	  on boot. All tar files are placed in the /loud directory in 
	  the root of the iso file.

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

    elif [ "$1" == "u" ]; then
	KEEP_USER="${2}"; shift

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
