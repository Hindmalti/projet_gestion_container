#!/bin/bash

BRIDGES="pont,petitpont"
ADDRS_IPV4="lala,lulu"

ARRAY_BRIDGES=()
ARRAY_IPV4=()

IFS=','
for b in $BRIDGES; do
    ARRAY_BRIDGES+=($b)    
done

for a in $ADDRS_IPV4; do
    ARRAY_IPV4+=($a)
done


for ((i = 0, j = 0 ; i < ${#ARRAY_BRIDGES[*]} && j < ${#ARRAY_BRIDGES[*]} ; i++, j++ )); do
    echo "i= ${ARRAY_BRIDGES[i]}"
    echo "j= ${ARRAY_IPV4[j]}"
done