#!/bin/bash

if test -f symbols.ud ; then
    echo symbols.ud already exists
    exit 1
fi

wget https://raw.githubusercontent.com/UniversalDependencies/tools/master/data/cpos.ud
wget https://raw.githubusercontent.com/UniversalDependencies/tools/master/data/feat_val.ud

cat cpos.ud feat_val.ud > symbols.ud
