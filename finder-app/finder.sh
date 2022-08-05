#!/bin/sh
# do ifs "Exits with return value 1 error and print statements if any of the parameters above were not specified"
if [ -z "$1" ]; 
then
    echo "\nPlease call '$0 <dir to search> <text to search>' to run this command!\n"
    exit 1
fi
if [ -z "$2" ]; 
then
    echo "\nPlease call '$0 <dir to search> <text to search>' to run this command!\n"
    exit 1
fi
if [ -d $1 ];
then
    true
else
    echo "directory doesn't exist"
    exit 1
fi
numfiles=`find $1 -type f|wc -l`
numlines=`grep -r $2 $1 2>/dev/null|wc -l`
echo "The number of files are $numfiles and the number of matching lines are $numlines"