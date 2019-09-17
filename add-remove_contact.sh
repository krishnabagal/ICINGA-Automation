#!/bin/bash
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
# Script Name: icinga.sh
# Date: May 24th, 2018. 
# Modified: NA.
# Versioning: NA
# Author: Krishna Bagal.
# Info: Scrip to add/delete host/service entory from ICINGA.
# Ticket: NA
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
# Parse parameters
while [ $# -gt 0 ]; do
case "$1" in
	-n | --name)
		shift
		NAME=$1
	 	;;
	-e | --email)
		shift
		EMAIL=$1
	 	;;
	-p | --phone)
		shift
		PHONE=$1
	 	;;
	-s | --status)
		shift
		STATUS=$1
	 	;;
	esac
shift
done

contactfile=`ls -1 /home/icinga/objects/gupshupcontacts.cfg`

if [ -f $contactfile ];
then
	if [ "$STATUS" == "add" ];
	then
		echo "define contact{						;#contact-$NAME  ">>$contactfile
		echo "  	contact_name    $NAME				;#contact-$NAME  ">>$contactfile
		echo "  	use		generic-contact			;#contact-$NAME  ">>$contactfile
		echo "  	alias          	$NAME				;#contact-$NAME  ">>$contactfile
		echo "  	email		$EMAIL				;#contact-$NAME  ">>$contactfile
		echo "  	pager   	$PHONE				;#contact-$NAME  ">>$contactfile
		echo "}								;#contact-$NAME  ">>$contactfile
	elif [ "$STATUS" == "remove" ];
	then
		hostfile=`grep -ril $NAME /home/icinga/`
		/bin/sed -i '/#contact-'$NAME'/d' $hostfile		
	fi
else
	echo "gupshupcontacts.cfg File Not Found."
fi	
