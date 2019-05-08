#!/bin/bash
while getopts c: o; do
    case $o in
        (c) NAME_CONTAINER_TO_REMOVE=$OPTARG;;   
    esac
done
#vérification que l'utilisateur donne bien un nom à l'CONTAINER
if [[ -z "$NAME_CONTAINER_TO_REMOVE" ]]; then 
  echo "Il faut donner le NAME du conteneur! Relancez la commande avec les bons arguments."
  exit
fi
rm -rf $PATH_MANIFEST/containers/$NAME_CONTAINER_TO_REMOVE.manifest
rm -rf $PATH_BALEINE/containers/$NAME_CONTAINER_TO_REMOVE

#umount /mnt/container
umount /mnt/baleine/$NAME_CONTAINER_TO_REMOVE
#supprime mnt/container
rm -rf /mnt/baleine/$NAME_CONTAINER_TO_REMOVE
#supprime l'image associé au container (manifest du container)
rm -rf /var/lib/baleine/containers/$NAME_CONTAINER_TO_REMOVE

#TODO : Supprimer interfaces réseaux
#TODO : Grep manifeste container, récupère les interfaces
#TODO : Boucle sur les interfaces, les supprime une à une