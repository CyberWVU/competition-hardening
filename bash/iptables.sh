#!/bin/bash
apt install iptables -y
iptables -P INPUT DROP 
iptables -P OUTPUT DROP 
iptables -P FORWARD DROP
iptables -A INPUT -i lo -j ACCEPT 
iptables -A OUTPUT -o lo -j ACCEPT 
iptables -A INPUT -s 127.0.0.0/8 -j DROP