#!/bin/bash
NOM_IMAGE_TO_REMOVE=$3;

#vérification que l'utilisateur donne bien un nom à l'image
if [[ -z "$NOM_IMAGE_TO_REMOVE" ]]; then 
  echo "Il faut donner le nom de l'image ! Relancez la commande avec les bons arguments."
  exit
fi
chmod -R 755 $PATH_MANIFEST
rm $PATH_MANIFEST/images/$NOM_IMAGE_TO_REMOVE.manifest
rm $PATH_BALEINE/images/$NOM_IMAGE_TO_REMOVE