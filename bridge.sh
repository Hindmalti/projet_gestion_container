#!/bin/bash

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