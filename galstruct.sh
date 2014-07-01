#!/bin/bash

if [ $# -ne 7 ]
then
    echo \
"Usage: galstruct [RA/Dec hours file] [distances file]
                  [cartesian output]  [ellipsoid output]
                  [center RA] [center Dec] [band {I,V}]"
    exit 1
fi

radechours=$1
radec="radec.dat"
galac="galac_lmc.dat"
distances=$2
cartesian=$3
ellipsoid=$4
RA0=$5
Dec0=$6
band=$7

idl -e "raconvert"     -args $radechours $radec $galac &&
idl -e "weinberg"      -args $radec $distances $cartesian $RA0 $Dec0 $band &&
idl -e "ellipsoid"     -args $cartesian $ellipsoid
