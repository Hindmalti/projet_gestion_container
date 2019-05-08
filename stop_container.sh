#!/bin/bash
while getopts c: o; do
    case $o in
        (c) NAME_CONTAINER_TO_REMOVE=$OPTARG;;   
    esac
done
#vérification que l'utilisateur donne bien un nom à l'CONTAINER
if [[ -z "$NAME_CONTAINER_TO_REMOVE" ]]; then 
  echo "Il faut donner le nom du conteneur! Relancez la commande avec les bons arguments."
  exit 1
fi

PID=$(grep "PID" $PATH_MANIFEST/containers/$NAME_CONTAINER_TO_REMOVE.manifest | cut -d":" -f2)

echo "Kill du container"
kill $PID

rm -rf $PATH_MANIFEST/containers/$NAME_CONTAINER_TO_REMOVE.manifest
rm -rf $PATH_BALEINE/containers/$NAME_CONTAINER_TO_REMOVE

echo "Démontage de /mnt/baleine/$NAME_CONTAINER_TO_REMOVE"
umount /mnt/baleine/$NAME_CONTAINER_TO_REMOVE
#supprime mnt/container

echo "Suppression de /mnt/baleine/$NAME_CONTAINER_TO_REMOVE"
#supprime l'image associé au container (manifest du container)