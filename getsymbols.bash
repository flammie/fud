#!/bin/bash

if test -f data/symbols.ud ; then
    echo symbols.ud already exists
    exit 1
fi

wget -O data/cpos.ud https://raw.githubusercontent.com/UniversalDependencies/tools/master/data/cpos.ud
wget -O data/feat_val.ud https://raw.githubusercontent.com/UniversalDependencies/tools/master/data/feat_val.ud
wget -O data/deprel.ud https://raw.githubusercontent.com/UniversalDependencies/tools/master/data/deprel.ud

cat data/cpos.ud data/feat_val.ud data/deprel.ud |\
    sed -e 's/^/|/' > symbols.ud
