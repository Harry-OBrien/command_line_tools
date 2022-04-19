#!/bin/bash

###### Default variables

webRoot=""
user="HarryOB"
webUser="_www"

##### Functions

usage()
{
	echo "\n"
	echo "usage: setWebPermissions [-r /path/to/web/root]"
 
	echo "\n"

	echo "-r	set web root location"
	echo "-u	user to be part owner"
	echo "-w	set the web user (typically www-data)"
	echo "-h	show this usage page"

	#end of usage()
}


###### Main Script

#Check if script is running as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

#If too many params given
if [[ $# > 3 ]]
then
	usage
	exit 1
fi	

#Get all params
while [ "$1" != "" ]; do
	case $1 in
		-r | --root )		shift
					webRoot=$1
					;;
		-u | --user )		shift
					user=$1
					;;
		-w | --webUser )	shift
					webUser=$1
					;;
		-h | --help )		usage
					exit
					;;
		* )			usage
					exit 1
	esac
	shift
done

#If no webroot is specified, exit
if [ -z "$webRoot" ]
then
	usage
	exit 1
fi

#cut trailing slash
webRoot=${webRoot%/}

chown -R $webUser:$webUser $webRoot
dscl . append /Groups/$webUser GroupMembership $user

sudo chown -R $user:$webUser $webRoot

sudo find $webRoot -type f -exec chmod 664 {} \;
sudo find $webRoot -type d -exec chmod 775 {} \;

sudo chgrp -R $webUser $webRoot/storage $webRoot/bootstrap/cache
sudo chmod -R ug+rwx $webRoot/storage $webRoot/bootstrap/cache

#done!
echo "Don't forget to change /etc/apache2/httpd.conf and related files!"
