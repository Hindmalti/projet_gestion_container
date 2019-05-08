#!/bin/bash
set -x
while getopts c: o; do
    case $o in
        (c) NAME_CONTAINER_TO_REMOVE=$OPTARG;;   
    esac
done
#vérification que l'utilisateur donne bien un nom à l'CONTAINER
if [[ -z "$NAME_CONTAINER_TO_REMOVE" ]]; then 
  echo "Il faut donner le nom du conteneur! Relancez la commande avec les bons arguments."
  exit
fi

PID=$(grep "pid" $PATH_MANIFEST/containers/$NAME_CONTAINER_TO_REMOVE.manifest | cut -d":" -f2)

echo "Kill du container"
kill $PID

echo "Démontage de /mnt/baleine/$NAME_CONTAINER_TO_REMOVE"
umount /mnt/baleine/$NAME_CONTAINER_TO_REMOVE

echo "Suppression de /mnt/baleine/$NAME_CONTAINER_TO_REMOVE"

echo "Suppression de $PATH_BALEINE/containers/$NAME_CONTAINER_TO_REMOVE"
rm -rf $PATH_BALEINE/containers/$NAME_CONTAINER_TO_REMOVE

INTERFACES=$(grep "interfaces" $PATH_MANIFEST/containers/$NAME_CONTAINER_TO_REMOVE.manifest | cut -d":" -f2)

echo "Suppression des interfaces réseau :"
IFS=","
#On supprime les interfaces réseaux associées à ce container
for interface in $INTERFACES; do
    echo "Suppression de $interface"
    ip link del $interface
done

echo "Suppression du manifeste du container"
rm -rf $PATH_MANIFEST/containers/$NAME_CONTAINER_TO_REMOVE.manifest