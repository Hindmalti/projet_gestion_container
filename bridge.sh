#!/bin/bash
if [ $# -lt 1 ]; then
    printf "Nom \n"
    printf "\t \t Bridge\n"
    printf "SYNOPSIS \n"
    printf "\t \t baleine bridge <COMMANDES> [arguments]\n"
    printf "Description: \n \n"
    printf "La commande 'bridge' permet de créer des bridges Linux, en supprimer et lister les bridges existants (Nom) " 
    printf "Les commandes sont :\n \n"
    printf "\t %-10s %-10s \n" "<create>"  "crée un bridge."
    printf "\t \t [-b], [NOM_BRIDGE]\n \n" 
    printf "\t \t [-a], [ADDR_IPV4]\n \n" 
    printf " \t %-10s %-10s \n" "<list>"  "liste les bridges existants ainsi que leurs manifestes."
    printf " \t %-10s %-10s \n" "<remove>"  "Supprime le bridge donné en argument."
    printf "\t \t [-b], --bridge [NOM_BRIDGE]\n \n"
    printf " \t %-10s %-10s \n" "<up>"  "Met up le bridge donné en argument."
    printf "\t \t [-b], --bridge [NOM_BRIDGE]\n \n"
    printf " \t %-10s %-10s \n" "<down>"  "Met down le bridge donné en argument."
    printf "\t \t [-b], --bridge [NOM_BRIDGE]\n \n"

    printf "Utilisez baleine <commande> help pour plus d'informations à propos d'une commande.\n"
fi
case $1 in

    "create")
        #Si on veut creer un bridge (qu'on a apellé le script ./balaine.sh bridge create)
        bash create_bridge.sh "${@:2}"
        ;;
    "list")
        #Si on veut lister les bridges (qu'on a apellé le script ./balaine.sh bridge list)
        bash list_bridges.sh "${@:2}"
        ;;
    "remove")
        bash remove_bridge.sh "${@:2}"
           ;;
    "up")
        bash up_bridge.sh "${@:2}"
           ;;
    "down")
        bash down_bridge.sh "${@:2}"
esac