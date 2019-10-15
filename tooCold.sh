#!/bin/bash

### FUNCTIONS ###

usage()
{
	echo "Usage: tooCold [room name]"
}

### MAIN ###

#if too many params

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

#now send an email telling compSci environs that the room is too cold

timeDate=`date`

printf "The room $roomName is too cold.\n Current time is $timeDate\n\nThanks,\nHarry" |  mutt -s "Too Cold" compsci-environs@listserv.manchester.ac.uk
