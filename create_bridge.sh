#!/bin/bash
NOM_BRIDGE=$3;
ADDR_IPV4=$4;
REPERTOIRE=${PWD}


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

touch  $NOM_BRIDGE.manifest # On crée un fichier contenant les infos du bridge
echo "$NOM_BRIDGE" >> $NOM_BRIDGE.manifest #nom du bridge

#condition de bordure pour le dossier Bridges
if [[ ! -d "$REPERTOIRE/baleine/Bridges" ]]; then 
  mkdir -p $REPERTOIRE/baleine/Bridges && mv $NOM_BRIDGE.manifest $REPERTOIRE/baleine/Bridges
fi
mv $NOM_BRIDGE.manifest $REPERTOIRE/baleine/Bridges