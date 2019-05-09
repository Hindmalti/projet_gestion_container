#!/bin/bash
if [ $# -lt 1 ]; then
    printf "NOM\n"
    printf "\t Container\n"
    printf "SYNOPSIS \n"
    printf "\t baleine container <COMMANDES> [arguments]\n"
    printf "Description: \n \n"
    printf "\t La commande 'Container' permet de créer des conteneurs, en supprimer, lister les conteneurs existants (Son nom, son image, son bridge, son PID, son starting time ) \n" 
    printf "Les commandes sont :\n \n"
    printf "\t %-10s %-10s \n" "<create>"  "crée un conteneur."
    printf "\t \t [-i], [NOM_IMAGE]\n \n" 
    printf "\t \t [-c], [NOM_CONTAINER]\n \n"
    printf "\t \t [-b], [NOM_BRIDGE]\n \n"
    printf "\t \t [-r], [REPERTOIRE]\n \n"
    printf "\t \t [-a], [ADDRE_IPV4]\n \n"
    printf "\t \t [-p], [NOM_PROGRAMME]\n \n"
    printf " \t %-10s %-10s \n" "<list> "  "liste les conteneurs existants ainsi que leurs manifestes."
    printf " \t %-10s %-10s \n" "<remove> "  "Supprime le conteneur donné en argument."
    printf "\t \t [-c], --container [NOM_CONTAINER]\n \n" 
    printf "\t \t %-10s %-10s \n" "<exec> "  "Exécute au lancement du conteneur un bash."
    printf "\t \t [-c], --container [NOM_CONTAINER]\n \n" 
    printf "\t %-10s %-10s \n" "<stop> "  "Stop le conteneur donné en argument."
    printf "\t \t [-c], --container [NOM_CONTAINER]\n \n" 
    printf "Utilisez baleine <commande> help pour plus d'informations à propos d'une commande.\n"
fi

case $1 in

    "create")
        #Si on veut creer un container (qu'on a apellé le script ./baleine.sh container create)
        bash create_container.sh "${@:2}"
        ;;
    "list")
        #Si on veut lister les containers qui tournent (qu'on a apellé le script ./baleine.sh container list)
        bash list_container.sh "${@:2}"
        ;;
    "stop")
        bash stop_container.sh "${@:2}"
        ;;
    "remove")
        bash remove_container.sh "${@:2}"
        ;;
    "exec")
        bash exec_container.sh "${@:2}"
        ;;        
 
esac