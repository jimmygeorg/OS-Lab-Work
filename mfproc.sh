#!/bin/bash

UserName="$1"
State="$2"

if [ $# -eq 0 ]; then
	ps -eo comm,pid,ppid,uid,gid,state --no-headers | awk 'BEGIN { printf "%-15s %-8s %-8s %-8s %-8s %-8s\n", "Name", "PID", "PPID", "UID", "GID", "State" } { printf "%-15s %-8s %-8s %-8s %-8s %-8s\n", $1, $2, $3, $4, $5, $6 }'	
	exit 0
fi

if [ $# -eq 1 ]; then
	while [ 1 ]; do
		if  id "$UserName" &>/dev/null ; then
		    break
		else
		    echo "$UserName is not a system user."
		    exit 1
		fi
	done

	ps -u "$UserName" -o comm,pid,ppid,uid,gid,state --no-headers | awk 'BEGIN { printf "%-15s %-8s %-8s %-8s %-8s %-8s\n", "Name", "PID", "PPID", "UID", "GID", "State" } { printf "%-15s %-8s %-8s %-8s %-8s %-8s\n", $1, $2, $3, $4, $5, $6 }'	
	exit 0
fi


if [ $# -eq 2 ]; then
	while [ 1 ]; do
		if  id "$UserName" &>/dev/null ; then
		    break
		else
		    echo "$UserName is not a system user."
			exit 1
		fi
	done

	if [ "$State" != "S" ] && [ "$State" != "R" ] && [ "$State" != "Z" ];then
		echo "No processes in state $State"
		exit 2
	else
		ps -u "$UserName" -o comm,pid,ppid,uid,gid,state --no-headers | awk -v state="$State" 'BEGIN { printf "%-15s %-8s %-8s %-8s %-8s %-8s\n", "Name", "PID", "PPID", "UID", "GID", "State" } { if ($6 == state) printf "%-15s %-8s %-8s %-8s %-8s %-8s\n", $1, $2, $3, $4, $5, $6 }'
		exit 0
	fi
fi












