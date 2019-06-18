#!/bin/bash
GITHUB=https://raw.githubusercontent.com/UniversalDependencies

if test $# != 2 ; then
    echo Usage: $0 TREEBANK-ID LANGCODE
    echo
    echo Downloads UD treebank training data for TREEBANK-ID,
    echo TREEBANK-ID is LanguageName-TreebankName, e.g. Finnish-TDT
    echo LANGCODE is the language code used in filename, i.e. ISO-639 code,
    echo e.g. fi
    exit 1
fi

TREELANG=${1%-*}
TREEBANK=${1#*-}
TREELOWER=$(echo $TREEBANK | tr '[[:upper:]]' '[[:lower:]]')
TLC=$2
echo $1 is $TREELANG language treebank $TREEBANK

if test -f ${TLC}_$TREELOWER-ud-train.conllu ; then
    echo ${TLC}_$TREELOWER-ud-train.conllu is already downloaded
else
    wget $GITHUB/UD_$TREELANG-$TREEBANK/master/${TLC}_$TREELOWER-ud-train.conllu
fi
if test -f symbols.$TLC ; then
    echo symbols.$TLC is already there
else
    wget $GITHUB/tools/master/data/feat_val.$TLC
    if ! test -f symbols.ud ; then
        bash getsymbols.bash
    fi
    cat symbols.ud feat_val.$TLC > symbols.$TLC
fi