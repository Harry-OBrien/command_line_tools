#!/bin/bash

#Create and attach random mac address
addr=`openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//'`
sudo /sbin/ifconfig en1 ether $addr
sleep 1

unset addr
addr=`/sbin/ifconfig en1 | grep ether`
addr=${addr#* }

#print out new address
echo $addr
syslog -s -l error "the address is ${addr}"

#Force new DHCP discover
sudo /sbin/ifconfig en1 down && sudo /sbin/ifconfig en1 up
sleep 6

#lynx http://trpz-1.dl.ac.uk/aaa/wba_form.html?wbaredirect=https://www.google.co.uk/ -accept_all_cookies- cmd_script=/Users/HarryOB/Documents/shellScripts/enterPwd.txt

