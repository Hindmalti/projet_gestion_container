#!/bin/bash
NAME_IMAGE_TO_REMOVE=$1;

#vérification que l'utilisateur donne bien un nom à l'image
if [[ -z "$NAME_IMAGE_TO_REMOVE" ]]; then 
  echo "Il faut donner le nom de l'image ! Relancez la commande avec les bons arguments."
  exit
fi
rm $PATH_MANIFEST/images/$NAME_IMAGE_TO_REMOVE.manifest
rm $PATH_BALEINE/images/$NAME_IMAGE_TO_REMOVE
#TODO : umount 