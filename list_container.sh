#!/bin/bash

for eachfile in $PATH_MANIFEST/containers/*.manifest
do 
	#Test si des fichiers sont présents
	test -f "$eachfile" || continue
	NOM_CONTAINER=$(grep nom_container $eachfile | cut -d ':' -f2)
	NOM_IMAGE=$(grep nom_image $eachfile | cut -d ':' -f2)
	PID=$(grep pid $eachfile | cut -d ':' -f2)
	TIME=$(grep starting_time $eachfile | cut -d':' -f2)
	INTERFACES=$(grep interfaces $eachfile | cut -d':' -f2)
	echo "----------------------"
	echo "Nom container: $NOM_CONTAINER"
	echo "Nom image: $NOM_IMAGE"
	echo "PID: $PID"
	echo "Starting time: $TIME"
	echo "Interfaces: $INTERFACES"
	echo "----------------------"
done
