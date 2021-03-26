#/bin/bash

#SSH config file lives at /etc/ssh/sshd_config

#Verify that the file actually exists

CONFIG=/etc/ssh/sshd_config

if [! -f "$CONFIG"]; then
	echo "$CONFIG does not exist. Exiting."
	exit 1
fi

#Verify permissions on this file
chown root:root "$CONFIG"
chmod 600 "$CONFIG"

#Ensure protocol is set to 2


#Ensure LogLevel is set to INFO

#Ensure MaxAuthTries is < 4

#Check AllowUsers

#Check AllowGroups

#Check DenyUsers

#Check DenyGroups

#Set a warning banner /etc/issue.net

#Restart SSH Service

#Check for SSH keys. Print all found.


#Remove SSH keys
