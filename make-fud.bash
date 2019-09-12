#!/bin/bash

if test $# -lt 2 -o $# -gt 3; then
    echo "Usage: $0 TREEBANK-ID LANGCODE [train|dev|test]"
    echo
    echo Downloads UD treebank training data for TREEBANK-ID,
    echo TREEBANK-ID is LanguageName-TreebankName, e.g. Finnish-TDT
    echo LANGCODE is the language code used in filename, i.e. ISO-639 code,
    echo e.g. fi
    echo select test if language does not have train data, train is default
    exit 1
fi

TREELANG=${1%-*}
TREEBANK=${1#*-}
TREELOWER=$(echo $TREEBANK | tr '[[:upper:]]' '[[:lower:]]')
TLC=$2
TREEPART=train
if test $# = 3 ; then
    TREEPART=$3
fi
LMPREFIX=${TLC}_${TREELOWER}-ud-$TREEPART
echo $1 is $TREELANG language treebank $TREEBANK
echo we create language model data in ${LMPREFIX}.\*
if ! test -d data ; then
    mkdir data
fi
if ! test -f data/${LMPREFIX}.conllu ; then
    bash ./fetch-train.bash $@
fi
if ! test -d models ; then
    mkdir models
fi
gawk -f conllu2fststrings.awk < data/${LMPREFIX}.conllu > data/${LMPREFIX}.hfststrings
wc -l < data/${LMPREFIX}.hfststrings > data/${LMPREFIX}.tokencount
sort < data/${LMPREFIX}.hfststrings | uniq -c > data/${LMPREFIX}.sortuniqc
wc -l < data/${LMPREFIX}.sortuniqc > data/${LMPREFIX}.typecount
gawk -f tropicalize-uniq-c-add-smoothing.awk \
    --assign=CS=$(<data/${LMPREFIX}.tokencount)\
    --assign=LS=$(<data/${LMPREFIX}.typecount) < data/${LMPREFIX}.sortuniqc > \
    data/${LMPREFIX}.tropical-a1.hfststrings
hfst-strings2fst -j -m data/symbols.$TLC -i data/${LMPREFIX}.tropical-a1.hfststrings \
    -o models/${LMPREFIX}.tropical-a1.hfst
hfst-minimize -i models/${LMPREFIX}.tropical-a1.hfst |\
    hfst-fst2fst -f olw -o models/${LMPREFIX}.tropical-a1.hfstol

