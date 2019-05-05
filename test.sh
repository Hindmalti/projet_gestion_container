#bash baleine.sh bridge create mybridge 192.168.42.1
#bash baleine.sh container create -i TEST -c mycontainer -b mybridge -a 192.168.42.2 -p /usr/sbin/apache2


PATH_IMAGE="/var/lib/baleine/images"
NOM_IMAGE="myimage"
PATH_BALEINE="/var/lib/baleine"
NOM_CONTAINER="mycontainer"

cp $PATH_IMAGE/$NOM_IMAGE $PATH_BALEINE/containers/$NOM_CONTAINER/$NOM_IMAGE