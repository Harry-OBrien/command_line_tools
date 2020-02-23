#!/bin/bash

### FUNCTIONS ###

usage()
{
	echo "Usage: newProject -n [project name] (-cpp, -c)"
  echo "\n"

  echo "-n | --name [Project name]"
  echo "-l | --location [Path/To/Location/] \t default is ./"

  echo "-c	C proj"
  echo "-cpp	cpp proj"

  echo "-h	show this usage page"
}

generateCppProject()
{
  echo "Creating C++ project named $1 at location $2"

	#Create project folder
	mkdir "$2/$1"

	echo "build/*
!build/makefile" >> "$2/$1/.gitignore"

	#Create build dir and make file
	mkdir "$2/$1/build"

	#create includes folder
	mkdir "$2/$1/include"
	mkdir "$2/$1/include/common"
	mkdir "$2/$1/include/$1"

	mkdir "$2/$1/lib"

	#Source folder
	mkdir "$2/$1/src"
	mkdir "$2/$1/src/common"
	mkdir "$2/$1/src/$1"

	echo "//
//  main.cpp
//  $1
//
//  Created by Harry O'Brien on $(date '+%d-%m-%Y').
//  Copyright © $(date '+%Y') Harry O'Brien. All rights reserved.
//

#include <iostream>

int main(int argc, char** argv) {

\tstd::cout << \"Argc: \" << argc << \" Name: \" << argv[0] << std::endl;

\treturn 0;
}" >> "$2/$1/src/$1/main.cpp"
}

generateCProject()
{
  echo "Creating C project named $1 at location $2"
  echo "Not implemented... soz and al that!"
  return 1
}

### MAIN ###

#if too many params

if [[ $# > 5 ]]
then
        usage
        exit 1
fi

projType=-1
path="./"

#Get all params
while [ "$1" != "" ]; do
  case $1 in
    -n | --name )		  shift
          					  appName=$1
					            ;;

    -l | --location )	shift
          					  path=$1
    			            ;;

		-cpp )		        projType=0
					            ;;

		-c )	            projType=1
					            ;;

		-h | --help )		  usage
                      exit
  					          ;;

		* )			          usage
                      exit 1

	esac
	shift
done

if [[ -z "${appName// }" ]]
then
  usage
  exit 1
fi

#create the project depending on the type that should be made
case "$projType" in
    -1 )
        usage
        exit 1
        ;;

    0 )
        generateCppProject $appName $path
        ;;

    1 )
        generateCProject $appName $path
        ;;
esac

result=$?
if [ $result != 0 ]
then
  echo "\033[0;31mSomething went wrong when creating the project!\033[0m" >&2
  exit 1
fi

echo "\033[0;32mProject is now ready for development!\033[0m"
open $path/$appName
atom $path/$appName
