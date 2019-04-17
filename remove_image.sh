#!/bin/bash
NOM_IMAGE_TO_REMOVE=$3;
REPERTOIRE=${PWD}

#vérification que l'utilisateur donne bien un nom à l'image
if [[ -z "$NOM_IMAGE_TO_REMOVE" ]]; then 
  echo "Il faut donner le nom de l'image ! Relancez la commande avec les bons arguments."
  exit
fi
chmod -R 755 $REPERTOIRE/baleine
rm $REPERTOIRE/baleine/Images/$NOM_IMAGE_TO_REMOVE.manifest
rm $REPERTOIRE/$NOM_IMAGE_TO_REMOVE