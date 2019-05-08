#!/bin/bash

for eachfile in $PATH_MANIFEST/images/*.manifest
do 
	#Test si des fichiers sont présents
	test -f "$eachfile" || continue
	NOM_IMAGE=$(grep nom_image $eachfile | cut -d ':' -f2)
	TAILLE=$(grep taille $eachfile | cut -d ':' -f2)
	CHEMIN=$(grep chemin $eachfile | cut -d ':' -f2)
	echo "----------------------"
	echo "Nom image: $NOM_IMAGE"
	echo "Taille: $TAILLE"
	echo "Chemin: $CHEMIN"
	echo "----------------------"
done
