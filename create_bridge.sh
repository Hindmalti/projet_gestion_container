#!/bin/bash
while getopts b:a: o; do
    case $o in
        (b) NOM_BRIDGE=$OPTARG;;
        (a) ADDR_IPV4=$OPTARG;;
        
    esac
done


#condition sur le nbre d'arguments
if [[ -z "$NOM_BRIDGE" ]]; then 
  echo "Il faut donner le nom du bridge ! Relancez la commande avec les bons arguments."
  exit
fi
#création du bridge
echo "Création du bridge $NOM_BRIDGE"
ip link add $NOM_BRIDGE type bridge

#attribution d'une adresse ip au bridge
echo "Attribution de l'adresse ip $ADDR_IPV4 à $NOM_BRIDGE"
ip a add dev $NOM_BRIDGE $ADDR_IPV4

#demarrage du bridge
echo "Demarrage de $NOM_BRIDGE"
ip link set $NOM_BRIDGE down
ip link set $NOM_BRIDGE up

MANIFEST=$NOM_BRIDGE.manifest
echo "nom_bridge:$NOM_BRIDGE" >> $MANIFEST #nom du bridge

#condition de bordure pour le dossier Bridges
if [[ ! -d "$PATH_MANIFEST/bridges" ]]; then 
  mkdir -p $PATH_MANIFEST/bridges #&& mv FILE $PATH_MANIFEST/bridges
fi

mv $MANIFEST $PATH_MANIFEST/bridges