#!/bin/bash
cd $PATH_MANIFEST/bridges

for eachfile in ./*.manifest
do 
	echo $eachfile
	val=$(cat "$eachfile")
	echo $val
done