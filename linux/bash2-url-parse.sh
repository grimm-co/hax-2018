#!/bin/bash

parsed=`echo $1 | sed -En 's#^(https?):/+([^/]*)/+?(.*)?#\1:\2:\3#pI'`
parsed2=`echo $parsed | cut -d: -f3- | sed -En 's#^([^\?]*)\??(.*)?#\1:\2#pI'`
echo scheme=$(echo $parsed | cut -d: -f1)
echo url=$(echo $parsed | cut -d: -f2)
echo path=/$(echo $parsed2 | cut -d: -f1)
echo params=$(echo $parsed2 | cut -d: -f2)
