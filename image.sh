#!/bin/bash
if [ $# -lt 1 ]; then
    printf "Nom \n"
    printf "\t \t Image\n"
    printf "SYNOPSIS \n"
    printf "\t \t baleine image <COMMANDES> [arguments]\n"
    printf "Description: \n \n"
    printf "La commande 'image' permet de créer une image, en supprimer, lister les images existantes (Son nom, sa taille, son chemin ) " 
    printf "Les commandes sont :\n \n"
    printf "\t %-10s %-10s \n" "<create>"  "crée une image."
    printf "\t \t [-i], [NOM_IMAGE]\n \n" 
    printf "\t \t [-s], [TAILLE]\n \n" 
    printf "\t \t [-r], [REPERTOIRE]\n \n" 
    printf "\t \t [-P], [PROXY]\n \n"
    printf " \t %-10s %-10s \n" "<list>"  "liste les images existantes ainsi que leurs manifestes."
    printf " \t %-10s %-10s \n" "<remove>"  "Supprime l'image donnée en argument."
    printf "\t \t [-c], --container [NOM_CONTAINER]\n \n" 
    printf "Utilisez baleine <commande> help pour plus d'informations à propos d'une commande.\n"
fi


case $1 in
    "create")
        #Si on veut creer une image (qu'on a apellé le script ./balaine.sh image create)
        bash create_image.sh "${@:2}"
        ;;
    "list")
        #Si on veut lister les images (qu'on a apellé le script ./balaine.sh image list)
        bash list_images.sh "${@:2}"
        ;;
    "import")
        bash import_container.sh "${@:2}"
        ;;
    "export")
        bash export_container.sh "${@:2}"
               ;;
    "remove")
        bash remove_image.sh "${@:2}"
esac