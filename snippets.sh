#/bin/bash

# splittare una lista di righe secondo un separatore e rendere una semiriga
awk -F "sep" '{print $2}' $file_

# rendere una sottostringa di una lista di righe i.e. whatever.fasta -> whatever
awk '{print substr($0,$substrstart,$substrend)}' #i.e. $0,0,-6

# cancellare delle colonne da determinate righe
# i.e. >GBRAB28TF 2000 3000 2500 27 729 -> >GBRAB28TF
awk -F " " '{print $1}' $file_

# inserire una linea prima/dopo una linea contenente un pattern
# $to_insert: linea da inserire; $patt:pattern
awk '/$patt/{print $to_insert}1' $file_ # insert before pattern
awk '/$patt/{print;print $to_insert;next}1' $file_ # insert after pattern

# some good recipes http://www.theunixschool.com/p/awk-sed.html

# substitute all substring with another substring
sed 's/$one/$another/' sample1.txt # first occurrence 
sed 's/$one/$another/g' sample1.txt # all occurrence 

# while working with paths, all "/" should be annulled ("\")
# OR you can use "|" as sed separator i.e.
sed 's|$one|$another|' sample1.txt

# add a string to a line matching a pattern
awk '$0 ~ /PATTERN/{print $0 " STRING TO ADD"}' $file_

# get a subset of lines (from line N to line M)
awk 'FNR>=N && FNR<=M' $file_

# get letter frequency
awk -vFS="" '{for(i=1;i<=NF;i++)w[tolower($i)]++}END{for(i in w) print i,w[i]}' file

# get total length of a genome
cat file | grep -v '>' | wc | awk '{print "total length: " $3 - $1}'

# rbind two files
awk 'NR==FNR{a[FNR]=$0;next} {print a[FNR],$0}' file1 file2

# progress bar
function pbar(){
	echo -ne '|#####                  |   (33%)\r';
	sleep 1;
	echo -ne '|#############          |   (66%)\r';
	sleep 1;
	echo -ne '|#######################|   (100%)\r';
	echo -ne '\n';
}

# remove all but the N (i.e 5) most recent files 
rm `ls -t | awk 'NR>5'`
# or the last recent files
rm `ls -tr | awk 'NR>5'`

# monitor sensors
watch -n 1 -d sensors

# convert a figure in bw
gs \
 -sOutputFile=output.pdf \
 -sDEVICE=pdfwrite \
 -sColorConversionStrategy=Gray \
 -dProcessColorModel=/DeviceGray \
 -dCompatibilityLevel=1.4 \
 -dNOPAUSE \
 -dBATCH \
 -dAutoRotatePages=/None \
 input.pdf

# prepare list of species (Multiparanoid input) from Inparanoid tables
all_species=`ls INPDIR/ | grep ^table | sed 's/table.//g' | awk -F "-" '{print $1}' | uniq`
out=`echo $all_species | sed 's\ \+\g'`
# same task, more "bashy"
function join { local IFS="$1"; shift; echo "$*"; }
join - $all_species

