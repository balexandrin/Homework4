#!/bin/bash


email=balexandrin@mfisoft.ru
topic=""
let MemCritical=30

MemTotal=$(grep -e MemTotal /proc/meminfo | awk '{print $2}')
MemFree=$(grep -e MemFree /proc/meminfo | awk '{print $2}')
let "MemFreePercent = $MemFree * 100 / $MemTotal"
if (($MemFreePercent <= $MemCritical)); then

    let x=0
    let y=0
    for i in $(ls -1 /proc)
    do
        if [ -e /proc/$i/status ]; then
        	x=$(cat /proc/$i/status | grep -i VMSize | awk '{print $2}')
        	if ((x>$y)); then
        	    let y=$x
        	    let j=$i
        	fi
        fi
    done
	topic="Denger"
        AlMess=$(echo 'Chef, all is lost!!! Free RAM on the server remaining '$MemFreePercent'%! Process #'$j' takes the most memory - '$y' KB! Can it kill him?')
else
    topic="Ok!"
    AlMess="Chef, all right!!!"
fi
echo $AlMess | mail -s $topic $email
