  #!/bin/bash


while getopts i:s:r: o; do
    case $o in
        (i) NOM_IMAGE=$OPTARG;;
        (s) SIZE=$OPTARG;;
        (r) REPERTOIRE=$OPTARG;;
        (p) PROXY=$OPTARG;;
    esac
done

#Block size vaut 1024 (allocution par 1 MB)
if [ "$SIZE" == "" ] || [ "$SIZE" -lt 0 ] || [ "$SIZE" -gt 10240 ]; then
    SIZE=10240
fi

echo "Création d'une image de taille $SIZE"

mkdir -p $PATH_BALEINE/images

if [[ -z $REPERTOIRE ]]; then
    REPERTOIRE=$PATH_BALEINE/images
fi

if [[ -z "$NOM_IMAGE" ]]; then
    echo "Il faut donner le nom de l'image ! Relancez la commande avec les bons arguments."
    exit
fi

#Crée image

MANIFEST=$NOM_IMAGE.manifest

dd if=/dev/zero of=$REPERTOIRE/$NOM_IMAGE bs=1024k count=$SIZE

echo "nom_image:$NOM_IMAGE" >> $MANIFEST
echo "taille:$SIZE">> $MANIFEST
echo "chemin:$REPERTOIRE">> $MANIFEST



if [[ ! -d "$PATH_MANIFEST/images" ]]; then
    mkdir -p $PATH_MANIFEST/images
fi

mv $NOM_IMAGE.manifest $PATH_MANIFEST/images


if [[ -z "$FORMAT" ]]; then
    FORMAT=ext4
fi

mkfs.ext4 $REPERTOIRE/$NOM_IMAGE

if [[ $PROXY != "" ]]; then
    echo "Export du proxy"
    export http_proxy=http://proxy.polytech-lille.fr:3128
fi

#Création de l'arborescence Debian avec debootstrap
echo "Je vais faire le debootstrap"
mkdir -p /mnt/baleine/$NOM_IMAGE
mount -t ext4 -o loop $REPERTOIRE/$NOM_IMAGE /mnt/baleine/$NOM_IMAGE 
debootstrap --include=apache2,vim,nano  stable /mnt/baleine/$NOM_IMAGE
umount /mnt/baleine/$NOM_IMAGE
rm -rf /mnt/baleine/$NOM_IMAGE