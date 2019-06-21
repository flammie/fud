#!/bin/bash

while read l ; do
    echo $l
    bash make-fud.bash $l
    bash test-fud.bash $l
done < treebanks.tsv
