#!/bin/bash
cd $PWD/baleine/Bridges

for eachfile in ./*.manifest
do 
	echo $eachfile
	val=$(cat "$eachfile")
	echo $val
done