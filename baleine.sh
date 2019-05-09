
#!/bin/bash

#Ce code est le point d'entrée de l'application, c'est lui qui est apellé quand on écrit ./balaine container create

#Ici on fait un switch par rapport à la valeur de $1 (le premier argument) selon qu'il vaille container, network ou image on apelle un autre
#script qui va traiter ces cas, on garde les fichiers courts mais simples


export PATH_BALEINE="/var/lib/baleine"
export PATH_MANIFEST="$PATH_BALEINE/manifest"


if [ $# -lt 1 ]; then
    printf "Baleine est un outil simple de gestion de conteneur.\n"
    printf "Utilisation: \n \n"
    printf "\t \t baleine <commande> [arguments]\n"
    printf "Les commandes sont :\n \n"
    printf "\t \t %-10s %-10s \n" "container"  "Lance ou stoppe un contenneur."
    printf "\t \t %-10s %-10s \n" "bridge" "Créée ou supprime des commutateurs linux virtuels."
    printf "\t \t %-10s %-10s \n \n" "image" "Créer ou supprime des images de contenneurs."
    printf "Utilisez baleine <commande> help pour plus d'informations à propos d'une commande.\n"
fi

case "$1" in
    "container")
        #Si on a apelé ./baleine.sh container create par exemple, on va apeller le script container.sh qui va traiter les
        #opérations sur les containers, et $@ permet de lui passer tous les arguments qu'on a passé à baleine.sh
        #autrement dit, ./baleine.sh container create apellera le script container.sh avec les arguments $1=container et $2=create
        bash container.sh "${@:2}"
    ;;
    "image")
        bash image.sh "${@:2}"
    ;;
    "bridge")
        bash bridge.sh "${@:2}"
    ;;
    "help")
        bash help.sh
    ;;
esac