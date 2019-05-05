#!/bin/bash

while getopts e: o; do
  case $o in
    (e) $NOM_CONTAINER=$OPTARG;;
  esac
done

unshare -p -f -m -n -u chroot /mnt/baleine/$NOM_CONTAINER /bin/bash