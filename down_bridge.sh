#!/bin/bash
NOM_BRIDGE=$3;
#vérification que l'utilisateur donne bien un nom à l'image
if [[ -z "$NOM_BRIDGE" ]]; then 
  echo "Il faut donner le nom du bridge Relancez la commande avec les bons arguments."
  exit
fi
ip link set $NOM_BRIDGE down