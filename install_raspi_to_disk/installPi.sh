#!/bin/bash

usage()
{
	echo "Usage: installPi -d [disk name] -if [path/to/raspian/image]"
}

#Check if script is running as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

# If wrong no. of params given
if [[ $# != 4 ]]
then
	usage
	exit 1
fi

# Get params
while [ "$1" != "" ]; do
        case $1 in
                -d )           		shift
                                        diskName=$1
                                        ;;
                -if )           	shift
                                        inputFile=$1
					;;
                -h )	           	usage
                                        exit
                                        ;;
                * )                     usage
                                        exit 1
        esac
        shift
done

sudo diskutil eraseDisk exfat empty $diskName
sudo diskutil unmountDisk $diskName
echo "\nInstalling raspian now from $inputFile - this may take a while..."
sudo dd bs=1m if="$inputFile" | pv -s `du -k $inputFile | cut -f 1` | dd bs=1m of=/dev/$diskName
touch /Volumes/boot/ssh
echo "Installation complete! Ejecting disk now!"
diskutil eject $diskName
