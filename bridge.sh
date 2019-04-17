#!/bin/bash

case $2 in

    "create")
        #Si on veut creer un bridge (qu'on a apellé le script ./balaine.sh bridge create)
        bash create_bridge.sh "$@"
        ;;
    "list")
        #Si on veut lister les bridges (qu'on a apellé le script ./balaine.sh bridge list)
        bash list_bridges.sh "$@"
        ;;
    "remove")
        bash remove_bridge.sh "$@"
           ;;
    "up")
        bash up_bridge.sh "$@"
           ;;
    "down")
        bash down_bridge.sh "$@"
esac