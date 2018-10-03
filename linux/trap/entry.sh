#!/bin/bash

while true
do
	ps aux | grep sHELL
	if [ $? -ne 0 ]
	then
		exit 0
	fi
done
