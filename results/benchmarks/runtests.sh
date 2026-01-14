#!/bin/sh

TESTDIR=`pwd`
JAVALIB=/Java/alignapi/lib
JAVA=/usr/bin/java

COMP='aflood aroma ASMOV CIDER DSSim GeRoMe Lily MapPSO RiMOM SAMBO SAMBOdtf SPIDER TaxoMap'

#################################################################
# Clean up

echo ">>> Cleaning up"
/bin/rm -rf RESULTS EXTRACTED

#################################################################
# Create directory

cp -r benchmarks RESULTS
/bin/rm -rf RESULTS/RCS RESULTS/xslt RESULTS/refs RESULTS/NEW305

#################################################################
# unzip files

echo ">>> Unzipping files"
mkdir EXTRACTED
cd EXTRACTED
for sys in $COMP
do
unzip -quo ../ZIP/$sys.zip
done

#################################################################
### JE//: report all these discrepancies
#mv MapPSO/benchmark MapPSO/benchmarks

#################################################################
# local edit

# JE//: Report this
for test in `ls -d ../RESULTS/??? ../RESULTS/???-?|sed "s:\.\.\/RESULTS/::"`
do

# GeRoMe
#ed GeRoMe/benchmarks/$test/GeRoMe.rdf <<EOF
#1,$ s;<Ontology$;<Ontology>;
#w
#EOF

ed aflood/benchmarks/$test/aflood.rdf <<EOF
1,$ s:@::g
w
EOF

done

#################################################################
# merge

echo ">>> Merging results"

for test in `ls -d ../RESULTS/??? ../RESULTS/???-?|sed "s:\.\./RESULTS/::"`
do
for sys in $COMP
do
mv $sys/benchmarks/$test/$sys.rdf ../RESULTS/$test/
done
done

cd ..

#################################################################
## IF NECESSARY CREATE EDNA RESULTS

echo ">>> Processing edna"

cd RESULTS

/bin/rm -rf 102

$JAVA -cp $JAVALIB/procalign.jar fr.inrialpes.exmo.align.util.GroupAlign -o edna -n http://oaei.ontologymatching.org/2008/benchmarks/101/onto.rdf -i fr.inrialpes.exmo.align.impl.method.StringDistAlignment -DstringFunction=levenshteinDistance -Dnoinst=1

COMP="edna $COMP"

cd ..

#################################################################
## Adapt to the reality of results

# JE//: these one decalare UTF-8 but produce iso-latin-1
#for test in 206 207 210
#do
#for file in namesystems
#do
#	cp RESULTS/$test/$file.rdf /tmp/$file.rdf
#sed "s;utf-8;iso-8859-1;" /tmp/$file.rdf > RESULTS/$test/$file.rdf
#done
#done

#################################################################
## Eval

echo ">>> Primary evaluation"

/bin/rm -rf HTML
mkdir HTML

cd RESULTS

FILES=refalign,`echo $COMP | sed "s: :,:g"` 

for file in $COMP
do
$JAVA -Xmx1200m -cp $JAVALIB/procalign.jar fr.inrialpes.exmo.align.util.GroupEval -c -l refalign,edna,$file > ../HTML/$file.html
done

$JAVA -Xmx1200m -cp $JAVALIB/procalign.jar fr.inrialpes.exmo.align.util.GroupEval -c -l $FILES > ../HTML/results.html

$JAVA -Xmx1200m -cp $JAVALIB/procalign.jar fr.inrialpes.exmo.align.util.GroupEval -t triangle -l $FILES > ../HTML/triangle.tex

#################################################################
## GENERATE PRECISION/RECALL GRAPHS

echo Precision/recall graphs...

$JAVA -Xmx1200m -cp $JAVALIB/procalign.jar fr.inrialpes.exmo.align.util.GenPlot -l $FILES -t tex -o prgraph.tex

mv *.table ../HTML
mv  prgraph.tex ../HTML

#################################################################
## EDIT EVAL

echo Aggregation per category...

/bin/rm -rf .r1xx .r2xx .r3xx

mkdir .r1xx
cp -r 1?? .r1xx
cd .r1xx
$JAVA -Xmx1200m -cp $JAVALIB/procalign.jar fr.inrialpes.exmo.align.util.GroupEval -c -l $FILES > ../../HTML/1xx.html
cd ..

mkdir .r2xx
cp -r 2?? .r2xx
cd .r2xx
$JAVA -Xmx1200m -cp $JAVALIB/procalign.jar fr.inrialpes.exmo.align.util.GroupEval -c -l $FILES > ../../HTML/2xx.html
cd ..

mkdir .r3xx
cp -r 3?? .r3xx
cd .r3xx
$JAVA -Xmx1200m -cp $JAVALIB/procalign.jar fr.inrialpes.exmo.align.util.GroupEval -c -l $FILES > ../../HTML/3xx.html
cd ..

#################################################################
## GENERALIZED P and R

echo Relaxed precision and recall... [currently only Symetric]

$JAVA -Xmx1800m -cp $JAVALIB/procalign.jar fr.inrialpes.exmo.align.util.ExtGroupEval -f s -c -l $FILES > ../HTML/symresults.html

#$JAVA -Xmx1800m -cp $JAVALIB/procalign.jar fr.inrialpes.exmo.align.util.ExtGroupEval -f e -c -l $FILES > ../HTML/effresults.html

#$JAVA -Xmx1800m -cp $JAVALIB/procalign.jar fr.inrialpes.exmo.align.util.ExtGroupEval -f o -c -l $FILES > ../HTML/ordresults.html

#################################################################
## Comparison with last year

echo ">>> Comparison with last year"

/bin/rm -rf .2007
mkdir ../HTML/2007

mkdir .2007
cp -r ??? .2007
cd .2007
for file in $COMP
do
$JAVA -Xmx1200m -cp $JAVALIB/procalign.jar fr.inrialpes.exmo.align.util.GroupEval -c -l refalign,edna,$file > ../../HTML/${file}2007.html
done

$JAVA -Xmx1200m -cp $JAVALIB/procalign.jar fr.inrialpes.exmo.align.util.GroupEval -c -l $FILES > ../../HTML/2007/results.html

$JAVA -Xmx1200m -cp $JAVALIB/procalign.jar fr.inrialpes.exmo.align.util.GenPlot -l $FILES -t tex -o prgraph.tex

mv *.table ../../HTML/2007
mv  prgraph.tex ../../HTML/2007

mkdir .r1xx
mv 1?? .r1xx
cd .r1xx
$JAVA -Xmx1200m -cp $JAVALIB/procalign.jar fr.inrialpes.exmo.align.util.GroupEval -c -l $FILES > ../../../HTML/2007/2007-1.html
cd ..

mkdir .r2xx
mv 2?? .r2xx
cd .r2xx
$JAVA -Xmx1200m -cp $JAVALIB/procalign.jar fr.inrialpes.exmo.align.util.GroupEval -c -l $FILES > ../../../HTML/2007/2007-2.html
cd ..

mkdir .r3xx
mv 3?? .r3xx
cd .r3xx
$JAVA -Xmx1200m -cp $JAVALIB/procalign.jar fr.inrialpes.exmo.align.util.GroupEval -c -l $FILES > ../../../HTML/2007/2007-3.html
cd ..

cd ..

#################################################################
## 2004
echo Comparison with 2004...

/bin/rm -rf .2004
mkdir ../HTML/2004

mkdir .2004
cp -r 1?? 201 202 203 204 205 206 221 222 223 224 225 228 230 3?? .2004
cd .2004

$JAVA -Xmx1200m -cp $JAVALIB/procalign.jar fr.inrialpes.exmo.align.util.GroupEval -c -l $FILES > ../../HTML/2004/results.html

mkdir .r1xx
cp -r 1?? .r1xx
cd .r1xx
$JAVA -Xmx1200m -cp $JAVALIB/procalign.jar fr.inrialpes.exmo.align.util.GroupEval -c -l $FILES > ../../../HTML/2004/1xx.html
cd ..

mkdir .r2xx
cp -r 2?? .r2xx
cd .r2xx
$JAVA -Xmx1200m -cp $JAVALIB/procalign.jar fr.inrialpes.exmo.align.util.GroupEval -c -l $FILES > ../../../HTML/2004/2xx.html
cd ..

mkdir .r3xx
cp -r 3?? .r3xx
cd .r3xx
$JAVA -Xmx1200m -cp $JAVALIB/procalign.jar fr.inrialpes.exmo.align.util.GroupEval -c -l $FILES > ../../../HTML/2004/3xx.html
cd ..

cd ..

