#!/bin/bash
    printf "Baleine est un outil simple de gestion de conteneur.\n"
    printf "Utilisation: \n \n"
    printf "\t \t image <commande> [arguments]\n"
    printf "Les commandes sont :\n \n"
    printf "\t \t %-10s %-10s \n" "create <NOM_IMAGE> <TAILLE_IMAGE> <REPERTOIRE_IMAGE>"  "Créer une image  "
    printf "\t \t %-10s %-10s \n" "list <>" "Liste le manifest de chaque image."
    printf "\t \t %-10s %-10s \n \n" "remove <NOM_IMAGE_A_SUPPRIMER>" "supprime l'image passée en argument "

    printf "\t \t bridge <commande> [arguments]\n"
    printf "Les commandes sont :\n \n"
    printf "\t \t %-10s %-10s \n" "create <NOM_IMAGE> <TAILLE_IMAGE> <REPERTOIRE_IMAGE>"  "Créer une image avec "
    printf "\t \t %-10s %-10s \n" "list <>" "Liste le manifest de chaque image."
    printf "\t \t %-10s %-10s \n \n" "remove <NOM_IMAGE_A_SUPPRIMER>" "supprime l'image passée en argument "

    printf "\t \t container <commande> [arguments]\n"
    printf "Les commandes sont :\n \n"
    printf "\t \t %-10s %-10s \n" "create <NOM_IMAGE> <TAILLE_IMAGE> <REPERTOIRE_IMAGE>"  "Créer une image avec "
    printf "\t \t %-10s %-10s \n" "list <>" "Liste le manifest de chaque image."
    printf "\t \t %-10s %-10s \n \n" "remove <NOM_IMAGE_A_SUPPRIMER>" "supprime l'image passée en argument "
    