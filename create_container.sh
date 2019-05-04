#!/bin/bash

set -x 
while getopts i:c:b:r:a:p: o; do
    case $o in
        (i) NOM_IMAGE=$OPTARG;;
        (c) NOM_CONTAINER=$OPTARG;;
        (b) BRIDGES=$OPTARG;;
        (r) REPERTOIRE=$OPTARG;;
        (a) ADDRS_IPV4=$OPTARG;;
        (p) PROGRAM=$OPTARG;;
    esac
done

echo "Creation du container $NOM_CONTAINER basé sur l'image $NOM_IMAGE lancant le programme $PROGRAM connecté au(x) bridge(s) $BRIDGES avec les adresses $ADDRS_IPV4"
#/usr/local/apache2/bin

#Check existence image, bridge
if [ -z "$PATH_MANIFEST/images/$NOM_IMAGE.manifest" ] || [ -z $NOM_IMAGE ]; then
    echo "Image non existante."
    exit
fi

if [ ! -z $NOM_BRIDGE ] || [ -z "$PATH_MANIFEST/bridges/$NOM_BRIDGE.manifest" ]; then
    echo "Bridge non existant."
    exit
fi

#On veut récupérer le chemin de l'image
PATH_IMAGE="$(grep chemin $PATH_MANIFEST/images/$NOM_IMAGE.manifest | cut -d':' -f2)"

echo "PATH_IMAGE: $PATH_IMAGE"
#on fait une copie dans /var/baleine/images pour mount depuis le conteneur
if [[ ! -d "$PATH_BALEINE/containers/$NOM_CONTAINER" ]]; then
    mkdir -p $PATH_BALEINE/containers/$NOM_CONTAINER
fi


#Copie de l'image physique dans le container
cp -r $PATH_IMAGE/$NOM_IMAGE $PATH_BALEINE/containers/$NOM_CONTAINER/$NOM_IMAGE


#création du du dossier de montage de l'image du container

if [[ ! -d "/mnt/baleine/$NOM_CONTAINER" ]]; then
    mkdir -p /mnt/baleine/$NOM_CONTAINER
fi

#on monte le système de fichiers
echo "Montage de l'image"
mount -t ext4 -o loop $PATH_BALEINE/containers/$NOM_CONTAINER/$NOM_IMAGE /mnt/baleine/$NOM_CONTAINER

#On renseigne le fichier fstab du conteneur
echo "proc /proc proc defaults 0 0" >> /mnt/baleine/$NOM_CONTAINER/etc/fstab
echo "$PROGRAM" >> /mnt/baleine/$NOM_CONTAINER/etc/rc.local

#On fait le unshare sur l'image passée en paramètre,
#nohup unshare -p -f -m -n -u chroot /mnt/baleine/$NOM_CONTAINER "/bin/bash" -c "mount /proc" &



PID=$!
echo "j'ai finis le unshare-nohup"

ps axo ppid,pid | grep "^ *$PID" | sed -e 's/.* //'
echo $PID

FILE=$NOM_CONTAINER.manifest
touch $FILE #création du fichier
date=${date}

echo "nom_container:$NOM_CONTAINER" >> $FILE #nom de son image
echo "nom_image:$NOM_IMAGE" >> $FILE #nom de son image
echo "pid:$PID" >> $FILE #Son PID 
echo "nom_bridge:$NOM_BRIDGE" >> $FILE #SON BRIDGE
echo "starting_time: $date" >> $FILE #starting time


if [[ ! -d "$PATH_MANIFEST/containers" ]]; then
    mkdir -p $PATH_MANIFEST/containers
fi

mv $NOM_CONTAINER.manifest $PATH_MANIFEST/containers/$NOM_CONTAINER.manifest


#TODO : taille mémoire / limite mémoire

#AWK pour récupèrer le nombre d'addresses IPV4 données en arguments
#(https://unix.stackexchange.com/questions/144217/counting-comma-separated-characters-in-a-row)

NOMBRE_INTERFACES="$(echo $ADDRS_IPV4 | awk -F '[,]' '{print NF}')"

NOMBRE_BRIDGES="$(echo $BRIDGES | awk -F '[,]' '{print NF}')"

if [ $NOMBRE_INTERFACES -ne $NOMBRE_BRIDGES ]; then
    echo "Erreur: Il n'y a pas autant de bridges que d'interfaces réseaux"
    exit 1
fi

for i in $(seq 1 $NOMBRE_INTERFACES); do
    echo "Nom de l'interface : $NOM_CONTAINER$i"
    ip link add $NOM_CONTAINER$i type veth peer name eth$i
done

echo "J'ai fini de créer les interfaces chef"

#Compte le nombre de bridges présents
NOMBRE_BRIDGES=$(echo $BRIDGES | awk -F '[,]' '{print NF}')

IFS=","

ARRAY_BRIDGES=()
ARRAY_IPV4=()

for b in $BRIDGES; do
    ARRAY_BRIDGES+=(b)    
done

for a in $ADDRS_IPV4; do
    ARRAY_IPV4+=(a)
done

for (( i=0 ; i < ${#ARRAY_IPV4[*]} ; i++ )); do
    #Creation de la veth
    #ip link add dev $NOM_CONTAINER$i type veth peer name eth$i@$NOM_CONTAINER$i
    ip link add dev vif1 type veth peer name eth0@vif1
    #Ajout d'une des extrémités de la veth dans le namespace du container
    #ip link set eth$i@$NOM_CONTAINER$i netns proc/$PID/ns/net name eth$i
    ip link set eth0@vif1 netns proc/$PID/ns/net name eth0
    #Attribution de l'adresse ip à l'interface du container
    #ip netns exec proc/$PID/ns/net ip addr add ${ARRAY_IPV4[i]} dev eth$i
    ip netns exec proc/$PID/ns/net ip addr add ${ARRAY_IPV4[i]} dev eth0
    ip netns exec proc/$PID/ns/net ip link set dev eth0 down
    ip netns exec proc/$PID/ns/net ip link set dev eth0 up

done

for (( i=0 ; i < ${#ARRAY_BRIDGES[*]} ; i++ )); do
    ip link set $NOM_CONTAINER$i master ${ARRAY_BRIDGES[i]}
done