#!/bin/bash

case $2 in

    "create")
        #Si on veut creer un container (qu'on a apellé le script ./baleine.sh container create)
        bash create_container.sh "$@"
        ;;
    "list")
        #Si on veut lister les containers qui tournent (qu'on a apellé le script ./baleine.sh container list)
        bash list_container.sh "$@"
        ;;
    "stop")
        bash stop_container.sh "$@"
        ;;
    "remove")
        bash remove_container.sh "$@"
        ;;
    "restart")
        bash restart_container.sh "$@"
        ;;  
    "exec")
        bash exec_container.sh "$@"
        ;;        
 
esac