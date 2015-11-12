#!/bin/bash

# Exit on error
set -e

#Initialize variables to default values.
name=etcd
scheme=https
port=2380

# read flags
while getopts ":p:s:n:" flag; do
    case $flag in
        n) name=$OPTARG >&2 ;;
        s) scheme=$OPTARG >&2 ;;
        p) port=$OPTARG >&2 ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
        \?)
            echo "Invalid option: $OPTARG" >&2
            exit 1
            ;;
    esac
done
shift $(( OPTIND - 1 )) # continue with next args

# read unnamed args or stdin
arr=${@:-$(cat)}

# if stdin, convert it to args
set -- junk $arr 
shift

# print out the results
len=${#@}
x=0
for ip in  $@ 
do
    ((x++))
    echo -n "$name$x=$scheme://$ip:$port"
    if [[ $x < $len ]]; then
        echo -n ","
    fi
done     



