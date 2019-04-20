#!/bin/bash
set -x
REPERTOIRE=${PWD}
NOM_IMAGE=$3;
#LIM_MEMORY=$4; NOT YET
NOM_CONTAINER=$4;
ADDR_IPV4=$5;
NOM_BRIDGE=$6;
PROGRAM=$7;


#Check existence image, bridge


#On veut récupérer le chemin de l'image
PATH_IMAGE= grep chemin $PATH_MANIFEST/images/$NOM_IMAGE.manifest | cut -d':' -f2

#on fait une copie dans /var/BaleineImages pour mount depuis le conteneur
if [[ ! -d "$PATH_BALEINE/containers/$NOM_CONTAINER" ]]; then
    mkdir -p $PATH_BALEINE/containers/$NOM_CONTAINER #&& cp $PATH_IMAGE $PATH_BALEINE/containers/$NOM_CONTAINER/
fi

cp $PATH_IMAGE $PATH_BALEINE/containers/$NOM_CONTAINER/$NOM_IMAGE

#On fait le unshare sur l'image passée en paramètre,

#on monte le système de fichiers
echo "je vais mount"
mount -t ext4 -o loop $PATH_BALEINE/containers/$NOM_CONTAINER/$NOM_IMAGE /mnt/baleine/$NOM_CONTAINER

#On renseigne le fichier fstab du conteneur
echo "proc /proc proc defaults 0 0" >> /mnt/$NOM_IMAGE/etc/fstab
echo "$PROGRAM" >> /mnt/$NOM_IMAGE/etc/rc.local

nohup unshare -p -f -m -n -u chroot /mnt/baleine/$NOM_CONTAINER $PROGRAM -c "mount /proc" &
PID=$!
echo "j'ai finis le unshare-nohup"

ps axo ppid,pid | grep "^ *$PID" | sed -e 's/.* //'
echo $PID

# #Enregistrer les infos du conteneur dans un fichier
# NUMBER=$(cat /dev/urandom | tr -dc '0-9' | fold -w 256 | head -n 1 | sed -e 's/^0*//' | head --bytes 3)
# if [ "$NUMBER" == "" ]; then
#     NUMBER=0
# fi

FILE=$NOM_CONTAINER.manifest
touch $FILE #création du fichier
echo "nom_container:$NOM_CONTAINER" >> $FILE #nom de son image
echo "nom_image:$NOM_IMAGE" >> $FILE #nom de son image
echo "pid:$PID" >> $FILE #Son PID
echo "nom_bridge:$NOM_BRIDGE" >> $FILE #SON BRIDGE

#temps d'exécution du container ?
# start_time=`date +%s`
# <command-to-execute>
# end_time=`date +%s`
# echo execution time was `expr $end_time - $start_time` s. 
# ou 
#start_time=`date +%s`
#<command-to-execute> && echo run time is $(expr `date +%s` - $start_time) s

if [[ ! -d "$PATH_MANIFEST/containers" ]]; then
    mkdir -p $PATH_MANIFEST/containers
fi

mv $NOM_CONTAINER.manifest $PATH_MANIFEST/containers/$NOM_CONTAINER.manifest


#TODO : son interface réseau (bridge) - taille mémoire / limite mémoire

#création de son interface réseau
#TODO: gerer le cas de plusieurs interfaces sur un meme container

ip link add $NOM_CONTAINER type veth peer name eth0@$NOM_CONTAINER
ip link set $NOM_CONTAINER master $NOM_BRIDGE
ip link set $NOM_CONTAINER up
ip link set eth0@$NOM_CONTAINER netns /proc/$PID/ns/net name eth0
ip netns exec /proc/$PID/ns/net ip addr add $ADDR_IPV4 dev eth0
#à voir (pour récupérer depuis la commande les n interfaces données et les n bridges ??)
#grep ipv4 $@ | wc
#grep ipv4 $@ | cut