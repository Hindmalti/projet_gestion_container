#!/bin/bash
while getopts c:i: o; do
    case $o in
        (c) NOM_CONTAINER=$OPTARG;;
        (i) NOM_IMAGE=$OPTARG;;    
    esac
done
mount -t ext4 -o loop $PATH_BALEINE/containers/$NOM_CONTAINER/$NOM_IMAGE /mnt/baleine/$NOM_CONTAINER

nohup unshare -p -f -m -n -u chroot /mnt/baleine/$NOM_CONTAINER $PROGRAM -c "mount /proc" &
PID=$!

ps axo ppid,pid | grep "^ *$PID" | sed -e 's/.* //'
