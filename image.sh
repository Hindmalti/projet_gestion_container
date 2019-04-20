#!/bin/bash

case $1 in
    "create")
        #Si on veut creer une image (qu'on a apellé le script ./balaine.sh image create)
        bash create_image.sh "${@:2}"
        ;;
    "list")
        #Si on veut lister les images (qu'on a apellé le script ./balaine.sh image list)
        bash list_images.sh "$@"
        ;;
    "import")
        bash import_container.sh "$@"
        ;;
    "export")
        bash export_container.sh "$@"
               ;;
    "remove")
        bash remove_image.sh "$@"
esac