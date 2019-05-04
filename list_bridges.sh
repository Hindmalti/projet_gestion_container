#!/bin/bash
for eachfile in $PATH_MANIFEST/bridges/*.manifest
do 
	NOM_BRIDGE=$(grep nom_bridge $eachfile | cut -d ':' -f2)
	echo "----------------------"
	brctl show $NOM_BRIDGE 
	echo "----------------------"
done
