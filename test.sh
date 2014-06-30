#!/bin/bash
if [ $# -ne 3 ]
then echo \
"Usage: test  [input] [output] [ps (0 or 1)]"
exit 1
fi

input_file=$1
out_file=$2
psfile=$3
lsqfile="lst.dat"

printf "%s\n" "Processing test1.pro"
printf "%s\n" "--------------------"
idl -e "test1"  -args $input_file $out_file $psfile
printf "%s\n" "Processing test2.pro"
printf "%s\n" "--------------------"
idl -e "test2"   -args $out_file $lsqfile
echo "Least square "$lsqfile "is created"
