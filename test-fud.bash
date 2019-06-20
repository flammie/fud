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
DEVPREFIX=${TLC}_${TREELOWER}-ud-dev
TESTPREFIX=${TLC}_${TREELOWER}-ud-test
echo $1 is $TREELANG language treebank $TREEBANK
bash fetch-train.bash $1 $2 train
bash fetch-train.bash $1 $2 dev
bash fetch-train.bash $1 $2 test

if test -f $LMPREFIX.conllu ; then
    python3 fud.py -a ${LMPREFIX}.tropical-a1.hfstol -i ${LMPREFIX}.conllu \
        > ${LMPREFIX}.reconllu
    python3 conllu-compare.py -r ${LMPREFIX}.conllu -H ${LMPREFIX}.reconllu \
        -t 0 -l ${LMPREFIX}.log
fi
if test -f $DEVPREFIX.conllu ; then
    python3 fud.py -a ${LMPREFIX}.tropical-a1.hfstol -i ${DEVPREFIX}.conllu \
        > $DEVPREFIX.reconllu
    python3 conllu-compare.py -r ${DEVPREFIX}.conllu -H ${DEVPREFIX}.reconllu \
        -t 0 -l ${DEVPREFIX}.log
fi
if test -f $TESTPREFIX.conllu ; then
    python3 fud.py -a ${LMPREFIX}.tropical-a1.hfstol -i ${TESTPREFIX}.conllu \
        > $TESTPREFIX.reconllu
    python3 conllu-compare.py -r ${TESTPREFIX}.conllu -H ${TESTPREFIX}.reconllu \
        -t 0 -l ${TESTPREFIX}.log
fi

