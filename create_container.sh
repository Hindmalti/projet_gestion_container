#!/bin/bash
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

#Check existence image
if [ -z "$PATH_MANIFEST/images/$NOM_IMAGE.manifest" ] || [ -z $NOM_IMAGE ]; then
    echo "Image non existante."
    exit
fi

#Check existence bridge
if [ ! -z $NOM_BRIDGE ] || [ -z "$PATH_MANIFEST/bridges/$NOM_BRIDGE.manifest" ]; then
    echo "Bridge non existant."
    exit
fi

#On veut récupérer le chemin de l'image
PATH_IMAGE="$(grep chemin $PATH_MANIFEST/images/$NOM_IMAGE.manifest | cut -d':' -f2)"

#On fait une copie dans /var/baleine/images pour mount depuis le conteneur
if [[ ! -d "$PATH_BALEINE/containers/$NOM_CONTAINER" ]]; then
    mkdir -p $PATH_BALEINE/containers/$NOM_CONTAINER
fi

cp $PATH_IMAGE/$NOM_IMAGE $PATH_BALEINE/containers/$NOM_CONTAINER/$NOM_IMAGE


#Création du du dossier de montage de l'image du container

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

nohup unshare -p -f -m -n -u chroot /mnt/baleine/$NOM_CONTAINER /bin/sh -c "mount /proc ; $PROGRAM ; while true ; do sleep 10 ; done" &
PID=$!

echo "PID Unshare :$PID"

FILE=$NOM_CONTAINER.manifest
date=$(date +"%Y-%m-%d-%Hh-%Mm-%Ss")

echo "nom_container:$NOM_CONTAINER" >> $FILE #nom du conteneur
echo "nom_image:$NOM_IMAGE" >> $FILE #nom de son image
echo "pid:$PID" >> $FILE #Son PID 
echo "nom_bridges:$BRIDGES" >> $FILE #SON BRIDGE
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

#Creation veth
#Problématique : Sur Linux, impossible d'avoir des interfaces avec des noms de plus de 16 caractères
#                Impossible donc de mettre des interfaces du type
#Solution : On hash le nom du container, on le ramène aux trois premiers digits, puis on ajoute l'index

ARRAY_INTERFACES=()

for ((i = 0 ; i<$NOMBRE_INTERFACES ; i++)); do
    #Creation d'un hash du nom du container pour créer les interfaces
    HASH=$(sha1sum <<< $NOM_CONTAINER)
    #On prend les trois premiers caractères du hash, succédé de l'index de l'interface
    INTERFACE_NAME="vif${HASH:0:4}_$i"
    ip link add $INTERFACE_NAME type veth peer name eth$i@$INTERFACE_NAME
    #On rajoute l'interface à la liste des interfaces du container
    ARRAY_INTERFACES+=($INTERFACE_NAME)
    
    #On redemarre l'interface virtuelle
    ip link set dev $INTERFACE_NAME down
    ip link set dev $INTERFACE_NAME up

    #On place l'une des extrémité de la paire veth dans le namespace du container
    ip link set eth$i@$INTERFACE_NAME netns /proc/$PID/ns/net name eth$i
done

#Compte le nombre de bridges présents
NOMBRE_BRIDGES=$(echo $BRIDGES | awk -F '[,]' '{print NF}')

#On met le séparateur à "," pour délimiter les addresses ip et bridges
IFS=","

ARRAY_BRIDGES=()
ARRAY_IPV4=()

for b in $BRIDGES; do
    ARRAY_BRIDGES+=($b)    
done

for a in $ADDRS_IPV4; do
    ARRAY_IPV4+=($a)
done

for (( i=0 ; i < ${#ARRAY_IPV4[*]} ; i++ )); do
    #Attribution de la i-ème adresse ip à l'interface i
    nsenter -t $PID -n ip a add ${ARRAY_IPV4[i]} dev eth$i
    #On redemarre l'interface i dans le container
    nsenter -t $PID -n ip link set dev eth$i down
    nsenter -t $PID -n ip link set dev eth$i up
done

for (( i=0 ; i < ${#ARRAY_BRIDGES[*]} ; i++ )); do
    #Pour chaque interface, on la relie à son bridge associé
    ip link set ${ARRAY_INTERFACES[i]} master ${ARRAY_BRIDGES[i]}
done

echo "Configuration réseau au sein du conteneur"
nsenter -t $PID -n ip a

#Chaine de caractère contenant toutes les interfaces du container, séparées par ","

STRING_INTERFACE=""
for (( i=0 ; i < ${#ARRAY_INTERFACES[*]} ; i++)); do
    STRING_INTERFACE="$STRING_INTERFACE,${ARRAY_INTERFACES[i]}"
    #Exemple, à la fin on aura ",vif143,vif560"
done

#On supprime la première virgule exédentaire

STRING_INTERFACE=${STRING_INTERFACE:1}
echo "interfaces:$STRING_INTERFACE" >> $FILE