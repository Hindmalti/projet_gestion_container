#!/bin/bash
NOM_BRIDGE=$3;
ADDR_IPV4=$4;



#condition sur le nbre d'arguments
if [[ -z "$NOM_BRIDGE" ]]; then 
  echo "Il faut donner le nom du bridge ! Relancez la commande avec les bons arguments."
  exit
fi
#création du bridge
ip link add $NOM_BRIDGE type bridge
ip a add dev $NOM_BRIDGE $ADDR_IPV4
ip link set $NOM_BRIDGE down
ip link set $NOM_BRIDGE up
FILE= $NOM_BRIDGE.manifest
touch  FILE # On crée un fichier contenant les infos du bridge
echo "$NOM_BRIDGE" >> FILE #nom du bridge

#condition de bordure pour le dossier Bridges
if [[ ! -d "$PATH_MANIFEST/bridges" ]]; then 
  mkdir -p $PATH_MANIFEST/bridges #&& mv FILE $PATH_MANIFEST/bridges
fi
mv FILE $PATH_MANIFEST/bridges