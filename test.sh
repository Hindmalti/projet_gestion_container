#!/bin/bash

echo $@
while getopts i:proxy: o "$@"; do
    case $o in
        (i) IMAGE=$OPTARG;;
        (proxy) PROXY=$OPTARG;;
    esac
done

echo "Le proxy est $PROXY"
echo "L'image est $IMAGE"
