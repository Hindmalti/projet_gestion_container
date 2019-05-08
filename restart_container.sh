#!/bin/bash
while getopts c:i: o; do
    case $o in
        (c) NOM_CONTAINER=$OPTARG;;
        (i) NOM_IMAGE=$OPTARG;;    
    esac
done

mount -t ext4 -o loop $PATH_BALEINE/containers/$NOM_CONTAINER/$NOM_IMAGE /mnt/baleine/$NOM_CONTAINER
nohup unshare -p -f -m -n -u chroot /mnt/baleine/$NOM_CONTAINER /bin/sh -c "mount /proc ; $PROGRAM ; while true ; do sleep 10 ; done" &
PID=$!


#TODO: *Rajouter les interfaces réseau au container
#      *