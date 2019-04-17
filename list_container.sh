#!/bin/bash

cd $PWD/baleine/Containers

for eachfile in ./*.manifest
do 
	echo $eachfile
	val=$(cat "$eachfile")
	echo $val
done
