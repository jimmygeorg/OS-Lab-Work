#!/bin/bash

sum=0

while [ 1 ]
do

	echo -n "Enter integer 1: "
	read int1 #Εισαγωγη 8δικου αριθμου


	echo -n "Enter integer 2: "
	read int2 #Εισαγωγη 10δικου αριθμου

	echo -n "Enter a dir (Type "exit" to terminate): "
	read inDir #Εισαγωγη path καταλογου

	
	if [ "$inDir" == "exit" ]; then
			echo "Total number of files/directories: $sum"
			echo "Press Enter to close window"
    		read -r keyPress

    		if [ -z "$keyPress" ]; then
        		break
    		fi
			break

	fi


	while [ 1 ]	#ελεγχος για το αν υπαρχει το directory
	do

		if [ ! -d "$inDir" ]; then
			printf "Error: Directory $inDir not found.\n\n"

			echo -n "Enter a dir (Type "exit" to terminate): "
			read inDir #Εισαγωγη path καταλογου
		else
			break

		fi

		if [ "$inDir" == "exit" ]; then
			echo "Total number of files/directories: $sum"
			echo "Press Enter to close window"
    		read -r keyPress

    		if [ -z "$keyPress" ]; then
        		break
    		fi

		fi
			
	done


	int1="$int1"
	int2="$int2"
	Directory="$inDir"

	printf "\nSearching for files with permission $int1...\nNumber of files: "
	file_count=$(find "$inDir" -type f -perm "$int1" -print | wc -l)	#Υπολογισμος αριθμου αρχειων που εχουν αδειες(int1)

	echo $file_count

	((sum=sum+file_count))
	find "$inDir" -type f -perm "$int1" -print


	days="$int2"

	printf "\n------------------------\n\n"

	printf  "Files in $inDir modified over the last $int2 days:\nNumber of files: "	#Υπολογισμος αριθμου αρχειων που τροποποιηθει τις τελευταιες(int2) μερες
	mod_file_count=$(find "$inDir" -type f -mtime -$days -print | wc -l)

	echo $mod_file_count
	
	((sum=sum+mod_file_count))
	find "$inDir" -type f -mtime -$days -print

	printf "\n------------------------\n\n"

	printf  "Subdirectories in $inDir accessed over the last $int2 days:\nNumber of files: " #Υπολογισμος αριθμου υποκαταλογων που εχουν ανοιχτει τις τελευταιες(int2) μερες
	sub_count=$(find "$inDir" -type d -atime -$days -print | wc -l)

	echo $sub_count

	((sum=sum+sub_count))
	find "$inDir" -type d -atime -$days -print

	printf "\n------------------------\n\n"

	printf  "Files in $inDir that all users have reading permissions for:\nNumber of files: "
	read_count=$(ls -l | grep -E '^-r\S\Sr\S\Sr\S\S\s' | wc -l)	#Υπολογισμος αριθμου αρχειων για τα οποια ολοι οι χρηστες εχουν αδεια να τα διαβασουν

	echo $read_count

	((sum=sum+read_count))
	ls -l| grep -E '^-r\S\Sr\S\Sr\S\S\s'
	
	printf "\n------------------------\n\n"

	printf  "Subdirectories in $inDir that all users have write access to:\nNumber of Subdirectories: "
	wa_count=$(ls -ld "$inDir"| grep -E 'w..[^\ ]'| wc -l)	#Υπολογισμος αριθμου αρχειων για τα οποια ολοι οι χρηστες εχουν αδεια να τα διαβασουν

	#Η εντολή ls -ld εμφανιζει μονο τους υποκαταλογους του τρεχοντος καταλογου με πληροφοριες για τον καθενα
	#Η εντολη grep -E 'w..[^\ ]' εμφανιζει μονο τους καταλογους για τους οποιους καποιος χρηστης εχει write access. Η εντολη 'w..[^\ ]'
	#ψαχνει να βρει το w στα bit αδειων για τους others

	echo $wa_count
	((sum=sum+read_count))
	ls -ld "$inDir" | grep -E 'w..[^\ ]'

	printf "\n------------------------\n\n"
done

