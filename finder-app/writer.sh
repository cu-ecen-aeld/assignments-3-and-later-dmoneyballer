#!/bin/sh
if [ -z "$1" ]; 
then
    echo "\nPlease call '$0 <full filepath of file to write> <string to write>' to run this command!\n"
    exit 1
fi
if [ -z "$2" ]; 
then
    echo "\nPlease call '$0 <full filepath of file to write> <string to write>' to run this command!\n"
    exit 1
fi
if [ -d $1 ];
then
    true
else
    dir=$(dirname $1)
    base=$(basename $1)
    echo $dir $base
    mkdir -p $dir
    echo "$2" > $1
fi 