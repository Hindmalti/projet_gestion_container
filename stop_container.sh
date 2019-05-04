#!/bin/bash

while getopts c: o; do
    case $o in
        (c) NOM_CONTAINER=$OPTARG;;   
    esac
done
kill $PID
umount /mnt/baleine/$NOM_CONTAINER