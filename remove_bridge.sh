#!/bin/bash
while getopts b: o; do
    case $o in
        (b) NAME_BRIDGE_TO_REMOVE=$OPTARG;;   
    esac
done
#vérification que l'utilisateur donne bien un nom à l'image
if [[ -z "$NAME_BRIDGE_TO_REMOVE" ]]; then 
  echo "Il faut donner le nom du bridge à supprimer ! Relancez la commande avec les bons arguments."
  exit
fi

rm $PATH_MANIFEST/bridges/$NAME_BRIDGE_TO_REMOVE.manifest
ip link set $NAME_BRIDGE_TO_REMOVE down
brctl delbr $NAME_BRIDGE_TO_REMOVE