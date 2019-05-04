#bash baleine.sh bridge create mybridge 192.168.42.1
#bash baleine.sh container create -i TEST -c mycontainer -b mybridge -a 192.168.42.2 -p /usr/sbin/apache2

A="HELLO"
B=" WORLD"

C="$A$B"

echo $C