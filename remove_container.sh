#!/bin/bash
NOM_CONTAINER_TO_REMOVE=$3;

#vérification que l'utilisateur donne bien un nom à l'CONTAINER
if [[ -z "$NOM_CONTAINER_TO_REMOVE" ]]; then 
  echo "Il faut donner le nom du conteneur! Relancez la commande avec les bons arguments."
  exit
fi
chmod -R 755 $PATH_MANIFEST
rm $PATH_MANIFEST/containers/$NOM_CONTAINER_TO_REMOVE.manifest
rm $PATH_BALEINE/containers/$NOM_CONTAINER_TO_REMOVE

#il doit remove aussi l'image, les manifessts les bridges supprime la copie? 
