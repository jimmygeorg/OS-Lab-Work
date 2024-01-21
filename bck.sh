#!/bin/bash

if [ $# -eq 3 ]; then
 	UserName="$1"
	sourcePath="$2"
	destPath="$3"


	while [ 1 ]; do
		if  id "$UserName" &>/dev/null ; then
		    break
		else
		    echo "$UserName is not a system user."
			echo "Enter Username: "
			UserName="$1"
		fi
	done


	while [ 1 ]; do
		if [ ! -e "$sourcePath" ]; then
			echo "Path doesn't exist"
			echo "Enter directory or file path to backup: "
			read sourcePath
		else
			break
		fi

	done


	while [ 1 ]; do
		if [ ! -e "$destPath" ]; then
			echo "Path doesn't exist"
			echo "Enter directory or file path to save backup: "
			read destPath
		else
			break
		fi

	done

	if [ -d "$destPath" ]; then
	    tar -cf backup.tar "$sourcePath" 
	    mv backup.tar "$destPath"
	elif [ -f "$destPath" ]; then
	    #tar -cf backup.tar "$sourcePath" 
	      tar -rf backup.tar "$sourcePath" --transform="s|^$(dirname "$destPath")/||" "$(basename "$destPath")"
			#Με αυτη την εντολη η tar αγνοει το full path του αρχειου, με αποτελεσμα να προσαρτηθει μονο αυτο και οχι ολοι υποκαταλογοι	    
	fi

else
	echo "Not enough arguments"
	exit 1
fi

if [ -e backup.tar ];then 
	echo "Backup complete."
else
	echo "Backup failed"
fi



