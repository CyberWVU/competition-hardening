#!/bin/bash
# Make sure only root can execute this script.
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root." 1>&2
   exit 1
fi
#list firewall status
ufw status
ufw disable
ufw default deny incoming
ufw allow OpenSSH
ufw logging on
ufw enable
ufw status
