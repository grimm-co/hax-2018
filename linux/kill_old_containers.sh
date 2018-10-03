#!/bin/bash

HOUR=$((60*60))
DAY=$(($HOUR*24))
TIMEOUT=$((HOUR*12))
while true
do
	for i in `docker ps -aq`
	do
		THEN=`docker inspect --format='{{.State.StartedAt}}' $i | xargs date +%s -d`
		NOW=`date +%s`
		if [ $((NOW-THEN)) -gt $TIMEOUT ]
		then
			docker stop $i
			docker rm $i
		fi
	done
	sleep 5
done
