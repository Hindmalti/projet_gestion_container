#!/bin/bash

cd $PWD/baleine/Images

for eachfile in ./*.manifest
do 
	echo $eachfile
	val=$(cat "$eachfile")
	echo $val
done