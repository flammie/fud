#!/bin/bash
GITHUB=https://raw.githubusercontent.com/UniversalDependencies

if test $# -lt 2 -o $# -gt 3 ; then
    echo "Usage: $0 TREEBANK-ID LANGCODE [train|dev|test]"
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
TREEPART=train
if test $# = 3 ; then
    TREEPART=$3
fi
echo $1 is $TREELANG language treebank $TREEBANK

if test -f data/${TLC}_$TREELOWER-ud-$TREEPART.conllu ; then
    echo data/${TLC}_$TREELOWER-ud-$TREEPART.conllu is already downloaded
else
    wget -O data/${TLC}_${TREELOWER}-ud-${TREEPART}.conllu \
        $GITHUB/UD_$TREELANG-$TREEBANK/master/${TLC}_$TREELOWER-ud-$TREEPART.conllu
fi
if test -f data/symbols.$TLC ; then
    echo data/symbols.$TLC is already there
else
    wget -O data/feat_val.$TLC $GITHUB/tools/master/data/feat_val.$TLC
    wget -O data/deprel.$TLC $GITHUB/tools/master/data/deprel.$TLC
    if ! test -f data/symbols.ud ; then
        bash getsymbols.bash
    fi
    cat data/cpos.ud data/feat_val.ud data/deprel.ud \
        data/feat_val.$TLC data/deprel.$TLC |\
        sed -e 's/^/|/' > data/symbols.$TLC
fi
