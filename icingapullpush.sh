#!/bin/bash
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
#Script Name: icingapullpush.sh
#Date: July 2nd, 2018. 
#Modified: NA
#Versioning: NA
#Author: Krishna Bagal.
#Info: Pull ICINGA repo and reload ICINGA daemon. 
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
HOSTNAME=`hostname -f`
MSG="Pull ICINGA Changes on $HOSTNAME"

#empty error log file
>/tmp/icinglog

#date
date=`date +%d,%h%Y\ %H:%M`

#change working directory
cd /etc/icinga/

#removed or revert changes if not committed
git stash
git stash clear

#check before staus
before=$(git rev-parse HEAD)

#pull repo from icinga server
git pull

#check after status
after=$(git rev-parse HEAD)

#check any error 
/usr/sbin/icinga -v /etc/icinga/icinga.cfg > /tmp/icinglog

if [ $? == 0 ];then 
        echo OK
                if [ $before == $after ];then
                        echo "ICINGA files are upto date."
                else
                        /etc/init.d/icinga reload
                fi
else
        /usr/bin/mutt -s "ICINGA:Git Pull Error:$date " root@krishnabagal.com < /tmp/icinglog
fi

