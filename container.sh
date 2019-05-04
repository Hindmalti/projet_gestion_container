#!/bin/bash

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
    "restart")
        bash restart_container.sh "${@:2}"
        ;;  
    "exec")
        bash exec_container.sh "${@:2}"
        ;;        
 
esac