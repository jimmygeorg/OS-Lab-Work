#!/bin/bash

echo -n "Enter dir1: "
read indir1	#Εισαγωγη path 1ου καταλογου

echo -n "Enter dir2: "
read indir2	#Εισαγωγη path 2ου καταλογου

Dir1="$indir1"
Dir2="$indir2"

while [ 1 ]; do
    if [ ! -d "$Dir1" ]; then
        echo "Error: Directory $Dir1 not found."
        echo -n "Enter dir1: "
        read Dir1
    fi

    if [ ! -d "$Dir2" ]; then
        echo "Error: Directory $Dir2 not found."
        echo -n "Enter dir2: "
        read Dir2
    fi

    if [ -d "$Dir1" ] && [ -d "$Dir2" ]; then
        break
    fi
done



diff1=$(comm -23 <(ls "$Dir1") <(ls "$Dir2"))
diff2=$(comm -23 <(ls "$Dir2") <(ls "$Dir1"))

#Με την εντολη diff συγκρινουμε το περιεχομενο των καταλογων. Η πρωτη εντολη συγκρινει τα περιεχομενα του 1ου καταλογου με αυτα του 2ου και η 2η γραμμη
#κανει το αναποδο. Ετσι, στο τελος, το diff1 περιεχει τα αρχεια που υπαρχουν στο dir1 και οχι στο dir2 και, αντιστοιχως. η diff2 περιεχει τα αρχεια που 
#υπαρχουν στο dir2 και οχι στο dir1.

echo "Files only in $Dir1:"
echo "$diff1"

printf "\n\n"

echo -e "Files only in $Dir2:"
echo "$diff2"


total_size=$(du -sh $Dir1 $Dir2 | awk '{print $1}' | paste -sd+ - | bc)

#Με την εντολη du -sh $Dir1 $Dir2 εμφανιζουμε το μεγεθος καθε directory σε μορφη κατανοητη απο τον ανθρωπο
#Με την εντολη awk '{print $1}' εμφανιζεται η πρωτη στηλη του αποτελεσματος (του du )σε κατανοητη μορφη
#Με την εντολη paste -sd+ - στη ουσια τα αποτελεσματα του du μπαινουν στη σειτα με το delimiter '+' αναμεσα τους
#Με την εντολη bc γινεται η πραξη μεταξυ των προηγουμενων αποτελεσματων, οδηγωντας μας στο τελικο μεγεθος

echo "Total size: $total_size"


common_files=$(comm -12 <(ls "$Dir1" | sort) <(ls "$Dir2" | sort))

#Η εντολη comm καθοριζει ποιες γραμμες "κρυβονται" στην τελικη εξοδο
# -1: Κρυβει τις γραμμες που ειναι αποκλειστικα του πρωτου ορισματος
# -2: Κρυβει τις γραμμες που ειναι αποκλειστικα του δευτερου ορισματος
# -3: Κρυβει τις γραμμες που ειναι και των 2 ορισματων
#Ετσι, με το -12 "κρυβουμε" τις γραμμες που ειναι ξεχωριστες για καθε ορισμα, επομενως εμφανιζονται οι κοινες τους.



total_common_size=0

if [ -n "$common_files" ]; then	#ελεγχουμε αν το total_common_files ειναι αδειο (=0)
	
	echo -e "\nCommon files: $common_files"
    total_common_size=$(du -sh $(echo "$common_files") | awk '{print $1}' | paste -sd+ - | bc)	#αν ειναι αδειο, υπολογιζουμε το συνολικο μεγεθος


	echo "Total size of common files: $total_common_size"

	echo -e "\nEnter directory to move common files: "
	read cmn_dir

	CommonDir="$cmn_dir"

	while [ 1 ]; do
	    if [ ! -d "$CommonDir" ]; then
	        echo "Error: Directory $CommonDir not found."
	        echo -e "\nEnter directory to move common files: "
	        read CommonDir
	    else
	    	break
	    fi
	done
	

	for file in $common_files; do
    	mv "$Dir2/$file" "$CommonDir"
    	rm -f "$Dir2/$file"
	done



	for file in "$CommonDir"/*; do
    	ln -f "$file" "$Dir1" && echo "Link created: $file to $Dir1"
    	ln -f "$file" "$Dir2" && echo "Link created: $file to $Dir2"
	done


	echo -e "\nCommon Files moved to $CommonDir"
	

	#echo -e "\n$CommonDir I-nodes:"
	#ls -i "$CommonDir"
	
	#echo -e "\n$Dir1 I-nodes:"
	#ls -i "$Dir1"

	#echo -e "\n$Dir2 I-nodes:"
	#ls -i "$Dir2"
else
	echo -e "\nNo common files."
	
fi
