#!/bin/bash
while getopts b: o; do
    case $o in
        (b) NOM_BRIDGE=$OPTARG;;   
    esac
done
#vérification que l'utilisateur donne bien un nom à l'image
if [[ -z "$NOM_BRIDGE" ]]; then 
  echo "Il faut donner le nom du bridge Relancez la commande avec les bons arguments."
  exit
fi

ip link set $NOM_BRIDGE down