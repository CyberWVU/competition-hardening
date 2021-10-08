#!/bin/bash
# Make sure only root can execute this script.
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root." 1>&2
   exit 1
fi

#Check for empty passwords
awk -F: '($2 == "" ) { print $1 " does not have a password "}' /etc/shadow
awk -F: '($2 == "" ) { print $1 " does not have a password "}' /etc/shadow > user-audit.txt

#Lock the account until we know why it didn't have a password
# for u in "$(cat password-audit.txt | cut -d " " -f1)"
#     do
#         echo $u
#     done

#Disable guest login
echo "greeter-show-remote-login=false" >> /etc/lightdm/lightdm.conf
echo "allow-guest=false" >> /etc/lightdm/lightdm.conf
restart lightdm

#Check home directory permissions
readarray user_array < $(ls /home))
for u in $user_array
do
    echo "$u"
    chown -R $u:$u /home/$u
    chmod 750 /home/$u
done

#Check if root has *
# if $(cat /etc/shadow | grep root | cut -d : -f2) == "*"; then
#     echo "Root does not have a password set" >> password-audit.txt
# fi

#Check for root accounts - if there are aliases, get rid of them
awk -F: '($3 == 0) { print $1 " :root account found"}' /etc/passwd >> password-audit.txt

#Ensure root gid
#usermod -g 0 root

#Set user shells
# for user in `awk -F: '($3 < 500) {print $1 }' /etc/passwd` ; 
# do 
#     if [ $user != "root" ]; then 
#             usermod -L $user 
#         if [ $user != "sync" ] && [ $user != "shutdown" ] && [ $user != "halt" ]; then 
#             usermod -s /sbin/nologin $user 
#         fi 
#     fi 
# done