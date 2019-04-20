#!/bin/bash

cd $PATH_MANIFEST/containers

for eachfile in ./*.manifest
do 
	echo $eachfile
	val=$(cat "$eachfile")
	echo $val
done
