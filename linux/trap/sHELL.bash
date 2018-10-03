#!/bin/bash


lookup () {
	forbidden="vi flag > python perl find exec eval hax txt"
	for i in $forbidden;
	do
		echo $1 | grep -i $i &>/dev/null
		if [ $? -eq 0 ]
		then
			return 1
		fi
	done
	return 0
}

RED=`echo -e '\033[31m'`
NORMAL=`echo -e '\033[0m'`
if [ `whoami` == "root" ]
then
    sign="#"
else
    sign="$"
fi
prompt="`whoami`@[s]${RED}HELL${NORMAL}$sign"
trap "echo \" .....YOU CAN'T ESCAPE\";echo -n \"$prompt \"" SIGABRT SIGCHLD SIGHUP SIGINT SIGKILL SIGPIPE SIGQUIT SIGTERM SIGUSR1 SIGUSR2 SIGPROF SIGSTOP SIGTSTP

echo "Welcome to [s]${RED}HELL${NORMAL}... Good luck"
n=0
while [ 1 ]
do
    echo -n "$prompt "
    read cmd
    if [ "$cmd" == "i give up" ];
    then
        echo you are in fact, a weenie.
        exit
    fi
    if [ "${cmd:0:6}" != "please" -a "$cmd" != "" ]
    then
        i=$(($i + 1))
        if [ $i -gt 6 ]
        then
            echo "Say please. SAY PLEASE."
        fi
        echo "I'm afraid I can't do that $USER"
    elif [ "${cmd:7}" != "" -a "$cmd" != "" ]
    then
        i=0
        if echo $cmd | grep kill &>/dev/null
        then
            echo "Can't kill me"
        elif echo $cmd | egrep "\W?(ba|c|z|k|tc|fi)?(S|s)(H|h)" &>/dev/null
        then
            echo "What? This shell isn't good enough for you, bro?"
        else
            lookup "$cmd"
            res=$?
	    if [ $res -eq 1 ]
            then
                echo "Can't do that."
            else
                CMD="${cmd:7}"
                eval $CMD | egrep -v "grep|\W?(ba|c|z|k|tc|fi)?(s|S)(h|H)" | grep -iv flag
                trap "echo \" .....YOU CAN'T ESCAPE\";echo -n \"$prompt \"" SIGABRT SIGCHLD SIGHUP SIGINT SIGKILL SIGPIPE SIGQUIT SIGTERM SIGUSR1 SIGUSR2 SIGPROF SIGSTOP SIGTSTP
            fi

        fi
    fi
done
