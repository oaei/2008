#!/bin/csh
# $Id$
# XSLT based test generation.
# //pass1: generate test files
# //pass2: fix URI
# //pass3: generate HTML

echo
echo Generating files
echo "================"

# //pass1: generate test files

#####################################################################
# 101) Concept test: Id

#DONE!
/bin/rm -rf 101
mkdir 101
cp onto.rdf 101/
cp refalign.rdf 101/

#####################################################################
# 102) Concept test: ?
# JUST TO BE COPIED

#####################################################################
# 103) Concept test: Language generalisation
#//TO BE UPDATED

#This test compares the ontology with its generalisation in OWL Lite
# (i.e., unavailable constraints are replaced by the more general available).
# The generalization basically removes owl:unionOf and  owl:oneOf
# and the Property types (owl:TransitiveProperty).

#####################################################################
# 104) Concept test: Language restriction
#//TO BE UPDATED

#This test compares the ontology with its restriction in OWL Lite  (where unavailable constraints have been discarded).

#####################################################################
# 201) Systematic: No names
#Each label or identifier is replaced by a random one.

#DONE!
\rm -rf 201
mkdir 201
xsltproc xslt/trans-random.xsl onto.rdf > 201/onto.rdf
xsltproc xslt/trans-random.xsl refalign.rdf > 201/refalign.rdf

#####################################################################
# 202) Systematic: No names, no comment
#Each label or identifier is replaced by a random one. Comments  (rdfs:comment and dc:description) have been suppressed as well.

#DONE!
\rm -rf 202
mkdir 202
xsltproc xslt/strip-comments.xsl 201/onto.rdf > 202/onto.rdf
xsltproc xslt/trans-random.xsl refalign.rdf > 202/refalign.rdf

# 203) Systematic: No comment (was Misspelling)

#DONE!
\rm -rf 203
mkdir 203
xsltproc xslt/trans-comments.xsl onto.rdf > 203/onto.rdf
cp refalign.rdf 203/refalign.rdf

#####################################################################
# 204) Systematic: Naming conventions
#Different naming conventions (Uppercasing, underscore, dash, etc.)  are used for labels. Comments have been suppressed.

#DONE!
\rm -rf 204
mkdir 204
xsltproc xslt/trans-conv.xsl onto.rdf > 204/onto.rdf
xsltproc xslt/trans-conv.xsl refalign.rdf > 204/refalign.rdf

#####################################################################
# 205) Systematic: Synonyms
# Labels are replaced by synonyms. Comments have been suppressed.

#DONE!
\rm -rf 205
mkdir 205
xsltproc xslt/trans-synonyms.xsl onto.rdf > 205/onto.rdf
xsltproc xslt/trans-synonyms.xsl refalign.rdf > 205/refalign.rdf

#####################################################################
# 206) Systematic: Foreign names (including comments)
#The complete ontology is translated to another language than  english (French in the current case, but other languages would be fine).

#//TO BE IMPROVED
\rm -rf 206
mkdir 206
xsltproc xslt/trans-foreign.xsl onto.rdf > 206/onto.rdf
xsltproc xslt/trans-foreign.xsl refalign.rdf > 206/refalign.rdf

#####################################################################
# 207) Systematic: Foreign names
#The complete ontology is translated to another language than  english (French in the current case, but other languages would be fine).

#DONE!
\rm -rf 207
mkdir 207
xsltproc xslt/trans-foreign.xsl onto.rdf > 207/onto.rdf
xsltproc xslt/trans-foreign.xsl refalign.rdf > 207/refalign.rdf

#####################################################################
# 208) Systematic: Convention and no comments

#DONE!
\rm -rf 208
mkdir 208
xsltproc xslt/strip-comments.xsl 204/onto.rdf > 208/onto.rdf
cp 204/refalign.rdf 208/refalign.rdf

#####################################################################
# 209) Systematic: Synonyms and no comments

#DONE!
\rm -rf 209
mkdir 209
xsltproc xslt/strip-comments.xsl 205/onto.rdf > 209/onto.rdf
cp 205/refalign.rdf 209/refalign.rdf

#####################################################################
# 210) Systematic: Foreign language and no comments

#DONE!
\rm -rf 210
mkdir 210
xsltproc xslt/strip-comments.xsl 207/onto.rdf > 210/onto.rdf
cp 207/refalign.rdf 210/refalign.rdf

#####################################################################
# 221) Systematic: No hierarchy
#All subclass assertions to named classes are suppressed.
#(variation: compile inheritance)

#DONE!
\rm -rf 221
mkdir 221
xsltproc xslt/strip-subclass.xsl onto.rdf > 221/onto.rdf
cp refalign.rdf 221/refalign.rdf

#####################################################################
# 222) Systematic: Flattened hierarchy
#A hierarchy still exists but has been strictly reduced.

#//TO BE UPDATED

#####################################################################
# 223) Systematic: Expanded hierarchy
#Numerous intermediate classes are introduced within the hierarchy.

#//TO BE UPDATED

#####################################################################
# 224) Systematic: No instances
#All individuals have been suppressed from the ontology.

# DONE!
\rm -rf 224
mkdir 224
xsltproc xslt/strip-instances.xsl onto.rdf > 224/onto.rdf
cp refalign.rdf 224/refalign.rdf

#####################################################################
# 225) Systematic: No restrictions
#All local restrictions on properties have been suppressed from the ontology.
#(variation: no property nor global restrictions on properties)

# DONE!
\rm -rf 225
mkdir 225
xsltproc xslt/strip-restrictions.xsl onto.rdf > 225/onto.rdf
cp refalign.rdf 225/refalign.rdf

# 226) Systematic: No datatypes
#NOTTODO

# 227) Systematic: Unit differences
#NOTTODO

#####################################################################
# 228) Systematic: No properties
#Properties and relations between objects have been completely suppressed.
#(variation: leave the properties in instances)

#//MISS ALIGNMENT MODIFICATION
\rm -rf 228
mkdir 228
xsltproc xslt/strip-properties.xsl onto.rdf > 228/onto.rdf

# 229) Systematic: Class vs instances
#NOTTODO

#####################################################################
# 230) Systematic: Flattening entities
#Some components of classes are expanded in the class structure  (e.g., year, month, day attributes instead of date).
#Here one limitation of the proposed format is that it does not cover  alignments such as: journalName = name o journal.

#//TO BE UPDATED

# 231) Systematic: Multiplying entities
#Some classes are spreaded over several classes.
#Not available in this test.

#NOTTODO

#####################################################################
# 232) Systematic: No instances, No hierarchy

# DONE!
\rm -rf 232
mkdir 232
xsltproc xslt/strip-instances.xsl 221/onto.rdf > 232/onto.rdf
cp 221/refalign.rdf 232/refalign.rdf

#####################################################################
# 233) Systematic: No property, No hierarchy

# //MISSING STUFF
\rm -rf 233
mkdir 233
xsltproc xslt/strip-properties.xsl 221/onto.rdf > 233/onto.rdf

#####################################################################
# 248) Systematic: No names, no hierarchy

# DONE
\rm -rf 248
mkdir 248
xsltproc xslt/strip-subclass.xsl 202/onto.rdf > 248/onto.rdf
cp 202/refalign.rdf 248/refalign.rdf

#####################################################################
# 249) Systematic: No names, no instances

# DONE
\rm -rf 249
mkdir 249
xsltproc xslt/strip-instances.xsl 202/onto.rdf > 249/onto.rdf
cp 202/refalign.rdf 249/refalign.rdf

#####################################################################
# //pass2: fix URI
# DONE!

echo
echo Fixing URI
echo "=========="

#for i in `ls -d [0-9][0-9][0-9]` 
#do
#echo "**" $i "**"
#if [ -f $i/refalign.rdf ]
#then
#ed $i/refalign.rdf << EOF
#1,$ s;entity2 rdf:resource="http://oaei.inrialpes.fr/2005/benchmark/101/;entity2 rdf:resource="http://oaei.inrialpes.fr/2005/benchmark/$i/;
#w
#EOF
#fi
#if [ -f $i/onto.rdf ]
#then
#ed $i/onto.rdf << EOF
#1,$ s;oaei.inrialpes.fr/2005/benchmark/101/;oaei.inrialpes.fr/2005/benchmark/$i/;
#w
#EOF
#fi
#done

#####################################################################
# //pass3: generate HTML
# DONE!

echo
echo Generating HTML
echo "==============="

#for i in `ls -d [0-9][0-9][0-9]` 
#do
#echo "**" $i "**"
#xsltproc xslt/form-align.xsl $i/refalign.rdf > $i/refalign.html
#xsltproc xslt/owl2html.xsl $i/onto.rdf > $i/onto.html
#done

