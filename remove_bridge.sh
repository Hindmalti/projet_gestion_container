#!/bin/bash
NOM_BRIDGE_TO_REMOVE=$3;


#vérification que l'utilisateur donne bien un nom à l'image
if [[ -z "$NOM_BRIDGE_TO_REMOVE" ]]; then 
  echo "Il faut donner le nom du bridge à supprimer ! Relancez la commande avec les bons arguments."
  exit
fi
chmod -R 755 $PATH_MANIFEST
rm $PATH_MANIFEST/bridges/$NOM_BRIDGE_TO_REMOVE.*
ip link delete $NOM_BRIDGE_TO_REMOVE type bridge
#delbr
