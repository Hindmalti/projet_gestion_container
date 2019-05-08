#!/bin/bash

while getopts c: o; do
  case $o in
    (c) $NOM_CONTAINER=$OPTARG;;
  esac
done

unshare -p -f -m -n -u chroot /mnt/baleine/$NOM_CONTAINER /bin/bash