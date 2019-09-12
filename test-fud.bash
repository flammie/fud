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

if test -f data/$LMPREFIX.conllu ; then
    python3 fud-morph.py -a models/${LMPREFIX}.tropical-a1.hfstol -i data/${LMPREFIX}.conllu \
        > data/${LMPREFIX}.reconllu
    python3 conllu-compare.py -r data/${LMPREFIX}.conllu -H data/${LMPREFIX}.reconllu \
        -t 0 -l data/${LMPREFIX}.log
fi
if test -f data/$DEVPREFIX.conllu ; then
    python3 fud-morph.py -a models/${LMPREFIX}.tropical-a1.hfstol -i data/${DEVPREFIX}.conllu \
        > data/$DEVPREFIX.reconllu
    python3 conllu-compare.py -r data/${DEVPREFIX}.conllu -H data/${DEVPREFIX}.reconllu \
        -t 0 -l data/${DEVPREFIX}.log
fi
if test -f data/$TESTPREFIX.conllu ; then
    python3 fud-morph.py -a models/${LMPREFIX}.tropical-a1.hfstol -i data/${TESTPREFIX}.conllu \
        > data/$TESTPREFIX.reconllu
    python3 conllu-compare.py -r data/${TESTPREFIX}.conllu -H data/${TESTPREFIX}.reconllu \
        -t 0 -l data/${TESTPREFIX}.log
fi

