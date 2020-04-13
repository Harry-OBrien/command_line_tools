#/bin/bash

usage()
{
        echo "Usage: initRepo [Remote Origin URL]"
}

if [[ $# != 1 ]]
then
        usage
        exit 1
fi

git init
git remote add origin $1
gaaa
gcm "Initial commit"
git push -u origin master
