#!/bin/bash

### FUNCTIONS ###

usage()
{
	echo "Usage: tooHot [room name]"
}

### MAIN ###

#if too many or too few params

if [[ $# != 1 ]]
then
        usage
        exit 1
fi

#get param
while [ "$1" != "" ]; do
        case $1 in
                -h | --help )           usage
                                        exit
                                        ;;
                * )                     roomName=$1
                                        ;;
        esac
        shift
done

#now send an email telling compSci environs that the room is too hot

timeDate=`date`

printf "The room $roomName is too hot.\n Current time is $timeDate\n\nThanks,\nHarry" |  mutt -s "Too Hot" compsci-environs@listserv.manchester.ac.uk
