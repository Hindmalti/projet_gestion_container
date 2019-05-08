#!/bin/bash
for eachfile in $PATH_MANIFEST/bridges/*.manifest
do 
	#Test si des fichiers sont présents
	test -f "$eachfile" || continue
	NOM_BRIDGE=$(grep nom_bridge $eachfile | cut -d ':' -f2)
	echo "----------------------"
	brctl show $NOM_BRIDGE 
	echo "----------------------"
done
