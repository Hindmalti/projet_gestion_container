#!/bin/bash
NOM_CONTAINER=$3;
NOM_IMAGE=$4;

mount -t ext4 -o loop $PATH_BALEINE/containers/$NOM_CONTAINER/$NOM_IMAGE /mnt/baleine/$NOM_CONTAINER

nohup unshare -p -f -m -n -u chroot /mnt/baleine/$NOM_CONTAINER $PROGRAM -c "mount /proc" &
PID=$!

ps axo ppid,pid | grep "^ *$PID" | sed -e 's/.* //'
