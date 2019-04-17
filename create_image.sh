#!/bin/bash
#TOUT MARCHE BIEN ICI

NOM_IMAGE=$3; # L'utilisateur devra spécifier le nom de l'image
SIZE=$4; #L'utilisateur devra spécifier la taille du disque qu'il souhaite allouer 
REPERTOIRE=$5; #L'utilisateur devra spécifier le chemin ou il mettra l'image

#ici block size vaut 1024 (on alloue par 1 méga) 
# La commande resseblera à : ./baleine.sh image create nom 5120 


#condition de bordure pour SIZE
if [ "$SIZE" -lt 0 ] || [ "$SIZE" -gt 10240 ] || [ -z $SIZE ]; then #vérifie que l'argument size est bien donné, qu'il n'est pas supérieur ou inférieur à 0 / 10240
    echo "Mauvaise valeur, on met par défaut 10 Giga ! "
    $SIZE=10240
fi

mkdir -p /usr/lib/baleine/images

#condition pour le répertoire
if [[ -z $REPERTOIRE ]]; then #si l'utilisateur oublie de donner le path on utilise celui-ci par défaut 
  echo "Il n'y pas eu d'argements donnés pour répertoire, je fais moi même le chemin" 
  REPERTOIRE=/var/lib/baleine/images
fi

#vérification que l'utilisateur donne bien un nom à l'image
if [[ -z "$NOM_IMAGE" ]]; then 
  echo "Il faut donner le nom de l'image ! Relancez la commande avec les bons arguments."
  exit
fi
#génération de nombres aléatoires afin de créer à chaque fois un fichier avec un nombre unique (éviter qu'un soit écraser)
NUMBER=$(cat /dev/urandom | tr -dc '0-9' | fold -w 256 | head -n 1 | sed -e 's/^0*//' | head --bytes 3)
if [ "$NUMBER" == "" ]; then
  NUMBER=0
fi
echo $REPERTOIRE
#Crée image
echo "Je vais commencer à allouer !"
dd if=/dev/zero of=$REPERTOIRE/$NOM_IMAGE bs=1024k count=$SIZE 
touch  $NOM_IMAGE.$NUMBER.manifest
echo "$NOM_IMAGE" >> $NOM_IMAGE.$NUMBER.manifest #nom de l'image
echo "$SIZE">> $NOM_IMAGE.$NUMBER.manifest #taille de l'image
echo "$REPERTOIRE/$NOM_IMAGE">> $NOM_IMAGE.$NUMBER.manifest #son chemin

if [[ ! -d "$REPERTOIRE/baleine/Images" ]]; then 
  mkdir -p $REPERTOIRE/baleine/Images && mv $NOM_IMAGE.$NUMBER.manifest $REPERTOIRE/baleine/Images
fi
mv $NOM_IMAGE.$NUMBER.manifest $REPERTOIRE/baleine/Images



#création du système de fichiers au format "ext4"
mkfs.ext4 $REPERTOIRE/$NOM_IMAGE



echo "je vais exporter le proxy"
export http_proxy=http://proxy.polytech-lille.fr:3128

#Création de l'arborescence Debian avec debootstrap
echo "Je vais faire le debootstrap"
debootstrap --include=apache2,vim,nano  stable /mnt/$NOM_IMAGE

#On renseigne le fichier fstab du conteneur
echo "proc /proc proc defaults 0 0" >> /mnt/$NOM_IMAGE/etc/fstab