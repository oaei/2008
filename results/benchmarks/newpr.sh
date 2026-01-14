#!/bin/sh

TESTDIR=`pwd`
JAVALIB=/Java/alignapi/lib
JAVA=/usr/bin/java

COMP='aflood aroma ASMOV CIDER DSSim GeRoMe Lily MapPSO RiMOM SAMBO SAMBOdtf SPIDER TaxoMap'
FILES=refalign,`echo $COMP | sed "s: :,:g"` 

echo Precision/recall graphs...

cd RESULTS

$JAVA -Xmx1200m -cp $JAVALIB/procalign.jar fr.inrialpes.exmo.align.util.GenPlot -l $FILES -t tex -o prgraph.tex

mkdir ../NEWPR
mv *.table ../NEWPR
mv  prgraph.tex ../NEWPR

cd ..
